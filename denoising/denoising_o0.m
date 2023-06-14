%最原始版本BM3D实现
function res = denoising(noisy_image,sigma)
    block_length = 8;
    step = 4;
    [height,width]=size(noisy_image);
    [block,height_num,width_num] = image2block(noisy_image,block_length,step);
    block_num = height_num*width_num;
    disp("total block:");
    disp(block_num);
    %paramater
    tau_match_ht = 3000;%TODO NOT CONFIRM
    lam_ht = 2.7; %硬阈值T NOT CONFIRM
    lam_3D = 1; %协同滤波 硬阈值T NOT CONFIRM
    tau_match_wie  = 400;%TODO NOT CONFIRM
    
    sigmapow = sigma^2;
    %block match
    %预分配元胞
    Z_sht_xr = cell(1,block_num);
    Z_sht_xr_index = cell(1,block_num);
    upsilon_ht = lam_ht * sigma;
    for i = (1:block_num)
        S_X = zeros(1,block_num);
        Z_xr = block(:,:,i);
        for j=(1:block_num)
            Z_x =  block(:,:,j);
            temp = wthresh_(DCT_2D(Z_xr),'h',upsilon_ht) - wthresh_(DCT_2D(Z_x),'h',upsilon_ht);
            block_distant = norm(temp)^2/(block_length^2); 
            %对距离进行筛分 保留小于tau_match_ht的部分
            if(block_distant <= tau_match_ht)
                S_X(j) = 1;
            end
       end
       %对当前判断过的S_x处理 堆叠原始block至Z_sht_xr
       temp = S_X == 1;
       Z_sht_xr{i} = cat(3,Z_sht_xr{i}, block(:,:,temp));
       Z_sht_xr_index{i} = find(S_X == 1);
    end
    disp("完成基本块匹配");
    %Z_sht_xr 长度为1:block_num 每个cell储存了不等数量的block 3D块
    
    %预分配 Y_sht_xr
    Y_sht_xr = cell(1,block_num);
    %预分配 系数N
    w_ht = zeros(1,block_num);

    upsilon_3D = lam_3D * sigma;
    
    %对每一个Xr执行协同滤波
    for i = 1:block_num
        %顺带计算N
        temp = wthresh_(DCT_3D(Z_sht_xr{i}),'h',upsilon_3D);
        w_ht(i) = w_ht_cacl(temp,sigma); 
        Y_sht_xr{i} = iDCT_3D(temp);
        clc();
        disp("已完成")
        disp(i/block_num*100);
    end
    disp("完成基本协同滤波")
    %预分配y_basic 
    y_basic = zeros(height,width);

    %Y_sht_xr的每个元素是一个group 单个group是N1*N1*depth矩阵
    %对应的序号存于Z_sht_xr_index

    
    %开始融合
    for i = 1:height
        for j = 1:width
            %纵横像素遍历
            %此处计算y_basic(i,j)

            %重置temp_up temp_down
            temp_up = 0;
            temp_down = 0;
            for t = 1:block_num
                %此处尝试遍历group
                for k = 1:length3D(Y_sht_xr{t})
                    %此处尝试对group t内block k进行处理
                    %具体block为 Y_sht_xr{i}(:,:,k)
                    %此block 的index为Z_sht_xr_index{i}(k)
                    %系数w为 w_ht(t)                   
                    temp_up = temp_up+ w_ht(t)*block_expand(height,width,step,block_length,Z_sht_xr_index{t}(k),i,j,Y_sht_xr{t}(:,:,k) ) ; 
                    temp_down= temp_down+ w_ht(t)*isblockin(height,width,step,block_length,Z_sht_xr_index{t}(k),i,j);
                end
            end
            y_basic(i,j) = temp_up/temp_down;
            disp("now "+num2str(i)+" "+num2str(j));
        end
    end
    disp("完成基本图像融合");
    imshow(uint8(y_basic));
    %对y_basic进行块分割
    

    [block,height_num,width_num] = image2block(y_basic,block_length,step);
    block_num = height_num*width_num;


    %开始2a 分组

    %预分配元胞
    %分组后数组
    y_basic_wie = cell(1,block_num);
    y_basic_wie_index = cell(1,block_num);
    W_wie = cell(1,block_num);

    for i = 1:block_num
        S_wie = zeros(1,block_num);
        %当前block
        y_basic_xr = block(i);
        for j = 1:block_num
            %搜索块
            y_basic_x = block(j);
            distant = norm(y_basic_x-y_basic_xr)^2/(block_length^2);
            if(distant < tau_match_wie)
                S_wie(j) = 1;
            end
        end
       %对当前判断过的S_wie处理 堆叠原始block至Z_sht_xr
       temp = S_wie==1;
       y_basic_wie{i} = cat(3,y_basic_wie{i},block(:,:,temp));
       y_basic_wie_index{i} = find(S_wie ==1);
    end
    disp("完成最终块匹配");
    %y_basic_wie 长度为1:block_num 每个cell储存了不等数量的block 3D块
    %y_basic_wie_index 长度1:depth 记录符合要求的block的索引

    %开始计算维纳系数
    %先进行一次DCT_3D
    y_basic_wie_3D = cell(1,block_num);
    for i = 1:block_num
        y_basic_wie_3D{i} = DCT_3D(y_basic_wie{i});
        temp = y_basic_wie_3D{i}.^2; 
        W_wie{i} = temp./(temp+sigmapow);
        clc();
        disp("最终融合 DCT_3D 已完成")
        disp(i/block_num*100);
    end    

    %再执行一次iDCT_3D
    y_basic_wie_S = cell(1,block_num);
    for i = 1:block_num
        y_basic_wie_S{i} = iDCT_3D(W_wie{i}.*y_basic_wie_3D{i});
        clc();
        disp("最终融合iDCT_3D 已完成")
        disp(i/block_num*100);
    end
    
    y_final = zeros(height,width);

    %计算加权系数
    w_wie_xr = zeros(1,block_num);
    for i = 1:block_num
        w_wie_xr(i)=1/sigmapow*sqrt(sum(W_wie{i}.^2,"all"))  ;
    end
    disp("完成最终滤波");
        %开始融合
    for i = 1:height
        for j = 1:width
            %纵横像素遍历
            %此处计算y_basic(i,j)

            %重置temp_up temp_down
            temp_up = 0;
            temp_down = 0;
            for t = 1:block_num
                %此处尝试遍历group
                for k = 1:length3D(y_basic_wie{t})
                    %此处尝试对group t内block k进行处理
                    %具体block为 y_basic_wie{i}(:,:,k)
                    %此block 的index为y_basic_wie_index{i}(k)
                    %系数w为 w_wie_xr(t)                   
                    temp_up = temp_up+ w_wie_xr(t)*block_expand(height,width,step,block_length,y_basic_wie_index{t}(k),i,j,y_basic_wie{t}(:,:,k) ) ; 
                    temp_down= temp_down+ w_wie_xr(t)*isblockin(height,width,step,block_length,y_basic_wie_index{t}(k),i,j);
                end
            end
                y_final(i,j) = temp_up / temp_down;
         end
    end
    disp("完成最终融合")
    res = y_final;
    imshow(uint8(y_final));
end