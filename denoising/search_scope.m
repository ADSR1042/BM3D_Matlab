%根据当前块的位置，计算搜索范围
function res = search_scope(height_num,width_num,xr_index,Ns)
%计算当前块在block中的位置
    height = fix((xr_index-1)/width_num) +1;
    width = mod(xr_index-1,width_num)+1;
%计算搜索范围 半径为Ns
    height_min = max(1,height-Ns);
    height_max = min(height_num,height+Ns);
    width_min = max(1,width-Ns);
    width_max = min(width_num,width+Ns);
%输出范围内的所有序号
    res = zeros(1,(height_max-height_min+1)*(width_max-width_min+1));
    index =1;
    for i = height_min:height_max
        for j = width_min:width_max
            res(index) = (i-1)*width_num+j;
            index = index+1;
        end
    end
end
