function [ output_args ] = double3( input_args )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% 初始化任务
for i = 1:numTK
    u(i) = 5*rand(1,1)+20;%10到15之间均匀分布,注意之后要乘以log（）
    p(i) = 5*rand(1,1);%5到10之间均匀。注意这是写给只有一个区域
end
%初始化成本函数
C1=rand(numTK,numMC);
C2=2*rand(numTK,numMC);%成本函数的一次项和二次项；
%初始化的任务量；
A=20*rand(1,numTK)+10;
B=5*rand(numTK,numMC)+5;
%暂定划分如下：任务1在1区；任务2在1，2；任务3在1，2，3；任务4在2,3；
%分别对每一区展开计算；1区考虑1,2，3；2区考虑2,3,4；3区考虑3,4；
end

