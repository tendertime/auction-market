function [sum] = zipf(s,c,alpha)
%ZIPF �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%s��ʾ����洢�ռ䣬c��ʾ���壻���豾��10-100G������100M*c��;alpha��zipf����
num=floor(s*1024/100);%�洢��num������
sum=0;
for i=1:num
    sum=sum+1/i^alpha;
end%���ʱ��ش��ڵ�����
w=0;
for i=1:c
    w=w+1/i^alpha;
end%����ȫ������
sum=sum/w;
end

