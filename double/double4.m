function [] = double4()
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ��ʼ������
numTK=3;
numMC=50;%�û�1-35������1��6-50������2��16-50������3��
u = 5*rand(numTK,1)+20;%10��15֮����ȷֲ�,ע��֮��Ҫ����log����
p = 5*rand(numTK,4);%5��10֮����ȡ�ע������д��ֻ��һ������
%��ʼ���ɱ�����
C1=rand(numTK,numMC);
C2=2*rand(numTK,numMC);%�ɱ�������һ����Ͷ����
%��ʼ������������
A=20*rand(numTK,4)+10;
B=5*rand(numTK,numMC)+5;
%1��1��2��1,2��3��1,2,3��4��2,3��1��5�ˣ�2��10�ˣ�3��20�ˣ�4��15�ˣ���50�ˣ�
%��1����ʼ�㣻
s1=A(1);
for j = 1:5;
    s1 = s1 - B(1,j);
end
f1(1)=0;
d1(1)=s1;
ww=0;
for k=1:5
    ww=ww+C1(1,k)*B(1,k)*B(1,k)+C2(1,k)*B(1,k);
end
w1(1)=u(1)*log(1+A(1))-ww;
t=1;
while(s1<lim)
    u1=0;
    if u(1)>p(1,1)
        A(1,1)=(u(1)/p(1,1))-1;
    else
        A(i,1)=0;
    end 
    u1=u1+u(1)*log(1+A(1,1));
    end
    for k=1:5%����������������
        if p(1) <= C2(1,k)
            B(1,k)=0;
        else
            B(1,k)=(p(1,1)-C2(1,k))/(2*C1(1,k));
        end
        u1=u1-C1(1,k)*B(1,k)*B(1,k)+C2(1,k)*B(1,k);
    end
    s1=A(1);
    for j = 1:5;
        s1 = s1 - B(1,j);
    end
    p(1,1)=p(1,1)+0.005*s1;
    end
    d1(t+1)=abs(s1);
    w1(t+1)=u1;
    f1(t+1)=t;
    t=t+1;
    end
%��������2
s2=0;
for i = 1: 2
    s2=s2+abs(A(i,2)- sum(B(i,:)));
end
f2(1)=0;
d2(1)=s;
ww=0;
for i =1:2
    for k=6:15
        ww=ww+C1(i,k)*B(i,k)*B(i,k)+C2(i,k)*B(i,k);
    end
    ww=ww-u(i)*log(1+A(i,2));
end
w(1)=-ww;
t=1;
while (s2>lim)%�г���յ��ж�����
    ui=0;
    for i=1:2%��������
        if u(i)>p(i,2)
            A(i,2)=(u(i)/p(i,2))-1;
        else
            A(i,2)=0;
        end 
        ui=ui+u(i)*log(1+A(i,2));
    end
    for k=6:15%����������������
        for i = 1:2
            if p(i) <= C2(i,k)
                B(i,k)=0;
            else
                B(i,k)=(p(i,2)-C2(i,k))/(2*C1(i,k));
            end
            ui=ui-C1(i,k)*B(i,k)*B(i,k)+C2(i,k)*B(i,k);
        end
    end
    s2=A(1,2);
    ss2=A(2,2);
    for j = 6:10;
        s2 = s2 - B(1,j);
        ss2=ss2-B(2,j);
    end
    p(2,2)=p(2,2)+0.005*(s2+ss2);
    p(1,2)=p(1,2)+0.005*(s2+ss2);
end
    d2(t+1)=abs(s2)+abs(ss2);
    w2(t+1)=ui;
    f2(t+1)=t;
    t=t+1;
end
%����3����
s3=0;
for i = 1: 3
    s3=s3+abs(A(i,3)- sum(B(i,:)));
end
f3(1)=0;
d3(1)=s;
ww=0;
for i =1:3
    for k=16:35
        ww=ww+C1(i,k)*B(i,k)*B(i,k)+C2(i,k)*B(i,k);
    end
    ww=ww-u(i)*log(1+A(i,3));
end
w(1)=-ww;
t=1;
while (s3>lim)%�г���յ��ж�����
    ui=0;
    for i=1:3%��������
        if u(i)>p(i,3)
            A(i,3)=(u(i)/p(i,3))-1;
        else
            A(i,3)=0;
        end 
        ui=ui+u(i)*log(1+A(i,3));
    end
    for k=16:35%����������������
        for i = 1:3
            if p(i,3) <= C2(i,k)
                B(i,k)=0;
            else
                B(i,k)=(p(i,3)-C2(i,k))/(2*C1(i,k));
            end
            ui=ui-C1(i,k)*B(i,k)*B(i,k)+C2(i,k)*B(i,k);
        end
    end
    %����s3�����±������ڼ۸�
    s3=A(1);
    ss3=A(2);
    sss3=A(3);
    for j = 36:50;
        s3 = s3 - B(1,j);
        ss3=ss3 - B(2,j);
        sss3=sss3-B(3,j);
    end
    p(2,4)=p(2,4)+0.005*(s3+ss3+sss3);
    p(3,4)=p(3,4)+0.005*(s3+ss3+sss3);  
end
    d3(t+1)=abs(s3)+abs(ss3)+abs(sss3);
    w3(t+1)=ui;
    f3(t+1)=t;
    t=t+1;
end
%����4���㣻
s4=0;
for i = 2:3
    s4=s4+abs(A(i,4)- sum(B(i,:)));
end
f4(1)=0;
d4(1)=s;
ww=0;
for i =2:3
    for k=36:50
        ww=ww+C1(i,k)*B(i,k)*B(i,k)+C2(i,k)*B(i,k);
    end
    ww=ww-u(i)*log(1+A(i,4));
end
w(1)=-ww;
t=1;
while (s4>lim)%�г���յ��ж�����
    ui=0;
    for i=2:3%��������
        if u(i)>p(i,4)
            A(i,4)=(u(i)/p(i,4))-1;
        else
            A(i,4)=0;
        end 
        ui=ui+u(i)*log(1+A(i,4));
    end
    for k=36:50%����������������
        for i = 36:50
            if p(i) <= C2(i,k)
                B(i,k)=0;
            else
                B(i,k)=(p(i,4)-C2(i,k))/(2*C1(i,k));
            end
            ui=ui-C1(i,k)*B(i,k)*B(i,k)+C2(i,k)*B(i,k);
        end
    end
    s4=A(2);
    ss4=A(3);
    for j = 36:50;
        s4 = s4 - B(2,j);
        ss4=ss4 - B(3,j);
    end
    p(2,4)=p(2,4)+0.005*(s4+ss4);
    p(3,4)=p(3,4)+0.005*(s4+ss4);
end
    d4(t+1)=abs(s4)+abs(ss4);
    w4(t+1)=ui;
    f4(t+1)=t;
    t=t+1;
    end
%h��ͼ
subplot(211);
%���ڹ���d�������ߣ�
plot();
xlabel('Iteration');
ylabel('Mismatch');
subplot(212);
%������ḣ����������
plot();
xlabel('Iteration');
ylabel('Social welfare');
end

