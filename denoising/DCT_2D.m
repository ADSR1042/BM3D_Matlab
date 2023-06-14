%二维离散余弦变换变换
function res = DCT_2D(source)
    [width,height]=size(source);
    if(width ~= height)
        disp("Error"); 
    else
        Coe = DCT_Coefficient(width);
        res = Coe * source * Coe';
    end
end