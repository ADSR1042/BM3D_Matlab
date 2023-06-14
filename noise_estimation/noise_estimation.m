%噪声估计主函数文件
function res = noise_estimation(nosiy_img)
    [height,width] = size(nosiy_img);
    T = 11;

    %图像分割为 8px * 8px 的块
    N = 8;
    block_width = N;
    block_height = N;
    block_height_num = height / block_height;
    block_width_num = width / block_width;
    block_num = block_height_num * block_width_num;
    block_temp = mat2cell(nosiy_img, ones(1, block_height_num) * block_height, ones(1, block_width_num) * block_width);
    block = zeros(block_height, block_width, block_num);
    block_dct = zeros(block_height, block_width, block_num);
    for i = 1:block_height_num
        for j = 1:block_width_num
            block(:, :, (i - 1) * block_width_num + j) = block_temp{i, j};
            block_dct(:,:,(i - 1) * block_width_num + j) = DCT_2D(block_temp{i, j});
        end
    end
    VL = VL_cacl(N,T,block_dct,block_num);
    [~,I]=sort(VL);
    %k估计
    k = block_num/512;
    for i = 1:7
        U = 1.3 * VL(ceil(k/2));
        k_temp = abs(VL-U);
        [~,m_min] = min(abs(k_temp));
        k = m_min;
    end
    k = round(k/5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %testing code DEV only
    %此部分用于强调找到的低噪块
%     mask_image = nosiy_img;
%     for i = 1:k
%       if(I(i) > block_num)
%          disp("I(i) error "); 
%       end
%       temp_position = position2pixel(height,width,8,8,I(i));
%       temp_height = temp_position(1);
%       temp_width = temp_position(2);
%       mask_image(temp_height:temp_height+block_height-1,temp_width:temp_width+block_width-1) = enlight_block(mask_image(temp_height:temp_height+block_height-1,temp_width:temp_width+block_width-1));
%     end
%     imshow(uint8(mask_image));

    disp("完成低噪块查找");
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Dm 转换DM
    block_dct_M = block_dct(:,:,I);
    VH = VH_cacl(N,T,block_dct_M,k);
    %去除零元素
    VH(VH==0)=[];
    %取中位
    res = sqrt(median(VH));
end

function res =  VL_cacl(N,T,block_dct,block_num)
    %系数
    theta = theta_cacl(N,T);
    %三维矩阵 theta
    VL_theta = VL_theta_mat(N,T,block_num);
    res_temp =  block_dct.^2.*VL_theta;
    res = 1/theta*sum(res_temp,[1 2]);
end

function res = VH_cacl(N,T,block_dct_M,k)
    %截取前k个
    block_dct_M_K = block_dct_M(:,:,1:k);
    res_temp = block_dct_M_K.^2.*VH_theta_mat(N,T);
    res = 1/k*sum(res_temp,3);
end