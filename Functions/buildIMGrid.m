function [flatVec, in_index] = buildIMGrid(Groups, n, k, posComb, numPos, C_mat, L_symComb)
% Builds a length (Groups*n) sparse vector holding IM symbols per group
in_index = zeros(1, Groups);
flatVec  = zeros(Groups*n, 1);

for g = 1:Groups
    cwIdx = randi([1, numPos * L_symComb]);
    in_index(g) = cwIdx;

    symCombIdx    = mod(cwIdx - 1, L_symComb) + 1;
    posCombVecIdx = floor((cwIdx - 1)/L_symComb) + 1;

    activePositions = posComb(posCombVecIdx, :);
    symbols_k       = C_mat(:, symCombIdx);

    v = zeros(n,1);
    for ii = 1:k
        v(activePositions(ii)) = symbols_k(ii);
    end
    flatVec((g-1)*n+1 : g*n) = v;
end
end