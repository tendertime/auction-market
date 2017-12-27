function [DSIC,BIC,OPT] = main(P,C,F,numAP,numMC,alpha) %�����ܵ����棻
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%init the result
numAP=60;
numMC=300;
%����AP��wifi����
P=10;%��������
C=1;%�����ȡ����
F=10000;%���ļ���
alpha=0.5;
%�漰QoSȫ�����þ��ȷֲ�
packloss=[0.1,0.3,0.5,0.8,1];
latency=[0.2,0.4,0.6,0.8,1];
bandwidth=[15,40,70,90,120];
rb=[6,9,12,24,36,48,54];%wifi��������
store = (90*rand(1,numAP)+10)/F; %�ļ��Ĵ洢λ�ô�С
%apx = unifrnd (0,300,1,numAP); %random for location
%apy = unifrnd (0,300,1,numAP);
bid = 500*rand(1,numAP)+20;%���ȼ۸�
%bid=30*randn��1��numAP��+20;%��̬�۸�
mc = rand(1,numMC)+0.2;%mc�Ĵ�������ֲ�
mc =sort(mc,'descend');
for i=1:numAP
    %ap(i).x=apx(i);
    %ap(i).y=apx(i);%λ����Ϣ�ݲ�����
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
