%二维逆离散余弦变换
function res = iDCT_2D(source)
    [width,height]=size(source);
    if(width ~= height)
        disp("Error"); %TODO 矩阵补全
    else
        Coe = DCT_Coefficient(width);
        res = Coe' * source * Coe;
    end
end
