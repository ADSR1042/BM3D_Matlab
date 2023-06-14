%根据当前块内位置判断是否为低频分量
%用于块内低频掩膜矩阵生成函数的前置函数
function res = theta_gen(i,j,T)
    if(i + j < T && i + j ~= 2)
        res = 1;
    else
        res = 0;
    end
end