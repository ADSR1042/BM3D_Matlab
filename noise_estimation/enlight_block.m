%对输入的二维矩阵周围置255（白色强调）
function res =  enlight_block(source)
    [height,width] = size(source);
    res = source;
    res(1,:) = 255;
    res(height,:)= 255;
    res(:,1) = 255;
    res(:,width)=255;
end