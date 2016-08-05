%a是频谱矩心，b是频谱滚降
function [a,b]=feature1_f(y)
L = size(y,2);        % 信号长度
N = 2^nextpow2(L); %采样点数，采样点数越大，分辨的频率越精确，N>=L，超出的部分信号补为0
Y = fft(y,N)/N*2;   %除以N乘以2才是真实幅值，N越大，幅值精度越高
A = abs(Y);     %幅值
a = 0;
b = 0;
tmp1 = 0;
tmp2 = 0;
for i=1:N
    tmp1 = tmp1 + abs(i*A(i));
    tmp2 = tmp2 + abs(A(i));
end
a = tmp1/tmp2;
tmp3 = 0;
for i=1:N
    tmp3 = tmp3 + abs(A(i));
    if tmp3/tmp2 >= 0.8
        b = i;
        break;
    end
end