function bits = demodSymsToBits(X, Mod, ModType)
if ModType == "PSK"
    bits = pskdemod(X, Mod, pi/4, OutputType="bit", OutputDataType="logical");
else
    bits = qamdemod(X, Mod, OutputType="bit", UnitAveragePower=true, OutputDataType="logical");
end
end

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