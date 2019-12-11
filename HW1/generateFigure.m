    
function [img] = generateFigure(imgH ,imgW )
img = zeros(imgH,imgW,3);
img = uint8(img);
% 把图片设置为白色
img(:,:,1)=255;
img(:,:,2)=255;
img(:,:,3)=255;
% 生成x的0-2*pi数据
x=0:2*pi/(imgW-1):2*pi;
% 计算相应的y
red_y=sin(x);
green_y=cos(x);
blue_y=x.^2;
% 把x映射到图片的宽
x=int32(x/2/pi*imgW);
% 把y映射到图片的高
red_y=int32(imgH/40*39-round(red_y*imgH/40));
green_y=int32(imgH/40*39-round(green_y*imgH/40));
blue_y=int32(imgH/40*39-round(blue_y*imgH/40));
% 遍历数据渲染图片
for i=1:imgW
    if x(i)==0
        x(i)=x(i)+1;
    end
    if red_y(i)>0 && red_y(i)<=imgH
        img(red_y(i),x(i),2)=0;
        img(red_y(i),x(i),3)=0;
    end
    if green_y(i)>0 && green_y(i)<=imgH
        img(green_y(i),x(i),3)=0;
        img(green_y(i),x(i),1)=0;
    end
    if blue_y(i)>0 && blue_y(i)<=imgH
        img(blue_y(i),x(i),1)=0;
        img(blue_y(i),x(i),2)=0;
    end
end
% 绘制黑色坐标轴
img(:,1,:)=0;
img(round(imgH/40*39),:,:)=0;
% 展示图片
imshow(img);
end

