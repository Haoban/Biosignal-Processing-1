signals = load('signals.mat');

abd_sig1 = signals.abd_sig1;
abd_sig2 = signals.abd_sig2;
abd_sig3 = signals.abd_sig3;
fhb = signals.fhb;
mhb = signals.mhb;
RespReference = signals.RespReference;
RRiInput = signals.RRiInput;

fs1=1000;
fs2=4;
%Taks 1
figure (1)
subplot(3,1,1)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
plot(x,mhb(1:10000,1));
xlabel('Sec');
ylabel('mV');
title('Mother chest signal for 10 sec');
% Case A
% Case A.2
%case_A=mhb+fhb; #which is equals to abd_sig1#
subplot(3,1,2)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
plot(x,abd_sig1(1:10000,1));
xlabel('Sec');
ylabel('mV');
title('Abdomen signal for 10 sec');
% Case A.3.1
Energy = 186;
LMS= dsp.LMSFilter('Method','LMS','Length',1,'StepSize',0.4/Energy);
[y1,e1]=LMS(mhb,abd_sig1);
subplot(3,1,3)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
%plot(x',e1(1:10000,1),'color','r');
hold on
plot(x',y1(1:10000,1),'color','r');
plot(x',fhb(1:10000,1),'color','b');
xlabel('Sec');
ylabel('mV');
title('Estimate Fetus signal for 10 sec');
hold off;
% Case A.3.2
A = corrcoef(e1(2000:20000),fhb(2000:20000));
MSE = immse(e1(2000:20000),fhb(2000:20000));
% Case B
% Case B.4.1
figure (2)
subplot(3,1,1)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
plot(x,mhb(1:10000,1));
xlabel('Sec');
ylabel('mV');
title('Mother chest signal for 10 sec');
% Case B.4.2
%case_B=mhb+fhb; #which is equals to abd_sig2#
subplot(3,1,2)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
plot(x,abd_sig2(1:10000,1));
xlabel('Sec');
ylabel('mV');
title('Abdomen signal for 10 sec');
% Case B.5.1
Energy = 186;
LMS= dsp.LMSFilter('Method','LMS','Length',1,'StepSize',0.59/Energy);
[y2,e2]=LMS(mhb,abd_sig2);
subplot(3,1,3)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
plot(x',e2(1:10000,1),'color','r');
hold on
%plot(x',y2(1:10000,1),'color','k');
plot(x',fhb(1:10000,1),'color','b');
xlabel('Sec');
ylabel('mV');
title('Estimate Fetus signal for 10 sec');
hold off;
% Case B.5.2
A2 = corrcoef(e2(2000:20000),fhb(2000:20000));
MSE2 = immse(e2(2000:20000),fhb(2000:20000));
% Case C
% Case C.6.1
figure (3)
subplot(3,1,1)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
plot(x,mhb(1:10000,1));
xlabel('Sec');
ylabel('mV');
title('Mother chest signal for 10 sec');
% Case C.6.2
%case_C=mhb+fhb; #which is equals to abd_sig3#
subplot(3,1,2)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
plot(x,abd_sig3(1:10000,1));
xlabel('Sec');
ylabel('mV');
title('Abdomen signal for 10 sec');
% Case C.7.1
Energy = 186;
LMS= dsp.LMSFilter('Method','LMS','Length',21,'StepSize',1/Energy);
[y3,e3]=LMS(mhb,abd_sig3);
subplot(3,1,3)
x=linspace(0.0,10.0,10001);
x=x(1,2:10001);
plot(x',e3(1:10000,1),'color','r');
hold on
%plot(x',y3(1:10000,1),'color','k');
plot(x',fhb(1:10000,1),'color','b');
xlabel('Sec');
ylabel('mV');
title('Estimate Fetus signal for 10 sec');
hold off;
% Case C.7.2
A3 = corrcoef(e3(2000:20000),fhb(2000:20000));
MSE3 = immse(e3(2000:20000),fhb(2000:20000));
% Case D
% Case D.8
figure (4)
subplot(3,1,1)
x=linspace(0,399,1596);
plot(x,RRiInput)
xlabel('Sec');
ylabel('mV');
title('R to R interval ECG signal');
subplot(3,1,2)
x=linspace(0,399,1596);
plot(x,RespReference);
xlabel('Sec');
ylabel('mV');
title('Real Respiration Movement');
% Case D.9.1
Energy2 = 93;
LMS= dsp.LMSFilter('Method','LMS','Length',1,'StepSize',1/Energy2);
[y4,e4]=LMS(RespReference,RRiInput);
subplot(3,1,3)
x=linspace(0,399,1596);
plot(x,RespReference,'color','b');
hold on
plot(x',y4,'color','r');
%plot(x',e4,'color','k');
xlabel('Sec');
ylabel('mV');
title('Respitatory movement and estimated respiratory component');
hold off;
% Case C.9.2
A4 = corrcoef(y4(101:1596),RespReference(101:1596));
MSE4 = immse(y4(101:1596),RespReference(101:1596));










