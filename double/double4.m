function [] = double4()
% ��ʼ������
numTK=3;
numMC=20;%�û�1-35����1��6-50����2��16-50����3�� 
w = 20*rand(1,numMC)+10;%�û�������10��30֮�����
u = 80*rand(numTK,1)+20;%���溯���ĳ�����
p = 10*rand(numTK,4)+10;%5��10֮����ȡ�ע������д��ֻ��4������

%��ʼ���ɱ�����
C1=rand(numTK,numMC);
C2=2*rand(numTK,numMC);%�ɱ�������һ����Ͷ����

TK=[1,0,0;1,1,0;1,1,1;0,1,1];%������� ������*������
wx=[0.1,0.3,0.5,0;0,0.2,0.4,0.3;0,0,0.4,0.5];%weigh of x
Ur=[0,2,7,17,20];%��Ա���� 2,5,10,3
TKF=ones(4,3)-TK;

%��������
Task = @(i,x,p) TK(:,i)'.*p(i,:)*x-u(i)*x(1)^wx(i,1)*x(2)^wx(i,2)*x(3)^wx(i,3)*x(4)^wx(i,4);
%Task = @(i,x,p) TK(:,i)'.*p(i,:)*x-u(i)*log(1+([1,1,1,1]*x));
Work = @(i,k,x,p) C1(:,k)'*(x.*x)+(C2(:,k)-p(:,i))'*x;%������˹

%�����ʼ��
Times=300;
welfare =zeros(Times);
supply=zeros(Times,4);
demand=zeros(Times);
mismatch=zeros(4,Times);
price=zeros(numTK*4,Times);
for n=1:Times
    display(n);
    for x = 1:numTK%���������
        Taskn=@(y) Task(x,y,p);
        A(1:4,x)=fmincon(Taskn,[0;0;0;0],-eye(4),[0;0;0;0],TKF(:,x)',[0]);
        demand(n)=demand(n)+sum(A(1:4,x));
    end% A������������������ÿһ�еĹ�������
    A=A.*TK;
    for i=1:4%�û���Ҫ������
        for k = Ur(i)+1:Ur(i+1)
            Workn=@(y)Work(i,k,y,p);
            B(1:3,k)=fmincon(Workn,[0;0;0],[1,1,1;-1,0,0;0,-1,0;0,0,-1],[w(k);0;0;0],TKF(i,:),[0]);
            supply(n)=supply(n)+sum(B(1:3,k));
        end%B������������������ÿһ����Ĺ�������
    end
    
    m=zeros(numTK,4);
    for i=1:numTK
        buf=0;
        for j =1:4
            for k = Ur(j)+1:Ur(j+1)
                B(i,k)=TK(j,i)*B(i,k);
                m(i,j)=m(i,j)+B(i,k);%����j�ڶ�����i�Ĺ�����
                %welfare(n)=welfare(n)-B(i,k)*B(i,k)*C1(i,k)-B(i,k)*C2(i,k);
            end
            mismatch(j,n)=mismatch(j,n)+abs(A(j,i)-m(i,j));
            supply((j-1)*numTK+i,n)=m(i,j);
            p(i,j)=p(i,j)+0.005*(A(j,i)-m(i,j));
            m(i,j)=min(m(i,j),A(j,i));%��������ʵ�ʿ��õĹ�����
            price((j-1)*numTK+i,n)=p(i,j);
            demand((j-1)*numTK+i,n)=A(j,i);
        end
        %welfare(n)=welfare(n)+u(i)*log(1+sum(m(i,:)));
        welfare(n)=welfare(n)+u(i)*m(i,1)^wx(i,1)*m(i,2)^wx(i,2)*m(i,3)^wx(i,3)*m(i,4)^wx(i,4);%������˹
    end
    welfare(n)=welfare(n)-sum(sum(B.*B.*C1-B.*C2));
end

figure;
subplot(211);
plot(2:Times,mismatch(1,2:Times),'--k',2:Times,mismatch(2,2:Times),'+:k',2:Times,mismatch(3,2:Times),'v-.k',2:Times,mismatch(4,2:Times),'-*k');
legend('Subarea 1','Subarea 2','Subarea 3','Subarea 4',4);
xlabel('Iteration');
ylabel('Mismatch');
subplot(212);
plot(2:Times,welfare(2:Times),'--k');
xlabel('Iteration');
ylabel('Social welfare');



figure;
subplot(3,4,9);
plot(2:Times,price(1,2:Times),'--k');%
xlabel('Iteration');
ylabel('Task price in Subarea 1')
legend('Task 1',4);
subplot(3,4,10);
plot(2:Times,price(4,2:Times),'--k',2:Times,price(5,2:Times),'+:k');%
xlabel('Iteration');
ylabel('Task price in Subarea 2')
legend('Task 1','Task 2',4);
subplot(3,4,11);
plot(2:Times,price(7,2:Times),'--k',2:Times,price(8,2:Times),'+:k',2:Times,price(9,2:Times),'v-.k');%
xlabel('Iteration');
ylabel('Task price in Subarea 3')
legend('Task 1','Task 2','Task 3',4);
subplot(3,4,12);
plot(2:Times,price(11,2:Times),'+:k',2:Times,price(12,2:Times),'v-.k');%
xlabel('Iteration');
ylabel('Task price in Subarea 4')
legend('Task 2','Task 3',4);

subplot(3,4,1);
plot(2:Times,demand(1,2:Times),'--k');%
xlabel('Iteration');
ylabel('Task demand in Subarea 1');
legend('Task 1',4);
subplot(3,4,2);
plot(2:Times,demand(4,2:Times),'--k',2:Times,demand(5,2:Times),'+:k');%
xlabel('Iteration');
ylabel('Task demand in Subarea 2');
legend('Task 1','Task 2',4);
subplot(3,4,3);
plot(2:Times,demand(7,2:Times),'--k',2:Times,demand(8,2:Times),'+:k',2:Times,demand(9,2:Times),'v-.k');%
xlabel('Iteration');
ylabel('Task demand in Subarea 3');
legend('Task 1','Task 2','Task 3',4);
subplot(3,4,4);
plot(2:Times,demand(11,2:Times),'--k',2:Times,demand(12,2:Times),'+:k');%
xlabel('Iteration');
ylabel('Task demand in Subarea 4');
legend('Task 2','Task 3',4);

subplot(3,4,5);
plot(2:Times,supply(1,2:Times),'--k');%
xlabel('Iteration');
ylabel('Task supply in Subarea 1');
legend('Task 1',4);
subplot(3,4,6);
plot(2:Times,supply(4,2:Times),'--k',2:Times,supply(5,2:Times),'+:k');%
xlabel('Iteration');
ylabel('Task supply in Subarea 2');
legend('Task 1','Task 2',4);
subplot(3,4,7);
plot(2:Times,supply(7,2:Times),'--k',2:Times,supply(8,2:Times),'+:k',2:Times,supply(9,2:Times),'v-.k');%
xlabel('Iteration');
ylabel('Task supply in Subarea 3');
legend('Task 1','Task 2','Task 3',4);
subplot(3,4,8);
plot(2:Times,supply(11,2:Times),'--k',2:Times,supply(12,2:Times),'+:k');%
xlabel('Iteration');
ylabel('Task supply in Subarea 4');
legend('Task 2','Task 3',4);

