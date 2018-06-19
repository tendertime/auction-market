function [] = double1( numTK,numMC,lim)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
u = 20*rand(numTK,1)+60;%10到15之间均匀分布,注意之后要乘以log（）
p = 5*rand(numTK,1);
C1=rand(numTK,numMC);
C2=2*rand(numTK,numMC);%成本函数的一次项和二次项；
A=20*rand(numTK,1)+10;
B=4*rand(numTK,numMC)+2;
s=0;
for i = 1: numTK
    s=s+abs(A(i)- sum(B(i,:)));
end
f(1)=0;
d(1)=s;
ww=0;
for i =1:numTK
    for k=1:numMC
        ww=ww+C1(i,k)*B(i,k)*B(i,k)+C2(i,k)*B(i,k);
    end
    ww=ww-u(i)*log(1+A(i));
end
w(1)=-ww;
t=1;
while (s>lim)%市场清空的判断条件
    ui=0;
    for i=1:numTK%更新需求
        if u(i)>p(i)
            A(i)=(u(i)/p(i))-1;
        else
            A(i)=0;
        end 
        ui=ui+u(i)*log(1+A(i));
    end
    for k=1:numMC%更新下任务分配情况
        for i = 1:numTK
            if p(i) <= C2(i,k)
                B(i,k)=0;
            else
                B(i,k)=(p(i)-C2(i,k))/(2*C1(i,k));
            end
            ui=ui-C1(i,k)*B(i,k)*B(i,k)+C2(i,k)*B(i,k);
        end
    end
    s=0;
    for i=1:numTK%更新价格
        X=A(i)- sum(B(i,:));
        p(i) = p(i)+0.005*X;
        s=s+abs(X);
    end
    d(t+1)=s;
    w(t+1)=ui;
    f(t+1)=t;
    t=t+1;
end
subplot(211);
plot(f,d,'b');%每一次的供需不平衡程度；t是迭代次数。
xlabel('Iteration');
ylabel('Mismatch');
subplot(212);
plot(f,w,'r');%社会福利；
xlabel('Iteration');
ylabel('Social welfare');
end

