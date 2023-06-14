%一维逆离散余弦变换
function res = iDCT_1D(source)
    [~,length]=size(source);
    Coe = DCT_Coefficient(length);
    res = source * Coe;
end
