%判定给定坐标是否在当前reference block内
%function res =  block_expand(height,width,block_length,block_reference_index,i,j,block_reference)
function res =  block_expand(height,width,step,block_length,block_reference_index,i,j,block_reference)
    height_num = (height-(block_length-step))/(step);
    width_num = (width-(block_length-step))/(step);
    [block_reference_height,block_reference_width] = index2position(block_reference_index,height_num,width_num);
    %block坐标起始点
    %(block_reference_heigh-1)*step+1 
    %(block_reference_width-1)*step+1
    %block坐标终点
    %(block_reference_heigh-1)*step+block_length 
    %(block_reference_width-1)*step+block_length
    %执行判定
    if i>=(block_reference_height-1)*step+1 && i<=(block_reference_height-1)*step+block_length && j>=(block_reference_width-1)*step+1 && j<=(block_reference_width-1)*step+block_length
        %在block内
        %返回block对应值
        res = block_reference(i-(block_reference_height-1)*step,j-(block_reference_width-1)*step);
    else
        res = 0;
    end

end