folder='D:\wav\'; %���ļ����ж�ȡwav¼���ļ�
files=dir([folder '*.wav']);    
file=[folder files(1).name];    
try
     [y,Fs]=audioread(file); %���ļ�����  
     res.y=y;       
     res.Fs=Fs;      
    catch
        warning('No suppot for the format.')
end
audioinfo(file) %��ʾ�ļ���Ϣ
info=audioinfo(file);
sound(res.y,res.Fs) %����

A.y=mean(res.y,2);    %��������������ƽ�����ϳɵ�����
A.y=detrend(A.y);    %ȥ���ߣ���ȥֱ������
figure(1)    %��Ҫ����������ͼ�Σ���figure����
%t=length(y)/Fs;
t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end-1);
plot(t,A.y)    %ע��ṹ��������ݵ��ã���workspace�����������ṹ
xlabel('t')
ylabel('A')


T=zeros(24:1); %����Ԥ�����ڴ�
TJ=[0,0];
m=1;
k=4410;
j=0;n=0;
total=(info.TotalSamples)/48;
for i=1:info.TotalSamples
    if(A.y(i)>0.025&& m<=24&&n<=0)%����΢С��������
        if(j==0)
            TJ(1)=i;
        end
        j=j+1;
    end   
    if(j>0&&n<=0) 
        k=k-1;%ȡ��0.1��
        if(k==0)
            TJ(2)=i;
            rat=j/(TJ(2)-TJ(1));
            if(rat>=0.1)
                T(m)=i-4000;%ѡ�������
                m=m+1;
                n=total;%�ӳ�0.25s
            end
            j=0;k=4410;%��λ
        end
    end
    if(n>0)
        n=n-1;
    end
end

Num=zeros(20:1); %����Ԥ�����ڴ�
PhoneNum=zeros(20:1); %����Ԥ�����ڴ�
PhoneNum(1)=0;PhoneNum(2)=0;PhoneNum(3)=0;PhoneNum(4)=0;PhoneNum(5)=0;
PhoneNum(6)=0;PhoneNum(7)=0;PhoneNum(8)=0;PhoneNum(9)=0;PhoneNum(10)=0;PhoneNum(11)=0;
figure(3)    %��һ���ǻ���ʱ����Ҷ�任Ƶ��ͼ��ͨ�ó���
countw=0;
du=zeros(24:1);
for count=1:m-1
  du(count)=T(count)/48000;
y_new= A.y((T(count):T(count)+12000));
fs=Fs;N=length(y_new); %numh
n=0:N-1;t=n/fs;
x=y_new; %numh
y1=fft(x,N);
mag=abs(y1);
f=n*fs/N;
subplot(7,3,count),plot(f,mag);
disp(count)
xlim([650,1500])
xlabel('Frenquency/Hz');
ylabel('Amp');grid on;
magmax1=mag(650);
magmax2=mag(1100);
for i=170:250
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
if(F1>682 && F1<733)
    countw=countw+1;
    if(F2>1146 && F2<1272)
        Num(countw)=1;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end
    if(F2>1273 && F2<1406)
        Num(countw)=2;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end   
    if(F2>1407 && F2<1555)
        Num(countw)=3;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end
end
if(F1>734 && F1<811)
    countw=countw+1;
    if(F2>1146 && F2<1272)
        Num(countw)=4;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end
    if(F2>1273 && F2<1406)
        Num(countw)=5;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end   
    if(F2>1407 && F2<1555)
        Num(countw)=6;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end
end
if(F1>812 && F1<896)
        countw=countw+1;
    if(F2>1146 && F2<1272)
        Num(countw)=7;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end
    if(F2>1273 && F2<1406)
        Num(countw)=8;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end   
    if(F2>1407 && F2<1555)
        Num(countw)=9;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end
end
if(F1>897 && F1<987)
        countw=countw+1;
    if(F2>1273 && F2<1406)
        Num(countw)=0;
        a=num2str(Num(countw));
PhoneNum(countw)=a-48;
    end   
end
if((F1>600 && F1<661)||(F1>987 && F1<1200)||(F2>900 && F2<1146)||(F2>1555 && F2<1800))
end
end
b=[PhoneNum(1),PhoneNum(2),PhoneNum(3),PhoneNum(4),PhoneNum(5),PhoneNum(6),PhoneNum(7),PhoneNum(8),PhoneNum(9),PhoneNum(10),PhoneNum(11)];
disp('�绰�����ǣ�')
disp(b)


for i=1:info.TotalSamples
    if((0<A.y(i)&&A.y(i)<0.011)||(A.y(i)>-0.011&&A.y(i)<0))
        A.y(i)=0;
    end
    if(i>(T(1)+12000)&&i<T(2))
        A.y(i)=0;
    end
    if(i<T(3)&&i>(T(2)+12000))
        A.y(i)=0;
    end
    if(i<T(4)&&i>(T(3)+12000))
        A.y(i)=0;
    end
    if(i<T(5)&&i>(T(4)+12000))
        A.y(i)=0;
    end
    if(i<T(6)&&i>(T(5)+12000))
        A.y(i)=0;
    end
    if(i<T(7)&&i>(T(6)+12000))
        A.y(i)=0;
    end
    if(i<T(8)&&i>(T(7)+12000))
        A.y(i)=0;
    end
    if(i<T(9)&&i>(T(8)+12000))
        A.y(i)=0;
    end
    if(i<T(10)&&i>(T(9)+12000))
        A.y(i)=0;
    end
    if(i<T(11)&&i>(T(10)+12000))
        A.y(i)=0;
    end
    A.y(i)=A.y(i)*0.01;
end

figure(4)   
plot(A.y);
xlabel('t')
ylabel('A')
A.y=downsample(A.y,10); 
fs1=Fs/10;
figure(5)
spectrogram(A.y,1024,1020,1024,fs1);    %����ʱƵ�ֲ�ͼ��ע��spectrogram�����Ĳ���
xlim([0.60,1.6])