# 噪声估计与BM3D去噪

一个噪声估计与BM3D降噪的matlab实现

运行此项目需要Parallel Computing Toolbox 如未安装 请将denoising文件夹中的DCT_3D.m与iDCT_3D.m的parfor修改为for

参与成员

- @ADSR1042
- 周浩翔 3210100659
- 

**注：输入进降噪函数的方差为256灰度空间值 噪声估计方差可为一值化/灰度空间值**

## 文件架构

### clear_image

储存了所有无噪声图像

### noise_image

储存了所有含噪图像

### noise_estimation

- main.m 入口文件 可选对已有含噪图像进行估计 / 对无噪图像加入噪声后进行估计
- noise_estimation.m 噪声估计主函数文件
- DCT_2D.m  执行二维离散傅里叶变换
- DCT_Coeffcient.m 计算离散傅里叶变换系数矩阵
- VL_theta_mat.m 计算块中低频部分掩膜矩阵
- VH_theta_mat.m 计算块中高频部分掩膜矩阵
- theta_gen.m 计算块中每个位置的theta
- theta_cacl.m 计算归一化theta
- enlight_block.m 高亮block 用于演示

### denoising

- main.m 入口文件
- denoising.m 降噪主函数入口 可选优化参数
- denoising_o0/1/2/3 降噪主函数
- DCT_Coeffcient.m 计算离散傅里叶变换系数矩阵
- DCT_1D.m 一维离散余弦变换
- DCT_2D.m 二维离散余弦变换
- DCT_3D.m 三维离散余弦变换
- iDCT_1D.m 一维逆离散余弦变换
- iDCT_2D.m 二维逆离散余弦变换
- iDCT_3D.m 三维逆离散余弦变换
- length3D.m 计算第三维度上的长度 用于计算每个组内block的数目
- image2block.m 图像的块分割
- search_scope.m 计算块搜索半径内的block序号
- wthresh_.m 硬阈值滤波
- w_ht_cacl.m 计算step1中图像融合组权重
- index2position.m %将block_reference的index转换为其在图像中的坐标
- block_expand.m 用于将矩阵扩展至全图像(其余区域零填充) 便于计算
- isblockin.m 计算当前坐标是否在给定的参考块内
- psnr.m 计算图像的PSNR 用于评价降噪质量

 docker-compose.yml 服务器端 matlab docker启动配置文件

### 函数依赖

噪声估计

![img](https://github.com/ADSR1042/BM3D_Matlab/blob/main/noise_estimation.png?raw=true "噪声估计函数依赖")

降噪函数函数依赖

![1686675588165](https://github.com/ADSR1042/BM3D_Matlab/blob/main/noise_estimation.png?raw=true)
