%用于计算被选取块内部高频分量的掩膜矩阵
function res =  VH_theta_mat (N,T)
    origin = (1:N);
    A = repmat(origin,N,1);
    B = repmat(origin',1,N);
    res = arrayfun(@(x,y)(x+y>=T) ,B,A);
end