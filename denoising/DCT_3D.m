%三维离散余弦变换
function res = DCT_3D(source)
    [height,width,depth]=size(source);
    res = zeros(height,width,depth);
    if(ismatrix(source)) 
        res = DCT_2D(source);
        return;
    end
    if(ndims(source) > 3) 
        error("Error dim of source");
    end
    if(width ~= height)
        error("Error"); %TODO 矩阵补全
    else
        %先对每一个块执行DCT2D
        temp = zeros(width,height,depth);
        parfor i = 1:depth 
            temp(:,:,i) = DCT_2D(source(:,:,i));
        end
        %对组执行 DCT_1D
        parfor i = 1:height
            for j = 1:width
                res(i,j,:)= reshape( DCT_1D( reshape( temp(i,j,:),1,[])),1,1,[]);
            end
        end
        %TODO 把这两个很丑的for循环改成arrayfun 
    end
end