function [DSIC,BIC,OPT] = main(P,C,F,numAP,numMC,alpha) %返回总的收益；
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%init the result
numAP=60;
numMC=300;
%定义AP的wifi速率
P=10;%流量利润
C=1;%缓存回取开销
F=10000;%总文件数
alpha=0.5;
%涉及QoS全部采用均匀分布
packloss=[0.1,0.3,0.5,0.8,1];
latency=[0.2,0.4,0.6,0.8,1];
bandwidth=[15,40,70,90,120];
rb=[6,9,12,24,36,48,54];%wifi连接速率
store = (90*rand(1,numAP)+10)/F; %文件的存储位置大小
%apx = unifrnd (0,300,1,numAP); %random for location
%apy = unifrnd (0,300,1,numAP);
bid = 500*rand(1,numAP)+20;%均匀价格
%bid=30*randn（1，numAP）+20;%正态价格
mc = rand(1,numMC)+0.2;%mc的带宽需求分布
mc =sort(mc,'descend');
for i=1:numAP
    %ap(i).x=apx(i);
    %ap(i).y=apx(i);%位置信息暂不考虑
    ap(i).b=bandwidth(randi(5));
    ap(i).h=store(i);%缓存命中率,直接从s算。
    ap(i).bid=bid(i);
    ap(i).q=ap(i).b*(alpha*latency(randi(5))+(1-alpha)*packloss(randi(5)))+ap(i).h*P/C;%等待计算,QoS；
    ap(i).limit=min(ap(i).b/(1-ap(i).h),rb(randi(7)));
    sea(i)=ap(i).bid/ap(i).q;
    sec(i)=ap(i).bid;
end

%%{
%DSIC:
[~,soa]=sort(sea);
[payment,profit,~,y] = mcap(ap,mc,numAP,numMC,P,C,soa);
sum=0;
for i=1:numAP
    if y(i)==1
        fa=ap;
        fa(i)=[];
        sear=sea;
        sear(i)=[];
        [~,seoa]=sort(sear);
        [pay,pro,~,~] = mcap( fa,mc,numAP-1,numMC,P,C,seoa);
        p(i)=profit+pay-payment-pro;%给APi的支付；
        sum=sum+p(i);
    end
end
DSIC=profit-payment-sum;
%}
%%{
%BIC:
[~,soa]=sort(sea);
[~,profit,~,~] = mcap( ap,mc,numAP,numMC,P,C,soa);
sum=0;
for i=1:numAP
    fa=ap;
    fa(i)=[];
    sear=sea;
    sear(i)=[];
    [~,seoa]=sort(sear);
    [pay,~,~,~] = mcap(fa,mc,numAP-1,numMC,P,C,seoa);
    sum=sum+pay;
    p(i)=pay;
end
for i=1:numAP
    p(i)=p(i)-(sum-p(i))/(numAP-1);
end
BIC=profit;
%}
%%{
%OPT
[~,soa]=sort(sea);
[payment,profit,~,y] = mcap( ap,mc,numAP,numMC,P,C,soa);
fi=0;
sum=0;
[~,so]=sort(sec,'descend');
for i=1:numAP
    if y(so(i))==1
        if(fi==0)
            max=ap(so(i)).bid;
            fi=1;
        end
        p(so(i))=max-ap(so(i)).bid;
        sum=sum+p(so(i));
    else
        p(so(i))=0;
    end
end
payment=payment+sum;
%}
OPT=profit-payment;
end
