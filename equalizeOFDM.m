function Xhat = equalizeOFDM(Y, Hest, n0, eqType)
switch string(eqType)
    case "LMMSE"
        Xhat = conj(Hest) .* Y ./ (abs(Hest).^2 + n0);
    case "ZF"
        Xhat = Y ./ Hest;
    otherwise
        error('Unknown OFDM eqType.');
end
end