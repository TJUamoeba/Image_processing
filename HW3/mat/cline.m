function[ap]= cline(a,b,c)

l=1;
x=-5;
A=zeros(20,2);
while(x<5)
    %����yֵ���������˹����
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
    %��С���˷���õ�б�ʺͽؾ�
    ap=polyfit(A(:,1),A(:,2),1);

    while(x1<5)
        %������С���˷�����ֱ�߷��̼���yֵ
        y1=ap(1)*x1+ap(2);
        A1(l1,1)=x1;
        A1(l1,2)=y1;
        l1=l1+1;
        x1=x1+0.5;
    end;
end;

if c==2
    %RANSAC���ֱ��
end;
%����ͼ��
plot(A(:,1),A(:,2));
hold on;
plot(A1(:,1),A1(:,2));
