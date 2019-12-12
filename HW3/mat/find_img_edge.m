clc;clear all;
%ͼ��ı�Ե����
I= imread('2.png'); 
BW1=im2bw(I,0.95);
BW2=double(BW1);
BW3=edge(BW2,'sobel');
[m, n] = size(BW3);

figure(4);
%ʹ����С���ַ��ļ��
data=[];
for i=1:m
    for j=1:n
        if (BW3(i,j)~= 0)
        T=[i,j]';
        data=[data,T];
        end;
    end;
end;
ap=polyfit(data(1,:),data(2,:),1);
AR= data(2,:)*ap(1)+ap(2);
A=[data(1,:),AR];

A1=min(data(1,:));
A2=A1*ap(1)+ap(2);
B1=max(data(1,:));
B2=B1*ap(1)+ap(2);

subplot(2,2,1); 
imshow(I), hold on;
plot([A1 A2], [B1 B2],'LineWidth',2,'Color','blue');
plot(A1,A2,'x','LineWidth',2,'Color','green');
plot(B1,B2,'x','LineWidth',2,'Color','green');
hold off

%ʹ��RANSAC��ֱ�߼��
sigma=1;
pretotal=0;
iter=100;
number = size(data,2);
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
p1 = -bestline(1)/bestline(2);
p2 = -bestline(3)/bestline(2);
C1=min(data(1,:));
C2=C1*p1+p2;
D1=max(data(1,:));
D2=B1*p1+p2;
subplot(2,2,2); 
imshow(I), hold on;
plot([C1 C2], [D1 D2],'LineWidth',2,'Color','blue');
plot(C1,C2,'x','LineWidth',2,'Color','green');
plot(D1,D2,'x','LineWidth',2,'Color','green');
hold off

%ʹ�û���任��ֱ�߼��
[H,T,R] = hough(BW3);
P  = houghpeaks(H,8,'threshold',ceil(0.2*max(H(:))));
lines= houghlines(BW3,T,R,P,'FillGap',20,'MinLength',7);
maxLength = 0;
for k = 1:length(lines)  
    xy = [lines(k).point1; lines(k).point2];
    if (((xy(1,1) - xy(2,1))^2 + (xy(1,2) - xy(2,2))^2) > maxLength) 
        maxLength = (xy(1,1) - xy(2,1))^2 + (xy(1,2) - xy(2,2))^2;
        x = xy(1,:);
        y = xy(2,:);
    end
end 

subplot(2,2,3); imshow(I), hold on;
plot([x(1) y(1)], [x(2) y(2)],'LineWidth',2,'Color','blue');
plot(x(1),x(2),'x','LineWidth',2,'Color','green');
plot(y(1),y(2),'x','LineWidth',2,'Color','green');
hold off