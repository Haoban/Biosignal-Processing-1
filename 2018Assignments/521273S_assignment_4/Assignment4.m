ECG = load('ECG.txt');
fs = 200;
N = 30;
t = (0:length(ECG)-1)/fs;
% ==== Subtracting one sample from the original ECG signal ==== %

ECG_1 = ECG-ECG(1,1);

figure(1);

% ==== Plotting the original ECG ==== %
subplot(6,1,1);             
plot(t,ECG);
xlabel('second');
ylabel('Volts');
title('Input ECG Signal')

% ==== Low Pass Filter  H(z) = 1/32*((1 - z^(-6))^2)/(1 - z^(-1))^2 ==== %
delay_low = 5;
b = [1 0 0 0 0 0 -2 0 0 0 0 0 1];
a = [1 -2 1]*32;
%transfer_low = filter(b,a,[1,zeros(1,12)]);
%ECG_low = conv(ECG_1,transfer_low);
ECG_low = filter(b,a,ECG_1);
%ECG_low = ECG_low (delay_low+(1: N));

% ==== Plotting the low pass filter ==== %
subplot(6,1,2);
%plot((0:length(ECG_low)-1)/fs,ECG_low)
plot(t,ECG_low);
xlabel('second');
ylabel('Volts');
title('ECG Signal after Low Pass Filter')

% ==== High Pass filter (All pass filter - Low pass filter) H(z) = (-1+32z^(-16)+z^(-32))/(1+z^(-1)) ==== %
delay_high = 16;
%16 is not accepted?
b_h = [-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 -32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
a_h = [1 -1]*32;
%transfer_high = filter(b_h,a_h,[1,zeros(1,32)]);
%ECG_high = conv(ECG_low,transfer_low);
ECG_high = filter(b_h,a_h,ECG_low); 
%ECG_high = ECG_high (delay_high+(1: N));
 


% ==== Plotting the high pass filter ==== %
subplot(6,1,3);
%plot((0:length(ECG_high)-1)/fs,ECG_high)
plot(t,ECG_high);
xlabel('second');
ylabel('Volts');
title('ECG Signal after High Pass Filter')


% ==== Derivative operator H(z) = (1/8)(-z^(-2) - 2z^(-1) + 2z + z^(2))==== %
b_der = [1 2 0 -2 -1].*(1/8);
a_der = 1;
ECG_Der = filter(b_der,a_der,ECG_high);
%ECG_Der = conv (ECG_high,b_der);

% ==== Plotting Derivative filter ==== %
subplot(6,1,4);
%plot(t,ECG_Der);
plot(t,ECG_Der);
xlabel('second');
ylabel('Volts');
title('ECG Signal after Derivative Filter')

% ==== Squaring operation ==== %
ECG_sqr = (ECG_Der).^2;

% ==== Plotting Squaring Operation ==== %
subplot(6,1,5);
plot(t,ECG_sqr);
xlabel('second');
ylabel('Volts');
title('ECG Signal after squaring operation')

% ==== Moving Window Integration ==== %
b_int = ones(1,30);
a_int = 30;
ECG_int = filter(b_int,a_int,ECG_sqr);


% ==== Plotting Moving Window Integration ==== %
subplot(6,1,5)
plot(t,ECG_int)
xlabel('second');
ylabel('Volts');
title(' ECG Signal filter Averaging')

% ==== QRS Complex ==== %
[QRSStart,QRSEnd] = findQRS(ECG_int,40,104,16);
%subplot(6,1,5);
hold on 
plot(t(QRSStart),ECG_int(QRSStart),'r*');
hold on
plot(QRSEnd/200,ECG_int(QRSEnd),'ro');
xlabel('Second');
ylabel('Volts');
title('QRS Output');
hold off

% ==== Plotting the original ECG ==== %
subplot(6,1,6);             
plot(t,ECG);
xlabel('second');
ylabel('Volts');
title('Input ECG Signal');


% ==== QRS Complex with delay ==== %
%subplot(6,1,6)
delay = 5+16;
hold on
plot((QRSStart-delay)/200,ECG(QRSStart-delay),'r*');
hold on
plot((QRSEnd-delay)/200,ECG(QRSEnd-delay),'ro');
hold off




