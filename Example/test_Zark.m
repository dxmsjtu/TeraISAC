clear all; close all;

% 用此程序产生 Fig. 1.12
close all
clear all
pt = 1.5e+6;   % 峰值功率in W
freq = 5.6e+9; %峰值功率in W
g = 45.0;      % 天线增益in dB
sigma = 0.1;   % 雷达截面积 in m squared
te = 290.0;    % 有效噪声温度 in Kelvins
b = 5.0e+6;    % 雷达工作带宽in Hz
nf = 3.0;      %噪声系数 in dB
loss = 6.0;    % 雷达损失in dB
range = linspace(25e3,165e3,1000); % 雷达目标距离 from 25 Km 165 Km, 1000 points
snr1 = radar_eq(pt, freq, g, sigma, te, b, nf, loss, range);
snr2 = radar_eq(pt, freq, g, sigma/10, te, b, nf, loss, range);
snr3 = radar_eq(pt, freq, g, sigma*10, te, b, nf, loss, range);
% 画出输出信噪比随目标距离的变化
figure(1)
rangekm  = range ./ 1000;
plot(rangekm,snr3,'k',rangekm,snr1,'k -.',rangekm,snr2,'k:')
grid
legend('\sigma = 0 dBsm','\sigma = -10dBsm','\sigma = -20 dBsm')
xlabel ('目标距离- Km');
ylabel ('SNR - dB');
snr1 = radar_eq(pt, freq, g, sigma, te, b, nf, loss, range);
snr2 = radar_eq(pt*0.4, freq, g, sigma, te, b, nf, loss, range);
snr3 = radar_eq(pt*1.8, freq, g, sigma, te, b, nf, loss, range);
figure (2)
plot(rangekm,snr3,'k',rangekm,snr1,'k -.',rangekm,snr2,'k:')
grid
legend('Pt = 2.7 MW','Pt = 1.5 MW','Pt = 0.6 MW')
xlabel ('Detection range - Km');
ylabel ('SNR - dB');

maxR = 200;           % 雷达最大探测目标的距离
rangeRes = 1;         % 雷达的距离分率
maxV = 70;            % 雷达最大检测目标的速度
fc= 77e9;             % 雷达工作频率 载频
c = 3e8;              % 光速

r0 = 90; % 目标距离设置 (max = 200m)
v0 = 10; % 目标速度设置 (min =-70m/s, max=70m/s)

B = c / (2*rangeRes);       % 发射信号带宽 (y-axis)  B = 150MHz
Tchirp = 5.5 * 2 * maxR/c;  % 扫频时间 (x-axis), 5.5= sweep time should be at least 5 o 6 times the round trip time
endle_time=6.3e-6;          %空闲时间
slope = B / Tchirp;         %调频斜率
f_IFmax= (slope*2*maxR)/c ; %最高中频频率
f_IF=(slope*2*r0)/c ;       %当前中频频率

Nd=128;          %chirp数量           
Nr=1024;         %ADC采样点数
vres=(c/fc)/(2*Nd*(Tchirp+endle_time));%速度分辨率
Fs=Nr/Tchirp;                 %模拟信号采样频率
t=linspace(0,Nd*Tchirp,Nr*Nd); %发射信号和接收信号的采样时间

Tx=zeros(1,length(t)); %发射信号
Rx=zeros(1,length(t)); %接收信号
Mix = zeros(1,length(t)); %差频、差拍、拍频、中频信号


% 生成时域信号
fs = 250 ;          % 采样频率
t = 0:1/fs:1;        % 时间范围从 0 到 1 秒
x = cos(2 * pi * 50 * t) + cos(2 * pi * 150 * t);  % 生成包含两个频率分量的信号

% 计算 Zak 变换
X = zakTransform(x, fs);

% 绘制原始信号
figure;
subplot(2, 1, 1);
plot(t, x);
title('原始时域信号');
xlabel('时间 (秒)');
ylabel('幅度');

% 绘制 Zak 变换结果
subplot(2, 1, 2);
imagesc(1:length(t), 1:length(t), abs(X));
title('Zak 变换');
xlabel('时域参数');
ylabel('频率参数');
colorbar;

% 显示图形
colormap('jet');
