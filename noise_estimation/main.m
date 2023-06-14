%入口文件 可选对已有含噪图像进行估计 / 对无噪图像加入噪声后进行估计
%对已有含噪图像进行噪声估计
image = double(imread("../noise_image/kodak24.bmp"));
res = noise_estimation(image);
disp(res);

%对无噪声图像加入高斯白噪声后进行噪声估计
% clean_img = double(imread("../clear_image/cameraman_gt.png"));
% sigma = 20;
% noisy_img = clean_img + randn(size(clean_img)) * sigma;
% res = noise_estimation(noisy_img);
% disp(res);
