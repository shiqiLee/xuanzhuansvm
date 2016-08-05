function dataprocess(c,fid)
%���������ж�ȡʧ�ܵ�ֵ
[m,n]=size(c);
for i=1:m
    up=1;
    down=1;
    for j=5:47
        if isnan(c(i,j))
            while(isnan(c((i-up),j)))
                up=up+1;
            end
            while(isnan(c((i+down),j)))
                down=down+1;
            end
            c(i,j)=up*(c(i+down,j)-c(i-up,j))/(up+down) + c(i-up,j);
            up=1;
            down=1;
        end
    end
end
  

%ɨ�����������Ϊ256�����ݣ�����Ϊ512������
for i=1:((m-512)/256)
    %data����һ�����ڵ�����
    data(1:512,:)=c((1+(i*256)):(512+(i*256)),:);
    
    %3����λ�������ļ��ټƶ����������Ƕ���
    a1=data(:,5:7);
    w1=data(:,11:13);
    a2=data(:,22:24);
    w2=data(:,28:30);
    a3=data(:,39:41);
    w3=data(:,45:47);

    %�����������ٶ�
    gravity1=zeros(512,3);
    gravity2=zeros(512,3);
    gravity3=zeros(512,3);
    
    %����ȥ���������ٶȷ���������Լ��ٶ�
    linear_acceleration1=zeros(512,3);
    linear_acceleration2=zeros(512,3);
    linear_acceleration3=zeros(512,3);
    
    %�õ�ͨ�˲��ķ�ʽ������������ٶȣ�����Ϊ0.8
    alph = 0.996;
    for j=2:512
        for k=1:3
            gravity1(j,k)=alph*gravity1(j-1,k) + (1-alph)*a1(j,k);
            linear_acceleration1(j,k)=a1(j,k) - gravity1(j,k);
            gravity2(j,k)=alph*gravity2(j-1,k) + (1-alph)*a2(j,k);
            linear_acceleration2(j,k)=a2(j,k) - gravity2(j,k);
            gravity3(j,k)=alph*gravity3(j-1,k) + (1-alph)*a3(j,k);
            linear_acceleration3(j,k)=a3(j,k) - gravity3(j,k);
        end
    end
    
    for j=1:200
        for k=1:3
            gravity1(201-j,k)=alph*gravity1(201-j+1,k) + (1-alph)*a1(201-j,k);
            linear_acceleration1(201-j,k)=a1(201-j,k) - gravity1(201-j,k);
            gravity2(201-j,k)=alph*gravity2(201-j+1,k) + (1-alph)*a2(201-j,k);
            linear_acceleration2(201-j,k)=a2(201-j,k) - gravity2(201-j,k);
            gravity3(201-j,k)=alph*gravity3(201-j+1,k) + (1-alph)*a3(201-j,k);
            linear_acceleration3(201-j,k)=a3(201-j,k) - gravity3(201-j,k);
        end
    end
    

    
    
    %���յ���ת���ٶȣ������Լ��ٶ��ڽ��ٶ����������ͶӰ�õ�
    a1a=1:512;
    a2a=1:512;
    a3a=1:512;
    for p=1:512
        B = null(w1(p,:));
        V = B(:,1);
        V = V/norm(V);
        a1a(p) = abs(dot(V',linear_acceleration1(p,:)));
        
        B = null(w2(p,:));
        V = B(:,1);
        V = V/norm(V);
        a2a(p) = abs(dot(V',linear_acceleration2(p,:)));
        
        B = null(w3(p,:));
        V = B(:,1);
        V = V/norm(V);
        a3a(p) = abs(dot(V',linear_acceleration3(p,:)));
    end
    
    
    %������ٶȸı����dw ���ٶ�ֵW  ��ת�뾶R
    dw1=1:512;
    W1=1:512;
    R1=1:512;
    dw2=1:512;
    W2=1:512;
    R2=1:512;
    dw3=1:512;
    W3=1:512;
    R3=1:512;
    
    %����dw W R 
    Wt_1=0;
    for q=1:512
        W1(q)=norm(w1(q,:));
        W2(q)=norm(w2(q,:));
        W3(q)=norm(w3(q,:));
        
        if q>1
            tmpv=w1(q,:);
            tmpv=tmpv/norm(tmpv);
            dw1(q)=W1(q)-dot(w1(q-1,:),tmpv);
            
            tmpv=w2(q,:);
            tmpv=tmpv/norm(tmpv);
            dw2(q)=W2(q)-dot(w2(q-1,:),tmpv);
            
            tmpv=w3(q,:);
            tmpv=tmpv/norm(tmpv);
            dw3(q)=W3(q)-dot(w3(q-1,:),tmpv);
        end
        
        R1(q)=a1a(q)/sqrt((dw1(q)/0.01)^2 + W1(q)^4);
        R2(q)=a2a(q)/sqrt((dw2(q)/0.01)^2 + W2(q)^4);
        R3(q)=a3a(q)/sqrt((dw3(q)/0.01)^2 + W3(q)^4);      
    end
    
    %���˲�������R���ڵĲ���
      Locate=find(R1>1);
      R1(Locate)=[];
      a1a(Locate)=[];
      gravity1(Locate,:)=[];

      
      Locate=find(R2>1);
      R2(Locate)=[];
      a2a(Locate)=[];
      gravity2(Locate,:)=[];
      
      Locate=find(R3>1);
      R3(Locate)=[];
      a3a(Locate)=[];
      gravity3(Locate,:)=[];
      

               
    %�����յ�����������
    Out=1:27;
    Out=function2(R1,a1a,gravity1);
    Out(1)=1;
    fprintf(fid,'%g ',Out);   
    fprintf(fid,'\n');
    
    Out=1:27;
    Out=function2(R2,a2a,gravity2);
    Out(1)=2;
    fprintf(fid,'%g ',Out);   
    fprintf(fid,'\n');
    
    Out=1:27;
    Out=function2(R3,a3a,gravity3);
    Out(1)=3;
    fprintf(fid,'%g ',Out);   
    fprintf(fid,'\n');
end
    
fclose(fid);

