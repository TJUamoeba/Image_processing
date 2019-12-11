function[ap]= cline(a,b,c)

l=1;
x=-5;
A=zeros(20,2);
while(x<5)
    %计算y值，并加入高斯噪声
    y=a*x+b;
    R=normrnd(0,0.5);
    A(l,1)=x;
    A(l,2)=y+R;
    l=l+1;
    x=x+0.5;
end

A1=zeros(20,2);
x1=-5;
l1=1;
if c==1
    %最小二乘法算得的斜率和截距
    ap=polyfit(A(:,1),A(:,2),1);

    while(x1<5)
        %根据最小二乘法所得直线方程计算y值
        y1=ap(1)*x1+ap(2);
        A1(l1,1)=x1;
        A1(l1,2)=y1;
        l1=l1+1;
        x1=x1+0.5;
    end;
end;

if c==2
    %RANSAC拟合直线
end;
%绘制图像
plot(A(:,1),A(:,2));
hold on;
plot(A1(:,1),A1(:,2));
