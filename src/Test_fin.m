clc
clear all
close all
% Loading the Bodyline tracking dataset
Dataset1 = load('D:/Nivya/code/BodyLine.mat');
% Loading the FinPoints tracking dataset
Dataset2 = load('D:/Nivya/code/FinPoints35.mat');

% fin5 - fin15 - an approximate full cycle - this is to get the wave
% features from the actual data
fin5 = Dataset2.fin5_x;
fin15 = Dataset2.fin15_x;
waveLength1 = zeros(length(fin5), 1);
for i = 1:length(fin15)
    waveLength1(i) = fin5(i) - fin15(i);
end
waveLength_avg1 = mean(waveLength1);

% fin16 - fin25 - by inspection is another approximate full cycle
fin16 = Dataset2.fin16_x;
fin25 = Dataset2.fin25_x;
waveLength2 = zeros(length(fin16), 1);
for i = 1:length(fin16)
    waveLength2(i) = fin16(i) - fin25(i);
end
waveLength_avg2 = mean(waveLength2);

% fin26 - fin34 - by inspection is another approximate full cycle
fin26 = Dataset2.fin26_x;
fin34 = Dataset2.fin34_x;
waveLength3 = zeros(length(fin26), 1);
for i = 1:length(fin26)
    waveLength3(i) = fin26(i) - fin34(i);
end
waveLength_avg3 = mean(waveLength3);

% Calculating the bodylength in pixels - was used to make the pixel to cm
% conversion
body1 = [Dataset1.b1_x, Dataset1.b1_y];
body35 = [Dataset1.b35_x, Dataset1.b35_y];
norm_body = zeros(length(body35), 1);
for i = 1:length(body35)
    norm_body(i) = norm(body1(i, :)'- body35(i, :)');
end
BodyLength_pix = mean(norm_body);

diff = abs(Dataset2.fin1_y - Dataset1.fin1_y);
difference = mean(diff);

% Found that the length of the fish is 4.5cm to 4.8cm - taking 4.65cm. The
% shuttle length is 6cm. Based on the pixels the conversation factor was
% calculated
conv_factor = 95.48;
BodyLength = BodyLength_pix/conv_factor; %body length in cm
fprintf('The body length obtained from the data is:\n')
BodyLength
Lambda_pix = min([waveLength_avg1, waveLength_avg2 ,waveLength_avg3]); % wavelength in pixels 
% Computing the wavelength obtained from the data
Lambda = Lambda_pix/conv_factor;
fprintf('The wave length obtained from the data is:\n')
Lambda
TimePeriod_pix = mean([waveLength_avg1, waveLength_avg2 ,waveLength_avg3]);
TimePeriod = TimePeriod_pix/conv_factor;
fprintf('The time period obtained from the data is:\n')
TimePeriod
freq = 1/TimePeriod;
m1 = max(Dataset1.b1_y);
m2 = min(Dataset1.b1_y);
Amplitude = abs(m1 - m2)/conv_factor;
fprintf('The amplitude obtained from the data is:\n')
Amplitude

% For graphs
fin_x = makefinData_x(Dataset2);
fin_y = makefinData_y(Dataset2);
body_x = makebodyData_x(Dataset1);
body_y = makebodyData_y(Dataset1);

% t_test = linspace(fin_x(1, 1)/conv_factor, fin_x(1, 34)/conv_factor, length(fin_x(1, :)));
% y_test = zeros(size(t_test));
% for i = 1:length(fin_x(15, :))
%     y_test(i) = Amplitude*sin(2*pi*(freq*t_test(i)) + (fin_x(15, i)/(conv_factor*Lambda)));
% end
% Testing 

% Cubic spline approximations
fin_x1_cm = fin_x(1, :)/conv_factor;
fin_y1_cm = fin_y(1, :)/conv_factor;
[cs_fin1, xx_fin1] = SplineArg(fin_x1_cm, fin_y1_cm);
fin_x10_cm = fin_x(10, :)/conv_factor;
fin_y10_cm = fin_y(10, :)/conv_factor;
[cs_fin10, xx_fin10] = SplineArg(fin_x10_cm, fin_y10_cm);
fin_x20_cm = fin_x(20, :)/conv_factor;
fin_y20_cm = fin_y(20, :)/conv_factor;
[cs_fin20, xx_fin20] = SplineArg(fin_x20_cm, fin_y20_cm);
fin_x30_cm = fin_x(30, :)/conv_factor;
fin_y30_cm = fin_y(30, :)/conv_factor;
[cs_fin30, xx_fin30] = SplineArg(fin_x30_cm, fin_y30_cm);

avg_finx = (GetAvg(fin_x)/conv_factor)';
avg_finy = (GetAvg(fin_y)/conv_factor)';
[cs_avg_fin, xx_avg_fin] = SplineArg(avg_finx, avg_finy);
avg_bodyx = (GetAvg(body_x)/conv_factor)';
avg_bodyy = (GetAvg(body_y)/conv_factor)';
[cs_avg_body, xx_avg_body] = SplineArg(avg_bodyx, avg_bodyy);

body_x1_cm = body_x(1, :)/conv_factor;
body_y1_cm = body_y(1, :)/conv_factor;
[cs_body1, xx_body1] = SplineArg(body_x1_cm, body_y1_cm);
body_x10_cm = body_x(10, :)/conv_factor;
body_y10_cm = body_y(10, :)/conv_factor;
[cs_body10, xx_body10] = SplineArg(body_x10_cm, body_y10_cm);
body_x20_cm = body_x(20, :)/conv_factor;
body_y20_cm = body_y(20, :)/conv_factor;
[cs_body20, xx_body20] = SplineArg(body_x20_cm, body_y20_cm);
body_x30_cm = body_x(30, :)/conv_factor;
body_y30_cm = body_y(30, :)/conv_factor;
[cs_body30, xx_body30] = SplineArg(body_x30_cm, body_y30_cm);

% Computing PCA Raw data
PCA_rawData = fin_y;
[coeff,score,latent] = pca(PCA_rawData);
% Each column of score corresponds to one principal component

% Reconstructing the centered fin data
Xcentered = score*coeff';

% Plotting the data
figure(1)
h1 = plot(avg_finx,avg_finy,'o',xx_avg_fin,ppval(cs_avg_fin,xx_avg_fin),'k', 'LineWidth',1.5);
dy_body10 = gradient(body_y10_cm);
dx_body10 = gradient(body_x10_cm);
%h = quiver(body_x10_cm,body_y10_cm,-dy_body10,dx_body10);
%set(h,'AutoScale','on', 'AutoScaleFactor', 0.5)
hold on; 
h2 = plot(avg_bodyx,avg_bodyy,'o',xx_avg_body,ppval(cs_avg_body,xx_avg_body),'k', 'LineWidth',1.5);
plot(body_x10_cm,body_y10_cm,'o',xx_body10,ppval(cs_body10,xx_body10),'--g', 'LineWidth',1.5);
plot(body_x20_cm,body_y20_cm,'o',xx_body20,ppval(cs_body20,xx_body20),'--b', 'LineWidth',1.5);
plot(body_x30_cm,body_y30_cm,'o',xx_body30,ppval(cs_body30,xx_body30),'--c', 'LineWidth',1.5);

plot(fin_x10_cm,fin_y10_cm,'o',xx_fin10,ppval(cs_fin10,xx_fin10),'--g','LineWidth',1.5);
plot(fin_x20_cm,fin_y20_cm,'o',xx_fin20,ppval(cs_fin20,xx_fin20),'--b', 'LineWidth',1.5);
plot(fin_x30_cm,fin_y30_cm,'o',xx_fin30,ppval(cs_fin30,xx_fin30),'--c', 'LineWidth',1.5);
h = [h1; h2];
legend(h, 'fin spline points','average fin','body line spline points', 'average body line')
title('Testing the fin and body line data for different frames')
xlabel('x-coordinate (cm)')
ylabel('y-coordinate (cm)')
grid on

figure(2)
q1= plot(fin_x20_cm,fin_y20_cm,'o',xx_fin20,ppval(cs_fin20,xx_fin20),'--k', 'LineWidth',1.5);
hold on
q2=plot(fin_x30_cm,fin_y30_cm,'o',xx_fin30,ppval(cs_fin30,xx_fin30),'--r', 'LineWidth',1.5);
legend(h, 'fin spline points','average fin','body line spline points', 'average body line')
title('Checking if nodal point is visible: not mean-centered data')
xlabel('x-coordinate (cm)')
ylabel('y-coordinate (cm)')
grid on

