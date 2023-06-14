%计算第一次组估计的权重
function res = w_ht_cacl(source,sigma)
    %输入为N1 * N1 *不定长度
%     temp = sum(source,[1 2]);
    sigmapow = sigma^2;
    N_har = length(find(source~=0));
    if(N_har>=1)
       res = 1/(sigmapow*N_har);
   else
       res = 1;
   end
    
end