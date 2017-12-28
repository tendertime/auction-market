function [t1,t2,t3] = main(P,C,F,numAP,numMC,alpha) %�����ܵ����棻
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%�漰QoSȫ�����þ��ȷֲ�
packloss=[0.1,0.3,0.5,0.8,1];
latency=[0.2,0.4,0.6,0.8,1];
bandwidth=[15,40,70,90,120];
rb=[6,9,12,24,36,48,54];%wifi��������
store = (90*rand(1,numAP)+10)/F; %�ļ��Ĵ洢λ�ô�С
bid = 300*rand(1,numAP)+20;%���ȼ۸�
%bid=30*randn(1,numAP)+170;%��̬�۸�
mc = rand(1,numMC)+0.2;%mc�Ĵ�������ֲ�
%mc = 0.083*randn(1,numMC)+0.7;
mc =sort(mc,'descend');
for i=1:numAP
    ap(i).b=bandwidth(randi(5));
    ap(i).h=store(i);%����������,ֱ�Ӵ�s�㡣
    ap(i).bid=bid(i);
    ap(i).q=ap(i).b*(alpha*latency(randi(5))+(1-alpha)*packloss(randi(5)))+ap(i).h*P/C;%�ȴ�����,QoS��
    ap(i).limit=min(ap(i).b/(1-ap(i).h),rb(randi(7)));
    sea(i)=ap(i).bid/ap(i).q;
    sec(i)=ap(i).bid;
end

%%{
%DSIC:
tic;
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
        p(i)=profit+pay-payment-pro;%��APi��֧����
        sum=sum+p(i);
    end
end
t1=toc;
DSIC=profit-payment-sum;
%}
%%{
%BIC:
tic;
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
t2=toc;
BIC=profit;
%}
%%{
%OPT
tic;
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
t3=toc;
OPT=profit-payment;
end
