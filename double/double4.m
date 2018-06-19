function [] = double4()
% 初始化任务
numTK=3;
numMC=50;%用户1-35工作1；6-50工作2；16-50工作3； 
w = 20*rand(1,numMC)+10;%用户能力在10到30之间均匀
u = 20*rand(numTK,1)+80;%10到15之间均匀分布,注意之后要乘以log（）
p = 5*rand(numTK,4);%5到10之间均匀。注意这是写给只有4个区域

%初始化成本函数
C1=rand(numTK,numMC);
C2=2*rand(numTK,numMC);%成本函数的一次项和二次项；

%1区1；2区1,2；3区1,2,3；4区2,3；1区5人；2区10人；3区20人；4区15人；共50人；
TK=[1,0,0;1,1,0;1,1,1;0,1,1];%任务分配 区域数*任务数
Ur=[0,5,15,35,50];%人员分配
TKF=ones(4,3)-TK;

%函数定义
Task = @(i,x,p) TK(:,i)'.*p(i,:)*x-u(i)*log(1+([1,1,1,1]*x));
Work = @(i,k,x,p) C1(:,k)'*(x.*x)+(C2(:,k)-p(:,i))'*x;

%结果初始化
Times=60;
welfare =zeros(Times);
supply=zeros(Times,4);
demand=zeros(Times);
mismatch=zeros(4,Times);
price=zeros(numTK,4,Times);
for n=1:Times
    for x = 1:numTK%分任务计算
        Taskn=@(y) Task(x,y,p);
        A(1:4,x)=fmincon(Taskn,[0;0;0;0],-eye(4),[0;0;0;0],TKF(:,x)',[0]);
        demand(n)=demand(n)+sum(A(1:4,x));
    end% A的行是区域数，列是每一行的工作量；
    for i=1:4%用户需要分区算
        for k = Ur(i)+1:Ur(i+1)
            Workn=@(y)Work(i,k,y,p);
            B(1:3,k)=fmincon(Workn,[0;0;0],[1,1,1;-1,0,0;0,-1,0;0,0,-1],[w(k);0;0;0]);
            supply(n)=supply(n)+sum(B(1:3,k));
        end%B的行是任务数，列是每一任务的工作量；
    end
    
    m=zeros(numTK,4);
    for i=1:numTK
        buf=0;
        for j =1:4
            for k = Ur(j)+1:Ur(j+1)
                B(i,k)=TK(j,i)*B(i,k);
                buf=buf+B(i,k);%该区域的工作量总和
                m(i,j)=m(i,j)+B(i,k);
                %welfare(n)=welfare(n)-TK(j,i)*B(i,k)*B(i,k)*C1(i,k)-TK(j,i)*B(i,k)*C2(i,k);
            end
            mismatch(j,n)=mismatch(j,n)+abs(A(j,i)-buf);
            p(i,j)=p(i,j)+0.005*(A(j,i)-buf);
            m(i,j)=min(m(i,j),A(j,i));%该区域内实际可用的工作量
            price(i,j,n)=p(i,j);
        end
        welfare(n)=welfare(n)+u(i)*log(1+sum(m(i,:)));
    end
    buf=B.*B.*C1-B.*C2;
    welfare(n)=welfare(n)-sum(sum(buf));
end
subplot(211);
plot(1:Times,mismatch(1,:),'--b',1:Times,mismatch(2,:),'+:r',1:Times,mismatch(3,:),'v-.c',1:Times,mismatch(4,:),'-*m');%
xlabel('Iteration');
ylabel('Mismatch');
subplot(212);
plot(1:Times,welfare);
xlabel('Iteration');
ylabel('Social welfare');
            