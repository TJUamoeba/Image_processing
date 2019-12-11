clc;
clear all;
close all;

%%%生成随机数据
%正态分布（高斯分布）点
mu=[0 0];
S=[1 2.5;2.5 8];
data1=mvnrnd(mu,S,200);
%噪点
mu=[2 2];
S=[8 0;0 8];
data2=mvnrnd(mu,S,100);
%合并数据
data=[data1',data2'];

%%% 绘制数据点
figure(4);
subplot(2,2,1);
plot(data(1,:),data(2,:),'o');
hold on;
number = size(data,2);
 
%%%使用最小二乘法
ap=polyfit(data(1,:),data(2,:),1);
AR= data(2,:)*ap(1)+ap(2);
A=[data(1,:),AR];
%绘制曲线
xAxis=min(data(1,:)):max(data(1,:));
yAxis=ap(1)*xAxis+ap(2);
subplot(2,2,1);
plot(xAxis,yAxis,'r-','LineWidth',2);
title(['最小二分法：y =',num2str(ap(1)),'x + ',num2str(ap(2))]);

%%%使用RANSAC
%%% 绘制数据点
subplot(2,2,2);
plot(data(1,:),data(2,:),'o');
hold on;

sigma=1;
pretotal=0;
iter=100;
 for i=1:iter
    %随机选择两个点
    idx = randperm(number,2); 
    sample = data(:,idx); 

    %%%拟合直线方程 y=kx+b
    line = zeros(1,3);
    x = sample(:, 1);
    y = sample(:, 2);

    k=(y(1)-y(2))/(x(1)-x(2));      %直线斜率
    b = y(1) - k*x(1);
    line = [k -1 b]

    mask=abs(line*[data; ones(1,size(data,2))]);    %求每个数据到拟合直线的距离
    total=sum(mask<sigma);              %计算数据距离直线小于一定阈值的数据的个数

    if total>pretotal            %找到符合拟合直线数据最多的拟合直线
        pretotal=total;
        bestline=line;          %找到最好的拟合直线
    end  
 end
%%% 绘制最佳匹配曲线
 bestParameter1 = -bestline(1)/bestline(2);
 bestParameter2 = -bestline(3)/bestline(2);
 xAxis = min(data(1,:)):max(data(1,:));
 yAxis = bestParameter1*xAxis + bestParameter2;
 plot(xAxis,yAxis,'r-','LineWidth',2);
 title(['RANSAC:  y =  ',num2str(bestParameter1),'x + ',num2str(bestParameter2)]);
 
 %%%使用霍夫变换
 %统计点数
 [m,n]=size(data);
 %构建霍夫空间
 n_max = 300;
 h = zeros(315,2*n_max);
 theta_i = 1;
 %设置拟合阈值
 sigma=70;
 i=0;
 for theta=0:0.01:3.14
    p=[-sin(theta),cos(theta)];
    d=p*data;
    for i=1:n
        h(theta_i,round(d(i)/10+n_max))=h(theta_i,round(d(i)/10+n_max))+1;  
    end;
        theta_i=theta_i+1;  
 end;
[theta_x,p]=find(h>sigma);%查找投票数大于sigma的位置  
l_number=size(theta_x);%符合直线条数 
r=(p-n_max)*10;%将还原回距离R  
theta_x=0.01*theta_x;%将theta还原  
%绘制数据点
subplot(2,2,3);
plot(data(1,:),data(2,:),'o');
hold on;
x_line=-10:5:10;  
xAxis = min(data(1,:)):max(data(1,:));
yAxis = bestParameter1*xAxis + bestParameter2;
plot(xAxis,yAxis,'r-','LineWidth',2);
title('HUFF');
y=tan(theta_x(1))*x_line+r(1)/cos(theta_x(1));%画出拟合曲线  
plot(x_line,y,'r');  
