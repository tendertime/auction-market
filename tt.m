function [buf] = tt(ap,mc,numAP,numMC)
%UNTITLED2 此处显示有关此函数的摘要
for i=1:numAP
    buf=0;
    x=ap(i).limit
    for j=1:numMC 
       if mc(j)+buf<ap(i).limit
            buf=buf+mc(j);
       end
    end
end
end