function [p,sum] = vcg(P,C,zi,numAP)
bandwidth=[6,8,10,15,20];
store = 90*rand(1,numAP)+10; %�洢�ռ�
bid = 8*rand(1,numAP)+7;%���ȼ۸�
aim=200;%����Ŀ��ʱ
co=[2,5,12]*pi*37.3*37.3/1000;%cover
co=ceil(co);
for i=1:numAP
    ap(i).b=bandwidth(randi(5));%�س̴���
    ap(i).s=store(i);
    ap(i).h=zipf(store(i),10000,zi);%����������,ֱ�Ӵ�s�㡣
    ap(i).bid=bid(i);
    sea(i)=ap(i).bid/(P-C*(1-ap(i).h))/ap(i).b;
    ap(i).limit=ap(i).b/(1-ap(i).h);
    ap(i).l=co(3);
end
msd=zeros(numAP,co(3));
msl=40*ones(numAP,co(3));
for i=1:numAP
    mcl=38*rand(1,ap(i).l);%����ֲ�����
    mcd=2.5*rand(1,ap(i).l)+0.5;%����ֲ�����
    [mcl,rl]=sort(mcl);%��������ԭ��˳����
    for j=1:ap(i).l
        msd(i,j)=mcd(rl(j));
        msl(i,j)=mcl(j);
    end
end
[~,soa]=sort(sea);
[payment,profit,y] =mcap(ap,numAP,P,C,aim,soa,msd,msl);
sum=0;
p=zeros(1,numAP);
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
        p(soa(i))=profit+pay-payment-pro;%��APi��֧����
        sum=sum+p(soa(i));
    end
end
DSIC=profit-sum;
end