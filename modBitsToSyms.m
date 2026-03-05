function X = modBitsToSyms(bits, Mod, ModType)
if ModType == "PSK"
    X = pskmod(bits, Mod, pi/4, InputType="bit");
else
    X = qammod(bits, Mod, 'InputType','bit', 'UnitAveragePower', true);
end
end