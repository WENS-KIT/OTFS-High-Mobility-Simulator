%% OTFS_vs_OTFSIM.m
% Standalone BER comparison: OTFS (full grid) vs OTFS-IM
%
% Requirements on path (your existing ones):
%   getChannelParams, getG, helperOTFSmod, helperOTFSdemod, dopplerChannel,
%   equalizeOTFS,
%   buildConstellation, modBitsToSyms, demodSymsToBits
%
% Adnan Tariq (adnantariq@kumoh.ac.kr)
%A. Tariq, M. Sajid Sarwar and S. Y. Shin, "Orthogonal Time-Frequency–Space Multiple Access Using Index Modulation and NOMA,"
% in IEEE Wireless Communications Letters, vol. 14, no. 5, pp. 1456-1460, May 2025, doi: 10.1109/LWC.2025.3544234
%
%A. Tariq, M. S. Sarwar and S. Y. Shin, "Orthogonal Time Frequency Space (OTFS) with Tri-Mode Index Modulation," 
%2024 15th International Conference on Information and Communication Technology Convergence (ICTC), Jeju Island, Korea, Republic of, 2024, pp. 1183-1186, doi: 10.1109/ICTC62082.2024.10827438.
clc; clear; close all;
rng(0,'v4');

%% ===================== 0) USER SETTINGS =====================

P.M = 32;                  % Delay resources (subcarriers)
P.N = 32;                  % Doppler resources (subsymbols)

P.Mod_OTFS = 4;            % OTFS modulation order (full grid)
P.Mod_IM   = 4;            % OTFS-IM modulation order
P.Mod_type = "QAM";        % "PSK" or "QAM"

P.propModel    = "TDL-C";  % e.g., "TDL-A","TDL-B","TDL-C" or your custom strings
P.maxSpeed_kmh = 350;

P.cest_Type = "Perfect";   % "Perfect" | "LS" | "MMSE"
P.eqType    = "LMMSE";     %"LMMSE" or "ZF"


P.padType = 'ZP';
P.df = 15e3;
P.fc = 5e9;
P.SNRdB = 0:3:30;

% IM parameters
P.n = 4;                % DDRBs per group
P.k = 2;                % active DDRBs per group 
P.enableIMPowerNorm = true; % scales IM grids by sqrt(n/k)

% frames auto (your style)
if P.M > 32 || P.N > 32
    P.NUM_FRAMES = 15;
elseif P.M > 16 || P.N > 16
    P.NUM_FRAMES = 30;
else
    P.NUM_FRAMES = 60;
end

P.eqType = localNormalizeEqType(P.eqType);

assert(any(P.Mod_type == ["PSK","QAM"]), 'Mod_type must be "PSK" or "QAM".');
assert(P.k>=1 && P.k<=P.n, 'IM: k must be between 1 and n.');
assert(mod(P.M*P.N, P.n)==0, 'IM: M*N must be divisible by n.');
assert(abs(log2(P.Mod_OTFS) - round(log2(P.Mod_OTFS))) < 1e-12, 'Mod_OTFS must be power of 2.');
assert(abs(log2(P.Mod_IM)   - round(log2(P.Mod_IM)))   < 1e-12, 'Mod_IM must be power of 2.');

BW    = P.M * P.df;
fsamp = BW;

Groups = (P.M*P.N) / P.n;

%% ===================== IM index mapping (PATCHED) =====================
posComb_all = nchoosek(1:P.n, P.k);
numPos_all  = size(posComb_all, 1);

bits_per_index = floor(log2(numPos_all));     % standard IM: use 2^b subset
numPos         = 2^bits_per_index;            % >= 1
posComb        = posComb_all(1:numPos, :);    % reduced set used everywhere

bits_per_sym      = P.k * log2(P.Mod_IM);
TotalBitsPerGroup = bits_per_index + bits_per_sym;

% idx2bits LUT (guard for bits_per_index == 0)
if bits_per_index == 0
    idx2bits = zeros(1,0);
else
    idx2bits = de2bi(0:(numPos-1), bits_per_index, 'left-msb');
end

fprintf('=== OTFS vs OTFS-IM Simulation (Patched) ===\n');
fprintf('M=%d, N=%d, BW=%.3f MHz, eq=%s\n', P.M, P.N, BW/1e6, P.eqType);
fprintf('OTFS Mod=%d (%s) | OTFS-IM Mod=%d, n=%d, k=%d, Groups=%d\n', ...
    P.Mod_OTFS, P.Mod_type, P.Mod_IM, P.n, P.k, Groups);
fprintf('Index set: nCk=%d, using %d (=2^{%d}) patterns\n', numPos_all, numPos, bits_per_index);
fprintf('Channel=%s, v=%.1f km/h, fc=%.2f GHz, Frames/SNR=%d\n\n', ...
    P.propModel, P.maxSpeed_kmh, P.fc/1e9, P.NUM_FRAMES);

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

%% ===================== 2) Constellations + IM symbol-combo LUTs =====================
symConst_OTFS = buildConstellation(P.Mod_OTFS, P.Mod_type);
symConst_IM   = buildConstellation(P.Mod_IM,   P.Mod_type);

% Build all k-tuples of IM symbols (no combvec dependency)
[C_mat, ~] = localMakeSymbolCombos(symConst_IM, P.Mod_IM, P.k);
L_symComb  = size(C_mat, 2);

if P.enableIMPowerNorm
    imScale = sqrt(P.n / P.k);
else
    imScale = 1;
end

%% ===================== 3) Allocate BER arrays =====================
SNRdB = P.SNRdB;
BER_OTFS    = zeros(size(SNRdB));
BER_OTFS_IM = zeros(size(SNRdB));

%% ===================== 4) Main SNR loop =====================
for iS = 1:numel(SNRdB)
    snrDB = SNRdB(iS);

    % keep same style: n0 from OTFS constellation
    Es_ref = mean(abs(symConst_OTFS).^2);
    n0     = Es_ref / (10^(snrDB/10));

    err_otfs = 0;    bits_otfs = 0;
    err_im   = 0;    bits_im   = 0;

    for f = 1:P.NUM_FRAMES
        %% (A) OTFS full-grid payload
        bitsTX_full = randi([0 1], log2(P.Mod_OTFS)*P.M, P.N);
        Xgrid_full  = modBitsToSyms(bitsTX_full, P.Mod_OTFS, P.Mod_type);

        tx_otfs = helperOTFSmod(Xgrid_full, padLen, P.padType);
        rx_otfs = dopplerChannel(tx_otfs, fsamp, chanParams);
        rx_otfs = awgn(rx_otfs, snrDB, 'measured');
        rx_otfs = rx_otfs(1:numSamp);

        y_est_otfs = equalizeOTFS(rx_otfs, G, GtG, n0, P.eqType);
        Xhat_otfs  = helperOTFSdemod(y_est_otfs, P.M, padLen, 0, P.padType);

        bitsRX_otfs = demodSymsToBits(Xhat_otfs, P.Mod_OTFS, P.Mod_type);
        err_otfs  = err_otfs + biterr(bitsTX_full, bitsRX_otfs);
        bits_otfs = bits_otfs + numel(bitsTX_full);

        %% (B) OTFS-IM grid (patched local buildIMGrid)
        [Xgrid_im, in_index] = buildIMGrid(Groups, P.n, P.k, posComb, numPos, C_mat, L_symComb);
        Xgrid_im = reshape(Xgrid_im, P.M, P.N) * imScale;

        tx_otfs_im = helperOTFSmod(Xgrid_im, padLen, P.padType);
        rx_otfs_im = dopplerChannel(tx_otfs_im, fsamp, chanParams);
        rx_otfs_im = awgn(rx_otfs_im, snrDB, 'measured');
        rx_otfs_im = rx_otfs_im(1:numSamp);

        y_est_im = equalizeOTFS(rx_otfs_im, G, GtG, n0, P.eqType);
        Xhat_im  = helperOTFSdemod(y_est_im, P.M, padLen, 0, P.padType);

        % patched local detectIMbits (no out-of-bounds)
        e_im_bits = detectIMbits(Xhat_im, in_index, Groups, P.n, P.k, posComb, idx2bits, [], P.Mod_IM, P.Mod_type);
        err_im  = err_im + e_im_bits;
        bits_im = bits_im + Groups * TotalBitsPerGroup;
    end

    BER_OTFS(iS)    = err_otfs / bits_otfs;
    BER_OTFS_IM(iS) = err_im   / bits_im;

    fprintf('[SNR %2d dB] OTFS=%.3e | OTFS-IM=%.3e\n', snrDB, BER_OTFS(iS), BER_OTFS_IM(iS));
end

%% ===================== 5) Plot =====================
titleBase = sprintf('M=%d,N=%d, %s, v=%.1f km/h', P.M, P.N, P.propModel, P.maxSpeed_kmh);

figure('Name','OTFS vs OTFS-IM');
semilogy(SNRdB, BER_OTFS, '-o', SNRdB, BER_OTFS_IM, '--s', 'LineWidth', 2.5, 'MarkerSize', 9);
grid on; box on;
xlabel('Tx SNR (dB)','FontName','Times New Roman','FontSize',14);
ylabel('BER','FontName','Times New Roman','FontSize',14);
legend('OTFS','OTFS-IM','Location','southwest','FontName','Times New Roman','FontSize',13);
title(sprintf('n=%d,k=%d, Mod=%d, Mod-IM=%d  |  %s', ...
    P.n, P.k, P.Mod_OTFS, P.Mod_IM, titleBase), 'Interpreter','none');

%% ===================== 6) Return results struct =====================
results.P = P;
results.padLen = padLen;
results.BER_OTFS    = BER_OTFS;
results.BER_OTFS_IM = BER_OTFS_IM;

%% ===================== Local helper =====================
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
%   C_mat: k x (ModIM^k) complex symbols
%   I_mat: k x (ModIM^k) integer indices (0..ModIM-1)
    grids = cell(1,k);
    [grids{:}] = ndgrid(0:(ModIM-1));
    I_mat = zeros(k, numel(grids{1}));
    for ii = 1:k
        I_mat(ii,:) = grids{ii}(:).';
    end
    C_mat = symConst(I_mat + 1);
end

function [Xvec, in_index] = buildIMGrid(Groups, n, k, posComb, numPos, C_mat, L_symComb)
% Patched IM grid builder consistent with reduced posComb (size numPos x k)

    Xvec = zeros(Groups*n, 1);

    in_index.posIdx     = zeros(Groups,1);
    in_index.txSyms     = zeros(Groups,k);
    in_index.activePos  = zeros(Groups,k);

    for g = 1:Groups
        base = (g-1)*n;

        posIdx = randi(numPos);                 % 1..numPos (reduced set)
        activePos = posComb(posIdx,:);          % 1..n

        symComboIdx = randi(L_symComb);         % 1..L_symComb
        syms = C_mat(:, symComboIdx);           % k x 1

        Xg = zeros(n,1);
        Xg(activePos) = syms;

        Xvec(base + (1:n)) = Xg;

        in_index.posIdx(g)    = posIdx;
        in_index.txSyms(g,:)  = syms(:).';
        in_index.activePos(g,:) = activePos(:).';
    end
end

function errBits = detectIMbits(Xhat_grid, in_index, Groups, n, k, posComb, idx2bits, ~, ModIM, ModType)
% Patched detector + bit error counter:
% - Energy-based index detection (top-k magnitudes)
% - Nearest-neighbor symbol detection
% - Index bits from idx2bits (reduced set)

    persistent lastM lastT const;
    if isempty(const) || lastM ~= ModIM || lastT ~= string(ModType)
        const = buildConstellation(ModIM, string(ModType));
        lastM = ModIM;
        lastT = string(ModType);
    end

    bits_per_index = size(idx2bits,2);
    bSym = log2(ModIM);

    Xvec = reshape(Xhat_grid, [], 1);
    errBits = 0;

    for g = 1:Groups
        idx_start = (g-1)*n + 1;
        idx_end   = g*n;
        rxGroup   = Xvec(idx_start:idx_end);

        % TRUE bits
        posIdx_true = in_index.posIdx(g);
        if bits_per_index == 0
            bits_idx_true = zeros(1,0);
        else
            bits_idx_true = idx2bits(posIdx_true, :);
        end

        txSyms_true = in_index.txSyms(g,:);
        symIdx0_true = zeros(1,k);
        for ii = 1:k
            [~,iiMin] = min(abs(txSyms_true(ii) - const).^2);
            symIdx0_true(ii) = iiMin - 1;
        end
        bits_sym_true = reshape(de2bi(symIdx0_true, bSym, 'left-msb'), 1, []);
        bits_true = [bits_idx_true, bits_sym_true];

        % DETECT positions
        [~, sortIdx] = sort(abs(rxGroup), 'descend');
        detectedPos  = sort(sortIdx(1:k));

        [tf, posIdx_hat] = ismember(detectedPos(:).', posComb, 'rows');
        if ~tf
            posIdx_hat = 1;
        end

        if bits_per_index == 0
            bits_idx_hat = zeros(1,0);
        else
            bits_idx_hat = idx2bits(posIdx_hat, :);
        end

        % DETECT symbols
        zhat = rxGroup(detectedPos);
        symIdx0_hat = zeros(1,k);
        for ii = 1:k
            [~,iiMin] = min(abs(zhat(ii) - const).^2);
            symIdx0_hat(ii) = iiMin - 1;
        end
        bits_sym_hat = reshape(de2bi(symIdx0_hat, bSym, 'left-msb'), 1, []);
        bits_hat = [bits_idx_hat, bits_sym_hat];

        errBits = errBits + sum(bits_true ~= bits_hat);
    end
end