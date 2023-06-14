%用于硬阈值滤波
%替代Wavelet Toolbox 附加功能中的wthresh函数
function res = wthresh_(source,~,th)
    %硬阈值滤波
    res = source;
    res(abs(source)<th) = 0;
end