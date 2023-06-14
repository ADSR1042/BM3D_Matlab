%三维逆离散余弦变换
function res = iDCT_3D(source)
    [height,width,depth]=size(source);
    res = zeros(height,width,depth);
    if(ismatrix(source))
        res = iDCT_2D(source);
        return;
    end
    if(ndims(source) ~= 3)
        error("Error in iDCT_3D: input matrix is not 3D");
    end
    if(width ~= height)
        disp("Error"); %TODO 矩阵补全
    else
        %先对组执行 iDCT_1D
        temp = zeros(width,height,depth);
        parfor i = 1:height
            for j = 1:width
                temp(i,j,:)= reshape( iDCT_1D(reshape(source(i,j,:),1,[])),1,1,[]);
            end
        end

        %再对每一个块执行 iDCT_2D

        parfor i = 1:depth 
            res(:,:,i) = iDCT_2D(temp(:,:,i));
        end
        
        %TODO 把这两个很丑的for循环改成arrayfun 
    end
end