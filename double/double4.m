function [] = double4()
% ��ʼ������
numTK=3;
numMC=15;%�û�1-35����1��6-50����2��16-50����3�� 
w = 10*rand(1,numMC)+20;%�û�������10��30֮�����
u = 10*rand(numTK,1)+40;%���溯���ĳ�����
p = 10*rand(numTK,4)+10;%5��10֮����ȡ�ע������д��ֻ��4������

%��ʼ���ɱ�����
C1=rand(numTK,numMC);
C2=2*rand(numTK,numMC);%�ɱ�������һ����Ͷ����

TK=[1,0,0;1,1,0;1,1,1;0,1,1];%������� ������*������
wx=[0.1,0.3,0.5,0;0,0.2,0.4,0.3;0,0,0.4,0.5];%weigh of x
Ur=[0,2,6,12,15];%��Ա���� 2,5,10,3
TKF=ones(4,3)-TK;

%��������
Task = @(i,x,p) TK(:,i)'.*p(i,:)*x-u(i)*x(1)^wx(i,1)*x(2)^wx(i,2)*x(3)^wx(i,3)*x(4)^wx(i,4);
%Task = @(i,x,p) TK(:,i)'.*p(i,:)*x-u(i)*log(1+([1,1,1,1]*x));
Work = @(i,k,x,p) C1(:,k)'*(x.*x)+(C2(:,k)-p(:,i))'*x;%������˹

%�����ʼ��
Times=200;
welfare =zeros(Times);
%supply=zeros(Times,4);
pm=zeros(Times);
px=zeros(numMC,Times);
py=zeros(numTK,Times);
mismatch=zeros(4,Times);
price=zeros(numTK*4,Times);
for n=1:Times
    display(n);
    for x = 1:numTK%���������
        Taskn=@(y) Task(x,y,p);
        [A(1:4,x),py(x,n)]=fmincon(Taskn,[0;0;0;0],-eye(4),[0;0;0;0],TKF(:,x)',[0]);
        %demand(n)=demand(n)+sum(A(1:4,x));%py���淢���߱��ֵĸ����棻
    end% A������������������ÿһ�еĹ�������
    A=A.*TK;
    for i=1:4%�û���Ҫ������
        for k = Ur(i)+1:Ur(i+1)
            Workn=@(y)Work(i,k,y,p);
            B(1:3,k)=fmincon(Workn,[0;0;0],[1,1,1;-1,0,0;0,-1,0;0,0,-1],[w(k);0;0;0],TKF(i,:),[0]);
            %supply(n)=supply(n)+sum(B(1:3,k));%px���汾�ֵ��û����븺ֵ��
        end%B������������������ÿһ����Ĺ�������
    end
    
    s=zeros(numTK,4);
    for i=1:numTK
        buf=0;
        for j =1:4
            for k = Ur(j)+1:Ur(j+1)
                B(i,k)=TK(j,i)*B(i,k);
                s(i,j)=s(i,j)+B(i,k);%����j�ڶ�����i�Ĺ�����
                %welfare(n)=welfare(n)-B(i,k)*B(i,k)*C1(i,k)-B(i,k)*C2(i,k);
            end
            pm((j-1)*numTK+i,n)=abs(A(j,i)-s(i,j));%j����������i�Ĳ�ƥ��̶ȣ�
            %supply((j-1)*numTK+i,n)=m(i,j);
            p(i,j)=p(i,j)+0.005*(A(j,i)-s(i,j));
            m(i,j)=min(s(i,j),A(j,i));%��������ʵ�ʿ��õĹ�����
            for k = Ur(j)+1:Ur(j+1)
                if s(i,j)==0
                    a=0;
                else
                    a=B(i,k)/s(i,j)*m(i,j);
                end
                px(k,n)= px(k,n)+C1(i,k)*a*a+(C2(i,k)-p(i,j))*a;
            end 
            price((j-1)*numTK+i,n)=p(i,j);
            %demand((j-1)*numTK+i,n)=A(j,i);
        end
        welfare(n)=welfare(n)+u(i)*m(i,1)^wx(i,1)*m(i,2)^wx(i,2)*m(i,3)^wx(i,3)*m(i,4)^wx(i,4);%������˹
        mismatch(j,n)=sum(pm(:,n));
    end
    mismatch(1,n)=pm(1,n);
    mismatch(2,n)=pm(4,n)+pm(5,n);
    mismatch(3,n)=pm(7,n)+pm(8,n)+pm(9,n);
    mismatch(4,n)=pm(11,n)+pm(12,n);
    welfare(n)=welfare(n)-sum(sum(B.*B.*C1-B.*C2));
end

figure;%�����г���˵
subplot(221);
plot(5:5:Times,mismatch(1,5:5:Times),'--k',5:5:Times,mismatch(2,5:5:Times),'+:m',5:5:Times,mismatch(3,5:5:Times),'v-.g',5:5:Times,mismatch(4,5:5:Times),'-*r');
legend('Subarea 1','Subarea 2','Subarea 3','Subarea 4',4);
xlabel('Iteration');
ylabel('Mismatch');
subplot(222);
plot(5:5:Times,welfare(5:5:Times),'--k');
xlabel('Iteration');
ylabel('Social welfare');
subplot(223);
plot(5:5:Times,-py(1,5:5:Times),'--k',5:5:Times,-py(2,5:5:Times),'+:m',5:5:Times,-py(3,5:5:Times),'v-.g');%
xlabel('Iteration');
ylabel('profit of task initiator');
legend('Task 1','Task 2','Task 3',4);
subplot(224);
plot(5:5:Times,-px(1,5:5:Times),'--k',5:5:Times,-px(5,5:5:Times),'+:m',5:5:Times,-px(9,5:5:Times),'v-.g',5:5:Times,-px(14,5:5:Times),'-*r');
xlabel('Iteration');
ylabel('profit of mobile user');
legend('User1','User5','User9','User14',4);

figure;
subplot(2,4,5);
plot(5:5:Times,price(1,5:5:Times),'--k');%
xlabel('Iteration');
ylabel('Task price in Subarea 1')
legend('Task 1',4);
subplot(2,4,6);
plot(5:5:Times,price(4,5:5:Times),'--k',5:5:Times,price(5,5:5:Times),'+:m');%
xlabel('Iteration');
ylabel('Task price in Subarea 2')
legend('Task 1','Task 2',4);
subplot(2,4,7);
plot(5:5:Times,price(7,5:5:Times),'--k',5:5:Times,price(8,5:5:Times),'+:m',5:5:Times,price(9,5:5:Times),'v-.g');%
xlabel('Iteration');
ylabel('Task price in Subarea 3')
legend('Task 1','Task 2','Task 3',4);
subplot(2,4,8);
plot(5:5:Times,price(11,5:5:Times),'+:k',5:5:Times,price(12,5:5:Times),'v-.m');%
xlabel('Iteration');
ylabel('Task price in Subarea 4')
legend('Task 2','Task 3',4);

subplot(2,4,1);
plot(5:5:Times,pm(1,5:5:Times),'--k');%
xlabel('Iteration');
ylabel('Mismatch in Subarea 1');
legend('Task 1',4);
subplot(2,4,2);
plot(5:5:Times,pm(4,5:5:Times),'--k',5:5:Times,pm(5,5:5:Times),'+:m');%
xlabel('Iteration');
ylabel('Mismatch in Subarea 2');
legend('Task 1','Task 2',4);
subplot(2,4,3);
plot(5:5:Times,pm(7,5:5:Times),'--k',5:5:Times,pm(8,5:5:Times),'+:m',5:5:Times,pm(9,5:5:Times),'v-.g');%
xlabel('Iteration');
ylabel('Mismatch in Subarea 3');
legend('Task 1','Task 2','Task 3',4);
subplot(2,4,4);
plot(5:5:Times,pm(11,5:5:Times),'--m',5:5:Times,pm(12,5:5:Times),'+:g');%
xlabel('Iteration');
ylabel('Mismatch in Subarea 4');
legend('Task 2','Task 3',4);


%{
subplot(3,4,1);
plot(5:5:Times,demand(1,5:5:Times),'--k');%
xlabel('Iteration');
ylabel('Task demand in Subarea 1');
legend('Task 1',4);
subplot(3,4,2);
plot(5:5:Times,demand(4,5:5:Times),'--k',5:5:Times,demand(5,5:5:Times),'+:m');%
xlabel('Iteration');
ylabel('Task demand in Subarea 2');
legend('Task 1','Task 2',4);
subplot(3,4,3);
plot(5:5:Times,demand(7,5:5:Times),'--k',5:5:Times,demand(8,5:5:Times),'+:m',5:5:Times,demand(9,5:5:Times),'v-.g');%
xlabel('Iteration');
ylabel('Task demand in Subarea 3');
legend('Task 1','Task 2','Task 3',4);
subplot(3,4,4);
plot(5:5:Times,demand(11,5:5:Times),'--m',5:5:Times,demand(12,5:5:Times),'+:g');%
xlabel('Iteration');
ylabel('Task demand in Subarea 4');
legend('Task 2','Task 3',4);

subplot(3,4,5);
plot(5:5:Times,supply(1,5:5:Times),'--k');%
xlabel('Iteration');
ylabel('Task supply in Subarea 1');
legend('Task 1',4);
subplot(3,4,6);
plot(5:5:Times,supply(4,5:5:Times),'--k',5:5:Times,supply(5,5:5:Times),'+:m');%
xlabel('Iteration');
ylabel('Task supply in Subarea 2');
legend('Task 1','Task 2',4);
subplot(3,4,7);
plot(5:5:Times,supply(7,5:5:Times),'--k',5:5:Times,supply(8,5:5:Times),'+:m',5:5:Times,supply(9,5:5:Times),'v-.g');%
xlabel('Iteration');
ylabel('Task supply in Subarea 3');
legend('Task 1','Task 2','Task 3',4);
subplot(3,4,8);
plot(5:5:Times,supply(11,5:5:Times),'--m',5:5:Times,supply(12,5:5:Times),'+:g');%
xlabel('Iteration');
ylabel('Task supply in Subarea 4');
legend('Task 2','Task 3',4);
%}



