%% OTFS_vs_OFDM.m
% Standalone BER comparison: OTFS vs OFDM (full grid)
% Requirements: your existing helper functions must be on path:
%   getChannelParams, getG, helperOTFSmod, helperOTFSdemod, dopplerChannel,
%   equalizeOTFS, equalizeOFDM, ofdmmod, ofdmdemod,
%   buildConstellation, modBitsToSyms, demodSymsToBits

% Adnan Tariq (adnantariq@kumoh.ac.kr)
%A. Tariq, M. Sajid Sarwar and S. Y. Shin, "Orthogonal Time-Frequency–Space Multiple Access Using Index Modulation and NOMA,"
% in IEEE Wireless Communications Letters, vol. 14, no. 5, pp. 1456-1460, May 2025, doi: 10.1109/LWC.2025.3544234
%
%A. Tariq, M. S. Sarwar and S. Y. Shin, "Orthogonal Time Frequency Space (OTFS) with Tri-Mode Index Modulation," 
%2024 15th International Conference on Information and Communication Technology Convergence (ICTC), Jeju Island, Korea, Republic of, 2024, pp. 1183-1186, doi: 10.1109/ICTC62082.2024.10827438.

clc; clear; close all;

baseDir = fileparts(mfilename('fullpath'));
addpath(fullfile(baseDir, 'functions'));
rehash;
rng(0,'v4');

%% ===================== 0) USER SETTINGS (edit these) =====================

P.M = 32;                       % Delay resources (subcarriers)
P.N = 32;                       % Doppler resources (subsymbols)

P.Mod_OTFS = 4;                 % OTFS / OFDM modulation order (4,8,16)
P.Mod_type  = "QAM";            % "PSK" or "QAM"

P.propModel   = "TDL-A";        % "TDL-A","TDL-B","TDL-C" or your strings
% According to 3GPP Standard propagtion models
P.maxSpeed_kmh = 350;           % km/h

P.cest_Type = "Perfect";        % (kept for compatibility)
P.eqType    = "LMMSE";          % "LMMSE" or "ZF"

P.padType = 'ZP';
P.df = 15e3;
P.fc = 5e9;
P.SNRdB = 0:3:30;

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
assert(abs(log2(P.Mod_OTFS) - round(log2(P.Mod_OTFS))) < 1e-12, 'Mod_OTFS must be power of 2.');

BW    = P.M * P.df;
fsamp = BW;

fprintf('=== OTFS vs OFDM Simulation ===\n');
fprintf('M=%d, N=%d, BW=%.3f MHz, padType=%s, eq=%s\n', P.M, P.N, BW/1e6, P.padType, P.eqType);
fprintf('Mod=%d (%s) | Channel=%s, v=%.1f km/h, fc=%.2f GHz, Frames/SNR=%d\n\n', ...
    P.Mod_OTFS, P.Mod_type, P.propModel, P.maxSpeed_kmh, P.fc/1e9, P.NUM_FRAMES);

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
BER_OTFS = zeros(size(SNRdB));
BER_OFDM = zeros(size(SNRdB));

% constellation (assumed unit average power by your builder)
symConst_OTFS = buildConstellation(P.Mod_OTFS, P.Mod_type);

%% ===================== 3) Main SNR loop =====================
for iS = 1:numel(SNRdB)
    snrDB = SNRdB(iS);

    Es_ref = mean(abs(symConst_OTFS).^2);
    n0     = Es_ref / (10^(snrDB/10));

    err_otfs = 0; bits_otfs = 0;
    err_ofdm = 0; bits_ofdm = 0;

    for f = 1:P.NUM_FRAMES
        %% (A) Full-grid payload (OTFS/OFDM)
        bitsTX_full = randi([0 1], log2(P.Mod_OTFS)*P.M, P.N);
        Xgrid_full  = modBitsToSyms(bitsTX_full, P.Mod_OTFS, P.Mod_type);

        %% (B) OTFS
        tx_otfs = helperOTFSmod(Xgrid_full, padLen, P.padType);
        rx_otfs = dopplerChannel(tx_otfs, fsamp, chanParams);
        rx_otfs = awgn(rx_otfs, snrDB, 'measured');
        rx_otfs = rx_otfs(1:numSamp);

        y_est_otfs = equalizeOTFS(rx_otfs, G, GtG, n0, P.eqType);
        Xhat_otfs  = helperOTFSdemod(y_est_otfs, P.M, padLen, 0, P.padType);

        bitsRX_otfs = demodSymsToBits(Xhat_otfs, P.Mod_OTFS, P.Mod_type);
        err_otfs  = err_otfs + biterr(bitsTX_full, bitsRX_otfs);
        bits_otfs = bits_otfs + numel(bitsTX_full);

        %% (C) OFDM (pilot then data)
        pilotSym  = exp(1i*pi/4);
        pilotGrid = pilotSym * ones(P.M, P.N);

        tx_ofdm_p = ofdmmod(pilotGrid, P.M, padLen);
        rx_ofdm_p = dopplerChannel(tx_ofdm_p, fsamp, chanParams);
        rx_ofdm_p = awgn(rx_ofdm_p, snrDB, 'measured');
        Yp = ofdmdemod(rx_ofdm_p(1:(P.M+padLen)*P.N), P.M, padLen);
        Hofdm_est = Yp ./ pilotGrid;

        tx_ofdm = ofdmmod(Xgrid_full, P.M, padLen);
        rx_ofdm = dopplerChannel(tx_ofdm, fsamp, chanParams);
        rx_ofdm = awgn(rx_ofdm, snrDB, 'measured');
        Yd = ofdmdemod(rx_ofdm(1:(P.M+padLen)*P.N), P.M, padLen);

        Xhat_ofdm = equalizeOFDM(Yd, Hofdm_est, n0, P.eqType);

        bitsRX_ofdm = demodSymsToBits(Xhat_ofdm, P.Mod_OTFS, P.Mod_type);
        err_ofdm  = err_ofdm + biterr(bitsTX_full, bitsRX_ofdm);
        bits_ofdm = bits_ofdm + numel(bitsTX_full);
    end

    BER_OTFS(iS) = err_otfs / bits_otfs;
    BER_OFDM(iS) = err_ofdm / bits_ofdm;

    fprintf('[SNR %2d dB] OTFS=%.3e | OFDM=%.3e\n', snrDB, BER_OTFS(iS), BER_OFDM(iS));
end

%% ===================== 4) Plot =====================
titleBase = sprintf('M=%d,N=%d, %s, v=%.1f km/h', P.M, P.N, P.propModel, P.maxSpeed_kmh);

figure('Name','OTFS vs OFDM');
semilogy(SNRdB, BER_OTFS, '-o', SNRdB, BER_OFDM, '--s', 'LineWidth', 2.5, 'MarkerSize', 9);
grid on; box on;
xlabel('Tx SNR (dB)','FontName','Times New Roman','FontSize',14);
ylabel('BER','FontName','Times New Roman','FontSize',14);
legend('OTFS','OFDM','Location','southwest','FontName','Times New Roman','FontSize',13);
title(titleBase,'Interpreter','none');

%% ===================== 5) Return results struct =====================
results.P = P;
results.padLen = padLen;
results.BER_OTFS = BER_OTFS;
results.BER_OFDM = BER_OFDM;

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