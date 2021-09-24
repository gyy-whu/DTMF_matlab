folder='D:\wav1\'; %从文件夹中读取wav录音文件
files=dir([folder '*.wav']);    
file=[folder files(1).name];    
try
     [y,Fs]=audioread(file); %对文件采样  
     res.y=y;       
     res.Fs=Fs;      
    catch
        warning('No suppot for the format.')
end
audioinfo(file) %显示文件信息
info=audioinfo(file);
sound(res.y,res.Fs) %发音

A.y=mean(res.y,2);    %对左右声道进行平均，合成单声道
A.y=detrend(A.y);    %去基线，即去直流分量
figure(1)    %若要单独输出多个图形，用figure函数
%t=length(y)/Fs;
t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end-1);
plot(t,A.y)    %注意结构数组的数据调用，在workspace里可以理清其结构
xlabel('t')
ylabel('A')


T=zeros(11:1); %矩阵预分配内存
TJ=zeros(2:1); %矩阵预分配内存
m=1;
k=10000;
total=(info.TotalSamples)/36;
for i=1:info.TotalSamples
    if(A.y(i)>0.015&& m<=11 && k<=10000)%避免微小噪声干扰
        T(m)=i;
       m=m+1;
        k=k+total*2;
    end
    if(k>10000) %延时0.3秒，防止重复采样
        k=k-1;
    end 
end

Num=zeros(11:1); %矩阵预分配内存
PhoneNum=zeros(11:1); %矩阵预分配内存
PhoneNum(1)=0;PhoneNum(2)=0;PhoneNum(3)=0;PhoneNum(4)=0;PhoneNum(5)=0;
PhoneNum(6)=0;PhoneNum(7)=0;PhoneNum(8)=0;PhoneNum(9)=0;PhoneNum(10)=0;PhoneNum(11)=0;
figure(3)    %这一段是画短时傅里叶变换频谱图的通用程序
for count=1:11
y_new= A.y((T(count):T(count)+10640));
fs=Fs;N=length(y_new); %numh
n=0:N-1;t=n/fs;
x=y_new; %numh
y1=fft(x,N);
mag=abs(y1);
f=n*fs/N;
subplot(4,3,count),plot(f,mag);
disp(count)
xlim([650,1500])
xlabel('Frenquency/Hz');
ylabel('Amp');grid on;
magmax1=mag(650);
magmax2=mag(1100);
for i=162:250
    if(mag(i)>magmax1)
        magmax1=mag(i);
        Fmagmax1=i;
    end
end
for i=275:375
    if(mag(i)>magmax2)
        magmax2=mag(i);
        Fmagmax2=i;
    end
end
F1=4*Fmagmax1;
F2=4*Fmagmax2;
if(F1>661 && F1<733)
    if(F2>1146 && F2<1272)
        Num(count)=1;
    end
    if(F2>1273 && F2<1406)
        Num(count)=2;
    end   
    if(F2>1407 && F2<1555)
        Num(count)=3;
    end
end
if(F1>734 && F1<811)
    if(F2>1146 && F2<1272)
        Num(count)=4;
    end
    if(F2>1273 && F2<1406)
        Num(count)=5;
    end   
    if(F2>1407 && F2<1555)
        Num(count)=6;
    end
end
if(F1>812 && F1<896)
    if(F2>1146 && F2<1272)
        Num(count)=7;
    end
    if(F2>1273 && F2<1406)
        Num(count)=8;
    end   
    if(F2>1407 && F2<1555)
        Num(count)=9;
    end
end
if(F1>897 && F1<987)
    if(F2>1273 && F2<1406)
        Num(count)=0;
    end   
end
a=num2str(Num(count));
PhoneNum(count)=a-48;
end 
b=[PhoneNum(1),PhoneNum(2),PhoneNum(3),PhoneNum(4),PhoneNum(5),PhoneNum(6),PhoneNum(7),PhoneNum(8),PhoneNum(9),PhoneNum(10),PhoneNum(11)];
disp('电话号码是：')
disp(b)

for i=1:info.TotalSamples
    if((0<A.y(i)&&A.y(i)<0.015)||(A.y(i)>-0.015&&A.y(i)<0))
        A.y(i)=0;
    end
    if(i>(T(1)+10640)&&i<T(2))
        A.y(i)=0;
    end
    if(i<T(3)&&i>(T(2)+10640))
        A.y(i)=0;
    end
    if(i<T(4)&&i>(T(3)+10640))
        A.y(i)=0;
    end
    if(i<T(5)&&i>(T(4)+10640))
        A.y(i)=0;
    end
    if(i<T(6)&&i>(T(5)+10640))
        A.y(i)=0;
    end
    if(i<T(7)&&i>(T(6)+10640))
        A.y(i)=0;
    end
    if(i<T(8)&&i>(T(7)+10640))
        A.y(i)=0;
    end
    if(i<T(9)&&i>(T(8)+10640))
        A.y(i)=0;
    end
    if(i<T(10)&&i>(T(9)+10640))
        A.y(i)=0;
    end
    if(i<T(11)&&i>(T(10)+10640))
        A.y(i)=0;
    end
    A.y(i)=A.y(i)*10;
end

figure(4)
plot(A.y);
xlabel('t')
ylabel('A')
A.y=downsample(A.y,10); 
fs1=Fs/10;
figure(5)
spectrogram(A.y,1024,1020,1024,fs1);    %画出时频分布图，注意spectrogram函数的参数
xlim([0.6,1.6])