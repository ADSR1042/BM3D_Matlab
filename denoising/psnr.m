%计算图像的PSNR 用于评价降噪质量
function res=psnr(image_clear,image_noisy)
    [width,length]=size(image_clear);
    image_clear=im2double(image_clear);
    image_noisy=im2double(image_noisy);
    temp=zeros(width,length);
    max=1;%double为1，unit8为2^8-1=255

    temp=image_clear-image_noisy;
    temp=temp.^2;
    mse=sum(temp,'all')/width/length;

    res=10*log(max^2/mse);
end