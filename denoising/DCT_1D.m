%一维离散余弦变换
function res = DCT_1D(source)
    [~,length]=size(source);
    Coe = DCT_Coefficient(length);
    res = source * Coe';
end