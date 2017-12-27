function y = test()
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
num=300;
for i=1:num
    x(i).j=randi(20);
    x(i).k=x(i).j+10;
end
y=tt(num,x);
end

