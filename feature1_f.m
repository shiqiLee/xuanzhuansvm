%a��Ƶ�׾��ģ�b��Ƶ�׹���
function [a,b]=feature1_f(y)
L = size(y,2);        % �źų���
N = 2^nextpow2(L); %������������������Խ�󣬷ֱ��Ƶ��Խ��ȷ��N>=L�������Ĳ����źŲ�Ϊ0
Y = fft(y,N)/N*2;   %����N����2������ʵ��ֵ��NԽ�󣬷�ֵ����Խ��
A = abs(Y);     %��ֵ
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