function [errBits, errIdxBits, errSymBits] = detectIMbits( ...
    Xhat_grid, in_index, Groups, n, k, posComb, idx2bits, I_mat, ModIM, ModType)

% Pattern-constrained detection:
%   For each allowed pattern in posComb:
%     - slice symbols on those positions
%     - rebuild candidate sparse vector
%     - choose pattern with min ||y - xCand||^2
%
% Output:
%   errBits    : total bit errors (index + symbol)
%   errIdxBits : index-bit errors only
%   errSymBits : symbol-bit errors only

Xvec = reshape(Xhat_grid, [], 1);
errBits = 0; errIdxBits = 0; errSymBits = 0;

ModType = upper(string(ModType));
mSym = log2(ModIM);

for g = 1:Groups
    idx_start = (g-1)*n + 1;
    idx_end   = g*n;
    rxGroup   = Xvec(idx_start:idx_end);

    % ---- true indices (robust to in_index format) ----
    if ismatrix(in_index) && size(in_index,2) >= 2
        posCombVecIdx_true = in_index(g,1);
        symCombIdx_true    = in_index(g,2);
    else
        % scalar cwIdx encoding (your old style)
        cwIdx              = in_index(g);
        symCombIdx_true    = mod(cwIdx - 1, size(I_mat,2)) + 1;
        posCombVecIdx_true = floor((cwIdx - 1)/size(I_mat,2)) + 1;
    end
    bits_idx_true = idx2bits(posCombVecIdx_true, :);

    trueSyms_idx  = I_mat(:, symCombIdx_true);
    bits_sym_true = reshape(de2bi(trueSyms_idx.', mSym, 'left-msb').', 1, []);

    % ---- search over allowed patterns ----
    bestMetric = inf;
    bestPosIdx = 1;
    bestSymIdx = zeros(k,1);

    for pIdx = 1:size(posComb,1)
        activePos = posComb(pIdx,:);

        % Slice symbols at these positions
        estSymIdx = zeros(k,1);
        for ii = 1:k
            r = rxGroup(activePos(ii));
            if ModType == "PSK"
                estSymIdx(ii) = pskdemod(r, ModIM, pi/ModIM, 'gray');
            else
                estSymIdx(ii) = qamdemod(r, ModIM, 'gray', 'UnitAveragePower', true);
            end
        end

        % Rebuild candidate group
        xCand = zeros(n,1);
        if ModType == "PSK"
            symCand = pskmod(estSymIdx, ModIM, pi/ModIM, 'gray');
        else
            symCand = qammod(estSymIdx, ModIM, 'gray', 'UnitAveragePower', true);
        end
        xCand(activePos) = symCand;

        metric = sum(abs(rxGroup - xCand).^2);

        if metric < bestMetric
            bestMetric = metric;
            bestPosIdx = pIdx;
            bestSymIdx = estSymIdx;
        end
    end

    bits_idx_est = idx2bits(bestPosIdx, :);
    bits_sym_est = reshape(de2bi(bestSymIdx.', mSym, 'left-msb').', 1, []);

    eIdx  = sum(bits_idx_true ~= bits_idx_est);
    eSym  = sum(bits_sym_true ~= bits_sym_est);

    errIdxBits = errIdxBits + eIdx;
    errSymBits = errSymBits + eSym;
    errBits    = errBits    + eIdx + eSym;
end
end