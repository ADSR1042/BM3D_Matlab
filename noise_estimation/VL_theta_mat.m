%用于生成选取低频块时 剥离块内低频分量的掩膜矩阵
function res =  VL_theta_mat(N,T,block_num)
    origin = (1:N);
    A = repmat(origin,N,1);
    B = repmat(origin',1,N);
    res_temp = arrayfun(@(x,y) theta_gen(x,y,T),B,A);
    res = repmat(res_temp,[1,1,block_num]);
end