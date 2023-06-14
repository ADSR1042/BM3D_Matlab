%计算第三维度上的长度 用于计算每个组内block的数目
function res= length3D(source)
    [~,~,depth] = size(source);
   res = depth;
end