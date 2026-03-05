function eq = normalizeEqType(eqIn)
eq = string(eqIn);
eq = strrep(eq, " ", "");
eq = upper(eq);
if contains(eq,"LMMSE")
    eq = "LMMSE";
elseif contains(eq,"ZF")
    eq = "ZF";
else
    eq = "LMMSE";
end
end