clc;
clear all;
close all;

%%%�����������
%��̬�ֲ�����˹�ֲ�����
mu=[0 0];
S=[1 2.5;2.5 8];
data1=mvnrnd(mu,S,200);
%���
mu=[2 2];
S=[8 0;0 8];
data2=mvnrnd(mu,S,100);
%�ϲ�����
data=[data1',data2'];

%%% �������ݵ�
figure(4);
subplot(2,2,1);
plot(data(1,:),data(2,:),'o');
hold on;
number = size(data,2);
 
%%%ʹ����С���˷�
ap=polyfit(data(1,:),data(2,:),1);
AR= data(2,:)*ap(1)+ap(2);
A=[data(1,:),AR];
%��������
xAxis=min(data(1,:)):max(data(1,:));
yAxis=ap(1)*xAxis+ap(2);
subplot(2,2,1);
plot(xAxis,yAxis,'r-','LineWidth',2);
title(['��С���ַ���y =',num2str(ap(1)),'x + ',num2str(ap(2))]);

%%%ʹ��RANSAC
%%% �������ݵ�
subplot(2,2,2);
plot(data(1,:),data(2,:),'o');
hold on;

sigma=1;
pretotal=0;
iter=100;
 for i=1:iter
    %���ѡ��������
    idx = randperm(number,2); 
    sample = data(:,idx); 

    %%%���ֱ�߷��� y=kx+b
    line = zeros(1,3);
    x = sample(:, 1);
    y = sample(:, 2);

    k=(y(1)-y(2))/(x(1)-x(2));      %ֱ��б��
    b = y(1) - k*x(1);
    line = [k -1 b]

    mask=abs(line*[data; ones(1,size(data,2))]);    %��ÿ�����ݵ����ֱ�ߵľ���
    total=sum(mask<sigma);              %�������ݾ���ֱ��С��һ����ֵ�����ݵĸ���

    if total>pretotal            %�ҵ��������ֱ�������������ֱ��
        pretotal=total;
        bestline=line;          %�ҵ���õ����ֱ��
    end  
 end
%%% �������ƥ������
 bestParameter1 = -bestline(1)/bestline(2);
 bestParameter2 = -bestline(3)/bestline(2);
 xAxis = min(data(1,:)):max(data(1,:));
 yAxis = bestParameter1*xAxis + bestParameter2;
 plot(xAxis,yAxis,'r-','LineWidth',2);
 title(['RANSAC:  y =  ',num2str(bestParameter1),'x + ',num2str(bestParameter2)]);
 
 %%%ʹ�û���任
 %ͳ�Ƶ���
 [m,n]=size(data);
 %��������ռ�
 n_max = 300;
 h = zeros(315,2*n_max);
 theta_i = 1;
 %���������ֵ
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
[theta_x,p]=find(h>sigma);%����ͶƱ������sigma��λ��  
l_number=size(theta_x);%����ֱ������ 
r=(p-n_max)*10;%����ԭ�ؾ���R  
theta_x=0.01*theta_x;%��theta��ԭ  
%�������ݵ�
subplot(2,2,3);
plot(data(1,:),data(2,:),'o');
hold on;
x_line=-10:5:10;  
xAxis = min(data(1,:)):max(data(1,:));
yAxis = bestParameter1*xAxis + bestParameter2;
plot(xAxis,yAxis,'r-','LineWidth',2);
title('HUFF');
y=tan(theta_x(1))*x_line+r(1)/cos(theta_x(1));%�����������  
plot(x_line,y,'r');  
