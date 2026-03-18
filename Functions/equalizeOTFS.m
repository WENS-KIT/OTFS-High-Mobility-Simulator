function y_est = equalizeOTFS(rx, G, GtG, n0, eqType)
switch string(eqType)
    case "LMMSE"
        y_est = (GtG + n0*eye(size(GtG))) \ (G' * rx);
    case "ZF"
        y_est = G \ rx;
    otherwise
        error('Unknown OTFS eqType.');
end
end