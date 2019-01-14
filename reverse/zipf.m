function [sum] = zipf(s,c,alpha)
%ZIPF 此处显示有关此函数的摘要
%   此处显示详细说明
%s表示自身存储空间，c表示整体；假设本地10-100G；整体100M*c个;alpha是zipf参数
num=floor(s*1024/100);%存储了num个内容
sum=0;
for i=1:num
    sum=sum+1/i^alpha;
end%访问本地存在的内容
w=0;
for i=1:c
    w=w+1/i^alpha;
end%访问全部内容
sum=sum/w;
end

