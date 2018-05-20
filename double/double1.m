function [] = double1( numTK,numMC,lim)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
for i = 1:numTK
    u(i) = 5*rand(1,1)+20;%10��15֮����ȷֲ�,ע��֮��Ҫ����log����
    p(i) = 5*rand(1,1);%5��10֮����ȡ�ע������д��ֻ��һ������
end
C1=rand(numTK,numMC);
C2=2*rand(numTK,numMC);%�ɱ�������һ����Ͷ����
A=20*rand(1,numTK)+10;
B=5*rand(numTK,numMC)+5;
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
while (s>lim)%�г���յ��ж�����
    ui=0;
    for i=1:numTK%��������
        if u(i)>p(i)
            A(i)=(u(i)/p(i))-1;
        else
            A(i)=0;
        end 
        ui=ui+u(i)*log(1+A(i));
    end
    for k=1:numMC%����������������
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
    for i=1:numTK%���¼۸�
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
plot(f,d,'b');%ÿһ�εĹ��費ƽ��̶ȣ�t�ǵ���������
xlabel('Iteration');
ylabel('Mismatch');
subplot(212);
plot(f,w,'r');%��ḣ����
xlabel('Iteration');
ylabel('Social welfare');
end

