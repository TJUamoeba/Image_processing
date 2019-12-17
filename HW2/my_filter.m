close all; clc;clear all;
%均值滤波器
filepath='test.png';
I_origin=im2double(imread(filepath));
I_origin=padarray(I_origin,[2,2],'replicate','both');
I_origin=rgb2gray(I_origin);
[img_H,img_W]=size(I_origin);
figure(1);
subplot(3,4,1);
imshow(I_origin,[]);title('原图像');

%添加椒盐噪声
subplot(3,4,2);
I_noise=double(imnoise(I_origin,'salt & pepper',0.02));
imshow(I_noise,[]);title('添加噪声');

%算术均值滤波
for i=2:1:img_H-1
    for j=2:1:img_W-1
        Mean1(i,j)= (I_noise(i-1,j-1)+I_noise(i-1,j)+I_noise(i-1,j+1)+I_noise(i,j-1)+I_noise(i,j)+I_noise(i,j+1)+I_noise(i+1,j-1)+I_noise(i+1,j)+I_noise(i+1,j+1))/9;
    end;
end;
subplot(3,4,3);
imshow(Mean1,[]);title('算术均值滤波');
imwrite(mat2gray(Mean1),'.\result\arithmetic_filter.png');

%几何均值滤波
temp=I_noise+ones(img_H,img_W);
for i=2:1:img_H-1
    for j=2:1:img_W-1
        t=temp(i-1:i+1,j-1:j+1);
        s=prod(t(:));
        Mean2(i,j)=s.^(1/numel(t));
    end;
end;
subplot(3,4,4);
imshow(Mean2,[]);title('几何均值滤波');
imwrite(mat2gray(Mean2),'.\result\geometric_filter.png');

%谐波均值滤波器
for i=2:1:img_H-1
    for j=2:1:img_W-1
        t=I_noise(i-1:i+1,j-1:j+1);
        t=1./t;
        Mean3(i,j)=numel(t)/sum(t(:));
    end;
end;
subplot(3,4,5);
imshow(Mean3,[]);title('谐波均值滤波');
imwrite(mat2gray(Mean3),'.\result\harmonic_filter.png');

%逆谐波均值滤波器
for i=2:1:img_H-1
    for j=2:1:img_W-1
        t=I_noise(i-1:i+1,j-1:j+1);
        Mean4(i,j)=sum(t(:).^4)/sum(t(:).^3);
    end;
end;
subplot(3,4,6);
imshow(Mean4,[]);title('逆谐波均值滤波');
imwrite(mat2gray(Mean4),'.\result\inverse_arithmetic_filter.png');

%中值滤波
Mean5=medfilt2(I_noise,[3 3]);
subplot(3,4,7);
imshow(Mean5,[]);title('中值滤波');
imwrite(mat2gray(Mean5),'.\result\median_filter.png');

%最大值滤波
for i=2:1:img_H-1
    for j=2:1:img_W-1
        t=I_noise(i-1:i+1,j-1:j+1);
        line=t(:);
        Mean6(i,j)=max(line);
    end;
end;
subplot(3,4,8);
imshow(Mean6,[]);title('最大值滤波');
imwrite(mat2gray(Mean6),'.\result\maximum_filter.png');

%最小值滤波
for i=2:1:img_H-1
    for j=2:1:img_W-1
        t=I_noise(i-1:i+1,j-1:j+1);
        line=t(:);
        Mean7(i,j)=min(line);
    end;
end;
subplot(3,4,9);
imshow(Mean7,[]);title('最小值滤波');
imwrite(mat2gray(Mean7),'.\result\minimum_filter.png');

%中点滤波
for i=2:1:img_H-1
    for j=2:1:img_W-1
        t=I_noise(i-1:i+1,j-1:j+1);
        line=t(:);
        Mean8(i,j)= (max(line)+min(line))/2;
    end;
end;
subplot(3,4,10);
imshow(Mean8,[]);title('中点滤波');
imwrite(mat2gray(Mean8),'.\result\median_filter.png');

%修正后的阿尔法滤波器
d = 5;
for i=2:1:img_H-1
    for j=2:1:img_W-1
        t=I_noise(i-1:i+1,j-1:j+1);
        t=sort(t(:));
        min_num=ceil(d/2);
        max_num=floor(d/2);
        s=sum(t(min_num:9-max_num));
        Mean9(i,j)= s/(3*3-d);
    end;
end;
subplot(3,4,11);
imshow(Mean9,[]);title('修正后的阿尔法滤波');
imwrite(mat2gray(Mean9),'.\result\modified_alpha_filter.png');


%自适应中值滤波器
Mean10 = I_noise;  
alreadyPro = false(size(I_noise)); %看是否完成进程
Smax=5;       %最大窗口尺寸
for s = 3:2:Smax    %起始窗口尺寸设为3
   %得到特定的灰度值
   zmin = ordfilt2(I_noise, 1, ones(s, s), 'symmetric');  
   zmax = ordfilt2(I_noise, s * s, ones(s, s), 'symmetric');  
   zmed = medfilt2(I_noise, [s s], 'symmetric');  
   %进程B
   processB = (zmed > zmin) & (zmax > zmed) & ~alreadyPro;   
   %进程A
   processA = (I_noise > zmin) & (zmax > I_noise);  
   outZxy  = processB & processA;  
   outZmed = processB & ~processA;  
   Mean10(outZxy) = I_noise(outZxy);  
   Mean10(outZmed) = zmed(outZmed);   
   alreadyPro = alreadyPro | processB;  
   if all(alreadyPro(:))  
      break;  
   end  
end  
Mean10(~alreadyPro) = zmed(~alreadyPro); 
subplot(3,4,12);
imshow(Mean10,[]);title('自适应中值滤波');
imwrite(mat2gray(Mean10),'.\result\adaptive_median_filter.png');
