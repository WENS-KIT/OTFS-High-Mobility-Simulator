function errBits = detectIMbits(Xhat_grid, in_index, Groups, n, k, posComb, idx2bits, I_mat, ModIM, ModType)
% Energy-based index detection + hard symbol demod on detected positions
Xvec = reshape(Xhat_grid, [], 1); % length M*N
errBits = 0;

for g = 1:Groups
    idx_start = (g-1)*n + 1;
    idx_end   = g*n;
    rxGroup   = Xvec(idx_start:idx_end);

    % 1) detect active positions
    [~, sortIdx] = sort(abs(rxGroup), 'descend');
    detectedPos  = sort(sortIdx(1:k)).';

    detectedPosListIdx = find(all(posComb == detectedPos, 2), 1);
    if isempty(detectedPosListIdx)
        detectedPosListIdx = 1; % fallback
    end

    bits_idx_est = idx2bits(detectedPosListIdx, :);

    % true index bits from stored codeword index
    cwIdx         = in_index(g);
    symCombIdx    = mod(cwIdx - 1, size(I_mat,2)) + 1;
    posCombVecIdx = floor((cwIdx - 1)/size(I_mat,2)) + 1;
    bits_idx_true = idx2bits(posCombVecIdx, :);

    errBits = errBits + sum(bits_idx_true ~= bits_idx_est);

    % 2) detect symbols on detected positions
    estSymIdx = zeros(k,1);
    for ii = 1:k
        p = detectedPos(ii);
        if ModType == "PSK"
            estSymIdx(ii) = pskdemod(rxGroup(p), ModIM, pi/4);
        else
            estSymIdx(ii) = qamdemod(rxGroup(p), ModIM, 'UnitAveragePower', true);
        end
    end
    bits_sym_est = reshape(de2bi(estSymIdx.', log2(ModIM), 'left-msb').', 1, []);

    trueSyms_idx  = I_mat(:, symCombIdx);
    bits_sym_true = reshape(de2bi(trueSyms_idx.', log2(ModIM), 'left-msb').', 1, []);

    errBits = errBits + sum(bits_sym_true ~= bits_sym_est);
end