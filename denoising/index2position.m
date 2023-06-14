%将block_reference的index转换为其在图像中的坐标
function [height,width]= index2position(index,~,width_num)
    height = fix((index-1)/width_num) +1;
    width = mod(index-1,width_num)+1;
end