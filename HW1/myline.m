function [img] = myline(X,Y)
%MYLINE 显示不同颜色的函数图像
%   此处显示详细说明
x=0:pi/100:2*pi;
y1=sin(x);
y2=cos(x);
y3=x.^2;
figure,plot(x,y1,'red',x,y2,'green',x,y3,'blue'),title('函数图像');
set(1,'position',[100,100,X,Y]);
print(1,'-dpng','out');
img = imread('out.png');
end

