function [img] = myline(X,Y)
%MYLINE ��ʾ��ͬ��ɫ�ĺ���ͼ��
%   �˴���ʾ��ϸ˵��
x=0:pi/100:2*pi;
y1=sin(x);
y2=cos(x);
y3=x.^2;
figure,plot(x,y1,'red',x,y2,'green',x,y3,'blue'),title('����ͼ��');
set(1,'position',[100,100,X,Y]);
print(1,'-dpng','out');
img = imread('out.png');
end

