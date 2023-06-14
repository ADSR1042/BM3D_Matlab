%计算theta归一化常数
function res =  theta_cacl (N,T)
    origin = (1:N);
    A = repmat(origin,N,1);
    B = repmat(origin',1,N);
    res_temp = arrayfun(@(x,y) theta_gen(x,y,T),B,A);
    res = sum(res_temp(:));
end