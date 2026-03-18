function const = buildConstellation(Mod, ModType)
if ModType == "PSK"
    const = pskmod(0:Mod-1, Mod, pi/4);
else
    const = qammod(0:Mod-1, Mod, 'UnitAveragePower', true);
end
end

function X = modBitsToSyms(bits, Mod, ModType)
if ModType == "PSK"
    X = pskmod(bits, Mod, pi/4, InputType="bit");
else
    X = qammod(bits, Mod, 'InputType','bit', 'UnitAveragePower', true);
end
end