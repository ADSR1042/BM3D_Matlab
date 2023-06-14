%将图像分割成给定block_length与step的块
function [block,height_num,width_num]=  image2block(noise_image,block_length,step)
    [height,width] = size(noise_image);
    %为简单起见暂时只考虑窗移动可被整分割的情况
    height_num = (height-(block_length-step))/(step);
    width_num = (width-(block_length-step))/(step);
    block_num = height_num*width_num;
    block = zeros(block_length,block_length,block_num);
    for i = 1:height_num
        for j = 1:width_num
            index = (i-1)*width_num + j;
            block(:,:,index) = noise_image((i-1)*step+1:(i-1)*step+block_length,(j-1)*step+1:(j-1)*step+block_length);
        end
    end
end