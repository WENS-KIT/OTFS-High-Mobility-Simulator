%% OTFS_IM_Vs_OFDM_IM.m
% Standalone BER comparison: OTFS-IM vs OFDM-IM

% Requirements on path (your existing ones):
%   getChannelParams, getG, helperOTFSmod, helperOTFSdemod, dopplerChannel,
%   equalizeOTFS, equalizeOFDM, ofdmmod, ofdmdemod, buildConstellation

% Adnan Tariq (adnantariq@kumoh.ac.kr)
%A. Tariq, M. Sajid Sarwar and S. Y. Shin, "Orthogonal Time-Frequency–Space Multiple Access Using Index Modulation and NOMA,"
% in IEEE Wireless Communications Letters, vol. 14, no. 5, pp. 1456-1460, May 2025, doi: 10.1109/LWC.2025.3544234
%
%A. Tariq, M. S. Sarwar and S. Y. Shin, "Orthogonal Time Frequency Space (OTFS) with Tri-Mode Index Modulation," 
%2024 15th International Conference on Information and Communication Technology Convergence (ICTC), Jeju Island, Korea, Republic of, 2024, pp. 1183-1186, doi: 10.1109/ICTC62082.2024.10827438.

clc; clear; close all;
rng(0,'v4');

%% ===================== 0) USER SETTINGS (edit these) =====================

P.M = 32;                   % Delay resources (subcarriers)
P.N = 32;                   % Doppler resources (subsymbols)

P.Mod_IM   = 4;                 % OTFS-IM / OFDM-IM modulation order
P.Mod_type = "QAM";             % "PSK" or "QAM"

P.propModel    = "TDL-C";       %e.g., "TDL-A","TDL-B","TDL-C" or your custom strings
P.maxSpeed_kmh = 350;           % 0~1000kmh 

P.cest_Type = "Perfect";         % "Perfect" | "LS" | "MMSE"
P.eqType    = "LMMSE";          % "LMMSE" or "ZF"

P.padType = 'ZP';
P.df = 15e3;
P.fc = 5e9;
P.SNRdB = 0:3:30;

% IM parameters
P.n = 4;                        % DDRBs per group
P.k = 2;                        % active DDRBs per group
P.enableIMPowerNorm = true;     % scales IM grids by sqrt(n/k)

% frames auto (your style)
if P.M > 32 || P.N > 32
    P.NUM_FRAMES = 15;
elseif P.M > 16 || P.N > 16
    P.NUM_FRAMES = 30;
else
    P.NUM_FRAMES = 60;
end

P.eqType = localNormalizeEqType(P.eqType);

%% ===================== sanity checks =====================
assert(any(P.Mod_type == ["PSK","QAM"]), 'Mod_type must be "PSK" or "QAM".');
assert(P.k>=1 && P.k<=P.n, 'IM: k must be between 1 and n.');
assert(mod(P.M*P.N, P.n)==0, 'IM: M*N must be divisible by n.');
assert(abs(log2(P.Mod_IM) - round(log2(P.Mod_IM))) < 1e-12, 'Mod_IM must be power of 2.');

BW    = P.M * P.df;
fsamp = BW;
Groups = (P.M*P.N) / P.n;

%% ===================== IM index mapping (patched, consistent) =====================
posComb_all = nchoosek(1:P.n, P.k);
numPos_all  = size(posComb_all, 1);

bits_per_index = floor(log2(numPos_all));     % IM standard: use 2^b subset
numPos         = 2^bits_per_index;
posComb        = posComb_all(1:numPos, :);    % reduced set used everywhere

bits_per_sym      = P.k * log2(P.Mod_IM);
TotalBitsPerGroup = bits_per_index + bits_per_sym;

% index bits LUT
if bits_per_index == 0
    idx2bits = zeros(1,0);
else
    idx2bits = de2bi(0:(numPos-1), bits_per_index, 'left-msb'); % size numPos x bits_per_index
end

% IM constellation and symbol-combination LUTs (no combvec dependency)
symConst_IM = buildConstellation(P.Mod_IM, P.Mod_type);
[C_mat, I_mat] = localMakeSymbolCombos(symConst_IM, P.Mod_IM, P.k); %#ok<NASGU>
L_symComb = size(C_mat,2);

if P.enableIMPowerNorm
    imScale = sqrt(P.n / P.k);
else
    imScale = 1;
end

fprintf('=== OTFS-IM vs OFDM-IM (Patched) ===\n');
fprintf('M=%d, N=%d, Groups=%d, n=%d, k=%d, BW=%.3f MHz, eq=%s\n', ...
    P.M, P.N, Groups, P.n, P.k, BW/1e6, P.eqType);
fprintf('Index set: nCk=%d, using %d (=2^{%d}) patterns\n', numPos_all, numPos, bits_per_index);
fprintf('Mod-IM=%d (%s), bits/group=%d, Frames/SNR=%d\n\n', ...
    P.Mod_IM, P.Mod_type, TotalBitsPerGroup, P.NUM_FRAMES);

%% ===================== 1) Channel parameters + OTFS G matrix =====================
one_delay_tap = 1/BW;
[delays, dopplers, pdp] = getChannelParams(P.maxSpeed_kmh, P.fc, P.propModel);

pdp = pdp(:);
pdp = pdp / max(pdp + eps);

chanParams.pathDelays = round(delays ./ one_delay_tap);
chanParams.pathGains  = pdp;

padLen  = max(chanParams.pathDelays);
Meff    = P.M + padLen;
numSamp = Meff * P.N;

T = (P.M + padLen)/BW;
one_doppler_tap = 1/(P.N*T);
chanParams.pathDopplers     = round(dopplers / one_doppler_tap);
chanParams.pathDopplerFreqs = chanParams.pathDopplers * one_doppler_tap;

G   = getG(P.M, P.N, chanParams, padLen, P.padType);
Gt  = G';
GtG = Gt*G;

%% ===================== 2) Allocate BER arrays =====================
SNRdB = P.SNRdB;
BER_OTFS_IM = zeros(size(SNRdB));
BER_OFDM_IM = zeros(size(SNRdB));

%% ===================== 3) Main SNR loop =====================
for iS = 1:numel(SNRdB)
    snrDB = SNRdB(iS);

    Es_ref = mean(abs(symConst_IM).^2);
    n0     = Es_ref / (10^(snrDB/10));

    err_otfs_im  = 0; bits_otfs_im  = 0;
    err_ofdm_im  = 0; bits_ofdm_im  = 0;

    for f = 1:P.NUM_FRAMES
        %% (A) OFDM pilots for this frame
        pilotSym  = exp(1i*pi/4);
        pilotGrid = pilotSym * ones(P.M, P.N);

        tx_ofdm_p = ofdmmod(pilotGrid, P.M, padLen);
        rx_ofdm_p = dopplerChannel(tx_ofdm_p, fsamp, chanParams);
        rx_ofdm_p = awgn(rx_ofdm_p, snrDB, 'measured');
        Yp = ofdmdemod(rx_ofdm_p(1:(P.M+padLen)*P.N), P.M, padLen);
        Hofdm_est = Yp ./ pilotGrid;

        %% (B) Build IM grid (patched local function: uses reduced posComb)
        [Xgrid_im, in_index] = buildIMGrid(Groups, P.n, P.k, posComb, numPos, C_mat, L_symComb);
        Xgrid_im = reshape(Xgrid_im, P.M, P.N) * imScale;

        %% (C) OTFS-IM
        tx_otfs_im = helperOTFSmod(Xgrid_im, padLen, P.padType);
        rx_otfs_im = dopplerChannel(tx_otfs_im, fsamp, chanParams);
        rx_otfs_im = awgn(rx_otfs_im, snrDB, 'measured');
        rx_otfs_im = rx_otfs_im(1:numSamp);

        y_est_im = equalizeOTFS(rx_otfs_im, G, GtG, n0, P.eqType);
        Xhat_im  = helperOTFSdemod(y_est_im, P.M, padLen, 0, P.padType);

        e_im_bits    = detectIMbits(Xhat_im, in_index, Groups, P.n, P.k, posComb, idx2bits, [], P.Mod_IM, P.Mod_type);
        err_otfs_im  = err_otfs_im  + e_im_bits;
        bits_otfs_im = bits_otfs_im + Groups * TotalBitsPerGroup;

        %% (D) OFDM-IM
        tx_ofdm_im = ofdmmod(Xgrid_im, P.M, padLen);
        rx_ofdm_im = dopplerChannel(tx_ofdm_im, fsamp, chanParams);
        rx_ofdm_im = awgn(rx_ofdm_im, snrDB, 'measured');
        Yim = ofdmdemod(rx_ofdm_im(1:(P.M+padLen)*P.N), P.M, padLen);

        Xhat_ofdm_im = equalizeOFDM(Yim, Hofdm_est, n0, P.eqType);

        e_ofdm_im_bits = detectIMbits(Xhat_ofdm_im, in_index, Groups, P.n, P.k, posComb, idx2bits, [], P.Mod_IM, P.Mod_type);
        err_ofdm_im    = err_ofdm_im  + e_ofdm_im_bits;
        bits_ofdm_im   = bits_ofdm_im + Groups * TotalBitsPerGroup;
    end

    BER_OTFS_IM(iS) = err_otfs_im / bits_otfs_im;
    BER_OFDM_IM(iS) = err_ofdm_im / bits_ofdm_im;

    fprintf('[SNR %2d dB] OTFS-IM=%.3e | OFDM-IM=%.3e\n', snrDB, BER_OTFS_IM(iS), BER_OFDM_IM(iS));
end

%% ===================== 4) Plot =====================
titleBase = sprintf('M=%d,N=%d, %s, v=%.1f km/h', P.M, P.N, P.propModel, P.maxSpeed_kmh);

figure('Name','OTFS-IM vs OFDM-IM');
semilogy(SNRdB, BER_OTFS_IM, '-o', SNRdB, BER_OFDM_IM, '--s', 'LineWidth', 2.5, 'MarkerSize', 9);
grid on; box on;
xlabel('Tx SNR (dB)','FontName','Times New Roman','FontSize',14);
ylabel('BER','FontName','Times New Roman','FontSize',14);
legend('OTFS-IM','OFDM-IM','Location','southwest','FontName','Times New Roman','FontSize',13);
title(sprintf('n=%d,k=%d, Mod-IM=%d  |  %s', P.n, P.k, P.Mod_IM, titleBase), 'Interpreter','none');

%% ===================== 5) Return results struct =====================
results.P = P;
results.padLen = padLen;
results.BER_OTFS_IM = BER_OTFS_IM;
results.BER_OFDM_IM = BER_OFDM_IM;

%% ===================== Local helpers =====================
function eq = localNormalizeEqType(eqIn)
    eq = upper(string(eqIn));
    if contains(eq,"MMSE")
        eq = "LMMSE";
    elseif contains(eq,"ZF")
        eq = "ZF";
    else
        eq = "LMMSE";
    end
end

function [C_mat, I_mat] = localMakeSymbolCombos(symConst, ModIM, k)
% Returns:
%   C_mat: k x (ModIM^k) symbols
%   I_mat: k x (ModIM^k) integer indices (0..ModIM-1)
    grids = cell(1,k);
    [grids{:}] = ndgrid(0:(ModIM-1));          % 0-based indices
    I_mat = zeros(k, numel(grids{1}));
    for ii = 1:k
        I_mat(ii,:) = grids{ii}(:).';
    end
    C_mat = symConst(I_mat + 1);               % map to symbols (1-based indexing)
end

function [Xvec, in_index] = buildIMGrid(Groups, n, k, posComb, numPos, C_mat, L_symComb)
% Patched IM grid builder consistent with reduced posComb (size numPos x k)
% Output:
%   Xvec: length Groups*n vector (to reshape into MxN later)
%   in_index.posIdx: true position-index (1..numPos) per group
%   in_index.symIdx0: true symbol indices (0..ModIM-1) per group (1 x k)

    Xvec = zeros(Groups*n, 1);

    in_index.posIdx  = zeros(Groups,1);
    in_index.symIdx0 = zeros(Groups,k);

    for g = 1:Groups
        base = (g-1)*n;

        posIdx = randi(numPos);                 % 1..numPos (reduced set)
        activePos = posComb(posIdx,:);          % 1..n

        symComboIdx = randi(L_symComb);         % 1..L_symComb
        syms = C_mat(:, symComboIdx);           % k x 1 complex symbols

        % Fill group vector
        Xg = zeros(n,1);
        Xg(activePos) = syms;

        Xvec(base + (1:n)) = Xg;

        % store truth
        in_index.posIdx(g) = posIdx;

        % derive true symbol indices from C_mat by nearest constellation index is expensive;
        % instead, reconstruct from syms by matching inside C_mat column:
        % we can do it directly: C_mat was built from indices, but we do not have I_mat here.
        % So store symbol indices by finding the nearest in each row of constellation later:
        % easiest: store the transmitted symbols themselves:
        in_index.txSyms(g,:) = syms(:).'; %#ok<AGROW>
        in_index.activePos(g,:) = activePos(:).'; %#ok<AGROW>
    end
end

function errBits = detectIMbits(Xhat_grid, in_index, Groups, n, k, posComb, idx2bits, ~, ModIM, ModType)
% Patched detector + bit error counter:
% - Energy-based index detection (pick k largest |.|)
% - Symbol detection by nearest constellation
% - Index bits mapped using idx2bits (consistent with reduced posComb)

    % cached constellation
    persistent lastM lastT const;
    if isempty(const) || lastM ~= ModIM || lastT ~= string(ModType)
        const = buildConstellation(ModIM, string(ModType));
        lastM = ModIM;
        lastT = string(ModType);
    end

    bits_per_index = size(idx2bits,2);
    bSym = log2(ModIM);

    Xvec = reshape(Xhat_grid, [], 1); % length M*N = Groups*n
    errBits = 0;

    for g = 1:Groups
        idx_start = (g-1)*n + 1;
        idx_end   = g*n;
        rxGroup   = Xvec(idx_start:idx_end);

        % ---- TRUE bits (from stored truth) ----
        posIdx_true = in_index.posIdx(g);
        if bits_per_index == 0
            bits_idx_true = zeros(1,0);
        else
            bits_idx_true = idx2bits(posIdx_true, :);
        end

        % true symbols were stored explicitly
        txSyms_true = in_index.txSyms(g,:);           % 1 x k (complex)
        symIdx0_true = zeros(1,k);
        for ii = 1:k
            [~,iiMin] = min(abs(txSyms_true(ii) - const).^2);
            symIdx0_true(ii) = iiMin - 1;            % 0..ModIM-1
        end
        bits_sym_true = reshape(de2bi(symIdx0_true, bSym, 'left-msb'), 1, []);

        bits_true = [bits_idx_true, bits_sym_true];

        % ---- DETECT index positions (energy) ----
        [~, sortIdx] = sort(abs(rxGroup), 'descend');
        detectedPos  = sort(sortIdx(1:k));            % 1..n, sorted

        % map detected positions to reduced posComb
        [tf, posIdx_hat] = ismember(detectedPos(:).', posComb, 'rows');
        if ~tf
            posIdx_hat = 1; % arbitrary valid row; will create bit errors naturally
        end

        if bits_per_index == 0
            bits_idx_hat = zeros(1,0);
        else
            bits_idx_hat = idx2bits(posIdx_hat, :);
        end

        % ---- DETECT symbols on detected positions ----
        zhat = rxGroup(detectedPos);
        symIdx0_hat = zeros(1,k);
        for ii = 1:k
            [~,iiMin] = min(abs(zhat(ii) - const).^2);
            symIdx0_hat(ii) = iiMin - 1;
        end
        bits_sym_hat = reshape(de2bi(symIdx0_hat, bSym, 'left-msb'), 1, []);

        bits_hat = [bits_idx_hat, bits_sym_hat];

        % ---- count bit errors ----
        errBits = errBits + sum(bits_true ~= bits_hat);
    end
end