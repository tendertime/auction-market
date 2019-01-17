function [t1,t2,t3] = main(P,C,zi,numAP) %返回总的收益；
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bandwidth=[6,8,10,15,20];
store = 90*rand(1,numAP)+10; %存储空间
bid = 8*rand(1,numAP)+7;%均匀价格
aim=600;%带宽目标时
co=[2,5,12]*pi*37.3*37.3/1000;%cover
co=ceil(co);
%{
if emm==1
    x1=1;
elseif emm==2
    x1=0.8;
    x2=0.95;
elseif emm==3
    x1=0.6;
    x2=0.9;
else
    x1=0;
    x2=1;
end
%}
for i=1:numAP
    ap(i).b=bandwidth(randi(5));%回程带宽
    ap(i).s=store(i);
    ap(i).h=zipf(store(i),10000,zi);%缓存命中率,直接从s算。
    ap(i).bid=bid(i);
    ap(i).limit=ap(i).b/(1-ap(i).h);
    sea(i)=ap(i).bid-ap(i).limit*(P-C*(1-ap(i).h));
    ap(i).l=co(3);
    %{
    l=rand(1);
    if(l<x1)%大城市概率80
        
    elseif (l>x2)%小城市概率5 
        ap(i).l=co(1);
    else ap(i).l=co(2);%进入中等城市
    end
    %}
end
msd=zeros(numAP,co(3));
msl=40*ones(numAP,co(3));
for i=1:numAP
    mcl=38*rand(1,ap(i).l);%随机分布距离
    mcd=2.5*rand(1,ap(i).l)+0.5;%随机分布需求；
    [mcl,rl]=sort(mcl);%距离排序，原有顺序是
    for j=1:ap(i).l
        msd(i,j)=mcd(rl(j));
        msl(i,j)=mcl(j);
    end
end

%%{
%DSIC:
tic;
[~,soa]=sort(sea);
%{
[payment,profit,y] = mcap(ap,numAP,P,C,aim,soa);
sum=0;
for i=1:numAP
    if y(soa(i))==1
        fa=ap;
        fa(soa(i))=[];
        sear=sea;
        sear(soa(i))=[];
        [~,seoa]=sort(sear);
        [pay,pro,~] = mcap(fa,numAP-1,P,C,aim,seoa);
        p(soa(i))=profit+pay-payment-pro;%给APi的支付；
        sum=sum+p(soa(i));
    end
end
%}
[payment,profit,y] =mcap(ap,numAP,P,C,aim,soa,msd,msl);
sum=0;
for i=1:numAP
    if y(soa(i))==0
        break;
    else
        fa=ap;
        fa(soa(i))=[];
        sear=sea;
        sear(soa(i))=[];
        [~,seoa]=sort(sear);
        mssd=msd;
        mssd(soa(i),:)=[];
        mssl=msl;
        mssl(soa(i),:)=[];
        [pay,pro,~] = mcap(fa,numAP-1,P,C,aim,seoa,mssd,mssl);
        p(soa(i))=profit-payment-pro+pay;%给APi的支付；
        sum=sum+p(soa(i));
    end
end
%}
t1=toc;
DSIC=profit-sum-payment;
%}
%%{
%BIC:
tic;
[~,soa]=sort(sea);
[~,profit,~] =mcap(ap,numAP,P,C,aim,soa,msd,msl);
sum=0;
for i=1:numAP
    fa=ap;
    fa(soa(i))=[];
    sear=sea;
    sear(soa(i))=[];
    [~,seoa]=sort(sear);
    mssd=msd;
    mssd(soa(i),:)=[];
    mssl=msl;
    mssl(soa(i),:)=[];
    [pay,pro,~]=mcap(fa,numAP-1,P,C,aim,seoa,mssd,mssl);
    sum=sum+pay-pro;
    p(soa(i))=pay-pro;
end
for i=1:numAP
    p(i)=p(i)-(sum-p(i))/(numAP-1);
end
t2=toc;
BIC=profit;
%}
%OPT
tic;
%先计算H
[~,soa]=sort(sea);%先按照最初的性价比排序，lf作为分布函数，mf作为密度函数：mf统计一模一样的出现了几次；lf统计不超过它的有多少
x=1;
for i=1:numAP-1%从小到大的
    if(sea(soa(i)) ~= sea(soa(i+1)))%如果和下一个值不一样 mf用于统计同一个值出现了几次，以最后一个点为准；
        sec(soa(i)).lf=i;
        sec(soa(i)).mf=x;
        x=1;
    else
        sec(soa(i)).lf=0;
        sec(soa(i)).mf=0;
        x=x+1;
    end
end
sec(soa(numAP)).mf=x;
sec(soa(numAP)).lf=1;%对于最后一个点正常算mf
for i=1:numAP-1%从大到小再来一遍
    if(sec(soa(numAP-i)).lf==0)%每当异常时都从后往前共享一次）
        sec(soa(numAP-i)).lf=sec(soa(numAP-i+1)).lf;
        sec(soa(numAP-i)).mf=sec(soa(numAP-i+1)).mf;
    end
end
for i=1:numAP
    sc(i)=sec(i).lf/sec(i).mf+ap(i).bid;%H
end
[~,soc]=sort(sc);

[payment,profit,y] =mcap(ap,numAP,P,C,aim,soc,msd,msl);
cp=1;
for i=1:numAP
    if y(i)==1
        va(cp).c=ap(i).bid;
        va(cp).q=sea(i); 
        cp=cp+1;
    end
end%记下所有选中的AP 计入VA（胜利的AP）报价C和质量Q；一共CP个
cp=cp-1;
for i=1:cp
    sed(i)=va(i).q;
end
[~,sod]=sort(sed);%按q重新排序
minv=99999;
maxv=0;
for i=1:cp-1
    maxv=max(va(sod(i)).c,maxv);
    minv=min(va(sod(i)).c,minv);
    va(sod(i)).lc=maxv;
    va(sod(i)).mc=minv; 
    if (va(sod(i)).q~=va(sod(i+1)).q)%重复之前归位；
        maxv=0;
        minv=99999;
    end
end
va(sod(cp)).lc=max(va(sod(cp)).c,maxv);
va(sod(cp)).mc=min(va(sod(cp)).c,minv); %计算最后一个
for i=1:cp-1%从后往前再来一遍；
    if va(sod(cp-i)).q==va(sod(cp-i+1)).q
        va(sod(cp-i)).lc=va(sod(cp-i+1)).lc;
        va(sod(cp-i)).mc=va(sod(cp-i+1)).mc;
    end
end
sum=0;
for i=1:cp
    sum=sum+0.5*va(i).lc*va(i).lc-0.5*va(i).c*va(i).c+va(i).c*va(i).mc-va(i).lc*va(i).mc;% large,
end
t3=toc;
OPT=profit-payment-sum;
end
