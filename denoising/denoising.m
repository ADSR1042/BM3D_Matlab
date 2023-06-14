% denoising.m 入口函数
function res =  denoising(noisy_image,sigma,optimize)
    %optimize缺省情况下为3
    if nargin < 3
        optimize = 3;
    end
    switch optimize
    case 0
        res = denoising_o0(noisy_image,sigma);
    case 1
        res = denoising_o1(noisy_image,sigma);
    case 2
        res = denoising_o2(noisy_image,sigma);
    case 3
        res = denoising_o3(noisy_image,sigma);
    end
end