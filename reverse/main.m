function [DSIC,BIC,OPT] = main(P,C,zi,numAP) %�����ܵ����棻
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bandwidth=[6,8,10,15,20];
store = 90*rand(1,numAP)+10; %�洢�ռ�
bid = 8*rand(1,numAP)+7;%���ȼ۸�
aim=600;%����Ŀ��600Mʱ
for i=1:numAP
    ap(i).b=bandwidth(randi(4));%�س̴���
    ap(i).s=store(i);
    ap(i).h=zipf(store(i),10000,zi);%����������,ֱ�Ӵ�s�㡣
    ap(i).bid=bid(i);
    sea(i)=ap(i).bid/(P-C*(1-ap(i).h));
    ap(i).limit=ap(i).b/(1-ap(i).h);
end
%%{
%DSIC:
tic;
[~,soa]=sort(sea);
[payment,profit,y] = mcap(ap,numAP,P,C,aim,soa);
sum=0;
for i=1:numAP
    if y(i)==1
        fa=ap;
        fa(i)=[];
        sear=sea;
        sear(i)=[];
        [~,seoa]=sort(sear);
        [pay,pro,~] = mcap( fa,numAP-1,P,C,aim,seoa);
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
[~,profit,~] = mcap(ap,numAP,P,C,aim,soa);
sum=0;
for i=1:numAP
    fa=ap;
    fa(i)=[];
    sear=sea;
    sear(i)=[];
    [~,seoa]=sort(sear);
    [pay,~,~] = mcap(fa,numAP-1,P,C,aim,seoa);
    sum=sum+pay;
    p(i)=pay;
end
for i=1:numAP
    p(i)=p(i)-(sum-p(i))/(numAP-1);
end
t2=toc;
BIC=profit;
%}
%OPT
tic;
%�ȼ���H
[~,soa]=sort(sea);%�Ȱ���������Լ۱�����lf��Ϊ�ֲ�������mf��Ϊ�ܶȺ�����mfͳ��һģһ���ĳ����˼��Σ�lfͳ�Ʋ����������ж���
x=1;
for i=1:numAP-1%��С�����
    if(sea(soa(i)) ~= sea(soa(i+1)))%�������һ��ֵ��һ�� mf����ͳ��ͬһ��ֵ�����˼��Σ������һ����Ϊ׼��
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
sec(soa(numAP)).lf=1;%�������һ����������mf
for i=1:numAP-1%�Ӵ�С����һ��
    if(sec(soa(numAP-i)).lf==0)%ÿ���쳣ʱ���Ӻ���ǰ����һ�Σ�
        sec(soa(numAP-i)).lf=sec(soa(numAP-i+1)).lf;
        sec(soa(numAP-i)).mf=sec(soa(numAP-i+1)).mf;
    end
end
for i=1:numAP
    sc(i)=sec(i).lf/sec(i).mf+ap(i).bid;%H
end
[~,soc]=sort(sc);

[payment,profit,y] = mcap(ap,numAP,P,C,aim,soc);
cp=1;
for i=1:numAP
    if y(i)==1
        va(cp).c=ap(i).bid;
        va(cp).q=sea(i); 
        cp=cp+1;
    end
end%��������ѡ�е�AP ����VA��ʤ����AP������C������Q��һ��CP��
cp=cp-1;
for i=1:cp
    sed(i)=va(i).q;
end
[~,sod]=sort(sed);%��q��������
minv=99999;
maxv=0;
for i=1:cp-1
    maxv=max(va(sod(i)).c,maxv);
    minv=min(va(sod(i)).c,minv);
    va(sod(i)).lc=maxv;
    va(sod(i)).mc=minv; 
    if (va(sod(i)).q~=va(sod(i+1)).q)%�ظ�֮ǰ��λ��
        maxv=0;
        minv=99999;
    end
end
va(sod(cp)).lc=max(va(sod(cp)).c,maxv);
va(sod(cp)).mc=min(va(sod(cp)).c,minv); %�������һ��
for i=1:cp-1%�Ӻ���ǰ����һ�飻
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
