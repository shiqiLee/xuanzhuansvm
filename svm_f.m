function svm(person_number)

%导入数据
c1=load('SVM/101.txt'); 
[m1,n1]=size(c1);
c2=load('SVM/102.txt'); 
[m2,n2]=size(c2);
c3=load('SVM/103.txt'); 
[m3,n3]=size(c3);
c4=load('SVM/104.txt'); 
[m4,n4]=size(c4);
c5=load('SVM/105.txt'); 
[m5,n5]=size(c5);
c6=load('SVM/106.txt'); 
[m6,n6]=size(c6);
c7=load('SVM/107.txt'); 
[m7,n7]=size(c7);
c8=load('SVM/108.txt'); 
[m8,n8]=size(c8);

%合并数据
data=[c1;c2;c3;c4;c5;c6;c7;c8];
tmp0=m1+m2+m3+m4+m5+m6;
if person_number==1
    tmp1=m1;
end
if person_number==2
    tmp1=m1+m2;
end
if person_number==3
    tmp1=m1+m2+m3;
end
if person_number==4
    tmp1=m1+m2+m3+m4;
end
if person_number==5
    tmp1=m1+m2+m3+m4+m5;
end
if person_number==6
    tmp1=m1+m2+m3+m4+m5+m6;
end

tmp2=m7+m8;

%采样数据并归一化
%采样数据并归一化
datatmp1 = data';
for i=2:27
   [datatmp1(i,:),ps]=mapminmax(datatmp1(i,:),0,1);
end
data = datatmp1';

ctrain=data(1:tmp1,:);
ctest = data((tmp0+1):(tmp0+tmp2),:);

train_data=ctrain(:,2:27);
test_data=ctest(:,2:27);
%SVM使用的标签
train_label=ctrain(:,1);
test_label=ctest(:,1);

ktrain1=zeros(tmp1,tmp1);

Qr=1:(tmp1-1);
Qw=1:(tmp1-1);
Qg=1:(tmp1-1);
for i=1:tmp1
    Qr(i)=norm(data(i+1,2:11)-data(i,2:11));
    Qw(i)=norm(data(i+1,12:21)-data(i,12:21));
    Qg(i)=norm(data(i+1,22:27)-data(i,22:27));
end 

qr=median(Qr);
qw=median(Qw);
qg=median(Qg);
    
for i=1:tmp1
    for j=1:tmp1
        ktrain1(i,j)=exp((-(norm(train_data(i,1:10)-train_data(j,1:10))/(2*qr))^2));
        ktrain1(i,j)=ktrain1(i,j)+exp((-(norm(train_data(i,11:20)-train_data(j,11:20))/(2*qw))^2));
        ktrain1(i,j)=ktrain1(i,j)+exp((-(norm(train_data(i,21:26)-train_data(j,21:26))/(2*qg))^2));
    end
end
Ktrain1=[(1:tmp1)',ktrain1];
model_pre=libsvmtrain(train_label,Ktrain1,'-t 4 -h 0 -c 16');

ktest1=zeros(tmp2,tmp1);
for i=1:tmp2
    for j=1:tmp1
        ktest1(i,j)=exp((-(norm(test_data(i,1:10)-train_data(j,1:10))/(2*qr))^2));
        ktest1(i,j)=ktest1(i,j)+exp((-(norm(test_data(i,11:20)-train_data(j,11:20))/(2*qw))^2));
        ktest1(i,j)=ktest1(i,j)+exp((-(norm(test_data(i,21:26)-train_data(j,21:26))/(2*qg))^2));
    end
end
Ktest1=[(1:tmp2)',ktest1];
[predict_label_P1, accuracy_P1,dec_values_p1]=libsvmpredict(test_label,Ktest1,model_pre);

SVMoutmatrix = zeros(3,4);
for i=1:tmp2
    SVMoutmatrix(test_label(i),predict_label_P1(i)) = SVMoutmatrix(test_label(i),predict_label_P1(i))+1;
end
SVMoutmatrix(1,4)=SVMoutmatrix(1,1)/(SVMoutmatrix(1,1)+SVMoutmatrix(1,2)+SVMoutmatrix(1,3));
SVMoutmatrix(2,4)=SVMoutmatrix(2,2)/(SVMoutmatrix(2,1)+SVMoutmatrix(2,2)+SVMoutmatrix(2,3));
SVMoutmatrix(3,4)=SVMoutmatrix(3,3)/(SVMoutmatrix(3,1)+SVMoutmatrix(3,2)+SVMoutmatrix(3,3));

fid = fopen(['SVM ' num2str(person_number) ' person.txt'],'w');
fprintf(fid,'%s ',['SVM:'  num2str(accuracy_P1(1))]);   
fprintf(fid,'\r\n');
fprintf(fid,'%s ',['下面是SVM混淆矩阵']  );  
fprintf(fid,'\r\n');
fprintf(fid,'%s ',['nn11:' num2str(SVMoutmatrix(1,1))     '   n12:'  num2str(SVMoutmatrix(1,2)) '   n13:'  num2str(SVMoutmatrix(1,3)) '  Rate:'  num2str(SVMoutmatrix(1,4))]  );
fprintf(fid,'\r\n');
fprintf(fid,'%s ',['nn21:' num2str(SVMoutmatrix(2,1))     '   n22:'  num2str(SVMoutmatrix(2,2)) '   n23:'  num2str(SVMoutmatrix(2,3)) '  Rate:'  num2str(SVMoutmatrix(2,4))]  );
fprintf(fid,'\r\n');
fprintf(fid,'%s ',['nn31:' num2str(SVMoutmatrix(3,1))     '   n32:'  num2str(SVMoutmatrix(3,2)) '   n33:'  num2str(SVMoutmatrix(3,3)) '  Rate:'  num2str(SVMoutmatrix(3,4))]  );
fclose(fid);
