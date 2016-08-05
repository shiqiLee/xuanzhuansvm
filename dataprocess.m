function main_SVM
%% 清空环境变量
clc
clear

c1=load('subject101.dat'); 
fid1 = fopen('SVM/101.txt','w');
c2=load('subject102.dat'); 
fid2 = fopen('SVM/102.txt','w');
c3=load('subject103.dat'); 
fid3 = fopen('SVM/103.txt','w');
c4=load('subject104.dat'); 
fid4 = fopen('SVM/104.txt','w');
c5=load('subject105.dat'); 
fid5 = fopen('SVM/105.txt','w');
c6=load('subject106.dat'); 
fid6 = fopen('SVM/106.txt','w');
c7=load('subject107.dat'); 
fid7 = fopen('SVM/107.txt','w');
c8=load('subject108.dat'); 
fid8 = fopen('SVM/108.txt','w');

dataprocess(c1,fid1);
dataprocess(c2,fid2);
dataprocess(c3,fid3);
dataprocess(c4,fid4);
dataprocess(c5,fid5);
dataprocess(c6,fid6);
dataprocess(c7,fid7);
dataprocess(c8,fid8);


