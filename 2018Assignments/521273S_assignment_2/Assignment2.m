ecg_signal_1 = load('ecg_signal_1.dat');
ecg_signal_2 = load('ecg_signal_2.dat');

fs=1000;

%Task 1
figure (1)
%Task 1.1 full signal
subplot(5,2,1); 
plot(ecg_signal_1);
xlabel('Sec');
ylabel('mV');
title('Ecg signal 1 over full duration');
subplot(5,2,2);
x=linspace(1,2,1001);
plot(x',ecg_signal_1(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('Ecg signal 1 over one cardiac cycle');
%Task 1.2 power spectra
Nfft=2^nextpow2(length(ecg_signal_1));
%f=(0:(Nfft/2))*fs/Nfft;
f=fs/2*linspace(0,1,Nfft/2+1);
Y=fft(ecg_signal_1,Nfft);
power_spectra1=(Y.*conj(Y)/Nfft);
figure (2)
subplot(5,1,1);
semilogy(f',power_spectra1(1:length(f)));
xlabel('Sec');
ylabel('AU');
title('power spectra over half duration');
%Task 2 10-point moving average filter
figure (1)
%a= 1.*ones(1,10);
a=1;
b= 1/10.*ones(1,10);
point_filter = filter(b,a,ecg_signal_1);
%Task 2.1
subplot(5,2,3);
plot(point_filter);
xlabel('Sec');
ylabel('mV');
title('10-point filter over full duration');
subplot(5,2,4);
x=linspace(1,2,1001);
plot(x',point_filter(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('10-point filter over one cardiac cycle');
%Task 2.2
figure (2);
Nfft_point=2^nextpow2(length(point_filter));
P=fft(point_filter,Nfft_point);
power_spectra2=(P.*conj(P)/Nfft_point);
subplot(5,1,2);
semilogy(f',power_spectra2(1:length(f)));
xlabel('Sec');
ylabel('AU');
title('Power spectra of 10-point filter over half duration');
%Task2.3 Magnitute
figure (5)
freqz(b,a,[],fs);
%Task 3 Dervative based filter
figure (1);
a_der=[1,-0.995];
b_der=fs*[1,-1];
der_filter=filter(b_der,a_der,ecg_signal_1);
Nfft_der=2^nextpow2(length(der_filter));
D=fft(der_filter,Nfft_der);
power_spectra3=(D.*conj(D)/Nfft_der);
%Task 3.1
subplot(5,2,5);
plot(der_filter);
xlabel('Sec');
ylabel('mV');
title('Derivative based filter over one full duration');
subplot(5,2,6);
x=linspace(1,2,1001);
plot(x',der_filter(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('Derivative based filter over one cardiac cycle');
%Task 3.2
figure (2);
subplot(5,1,3);
semilogy(f',power_spectra3(1:length(f)));
xlabel('Sec');
ylabel('AU');
title('Power spectra of derivative based filter over half duration');
%Task3.3 Magnitute
figure (6)
freqz(b_der,a_der,[],fs);
%Task 4 Comb filter
b_comb=[0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310];
a_comb=1;
comb_filter=filter(b_comb,a_comb,ecg_signal_1);
Nfft_comb=2^nextpow2(length(comb_filter));
C=fft(comb_filter,Nfft_comb);
power_spectra4=(C.*conj(C)/Nfft_comb);
%Task 4.1
figure (1);
subplot(5,2,7);
plot(comb_filter);
xlabel('Sec');
ylabel('mV');
title('Comb filter over one full duration');
subplot(5,2,8);
x=linspace(1,2,1001);
plot(x',comb_filter(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('Comb filter over one cardiac cycle');
%Task 4.2
figure (2);
subplot(5,1,4);
semilogy(f',power_spectra4(1:length(f)));
xlabel('Sec');
ylabel('AU');
title('Power spectra of comb filter over half duration');
%Task4.3 Magnitute
figure (7)
freqz(b_comb,a_comb,[],fs);
%Task 5 use all 3 filters 
a_conv=conv(a,a_der);
a_conv=conv(a_conv,a_comb);
b_conv=conv(b,b_der);
b_conv=conv(b_conv,b_comb);
conv_filter=filter(b_conv,a_conv,ecg_signal_1);
Nfft_conv=2^nextpow2(length(conv_filter));
CO=fft(conv_filter,Nfft_conv);
power_spectra5=(CO.*conj(CO)/Nfft_conv);
%Task 5.1
figure (1);
subplot(5,2,9);
plot(conv_filter);
xlabel('Sec');
ylabel('mV');
title('3 filter over one full duration');
subplot(5,2,10);
x=linspace(1,2,1001);
plot(x',conv_filter(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('3 filter over one cardiac cycle');
%Task 5.2
figure (2);
subplot(5,1,5);
semilogy(f',power_spectra5(1:length(f)));
xlabel('Sec');
ylabel('AU');
title('Power spectra of 3 filter over half duration');
%Task5.3 Magnitute
figure (8)
freqz(b_conv,a_conv,[],fs);
%
%
%
%Task 6 Repeat everything to ecg signal 2
%Task 6.1
figure (3)
%Task 6.1.1 full signal
subplot(5,2,1); 
plot(ecg_signal_2);
xlabel('Sec');
ylabel('mV');
title('Ecg signal 2 over full duration');
subplot(5,2,2);
x=linspace(1,2,1001);
plot(x',ecg_signal_2(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('Ecg signal 2 over one cardiac cycle');
%Task 6.1.2 power spectra
Nfft2=2^nextpow2(length(ecg_signal_2));
%f=(0:(Nfft2/2))*fs/Nfft2;
f2=fs/2*linspace(0,1,Nfft2/2+1);
Y2=fft(ecg_signal_2,Nfft2);
power_spectra1_2=(Y2.*conj(Y2)/Nfft2);
figure (4)
subplot(5,1,1);
semilogy(f2',power_spectra1_2(1:length(f2)));
xlabel('Sec');
ylabel('AU');
title('power spectra over half duration');
%Task 2 10-point moving average filter
figure (3)
%a2= 1.*ones(1,10);
a2=1;
b2= 1/10.*ones(1,10);
point_filter2 = filter(b2,a2,ecg_signal_2);
%Task 6.2.1
subplot(5,2,3);
plot(point_filter2);
xlabel('Sec');
ylabel('mV');
title('10-point filter over full duration');
subplot(5,2,4);
x=linspace(1,2,1001);
plot(x',point_filter2(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('10-point filter over one cardiac cycle');
%Task 6.2.2
figure (4);
Nfft_point2=2^nextpow2(length(point_filter2));
P2=fft(point_filter2,Nfft_point2);
power_spectra2_2=(P2.*conj(P2)/Nfft_point2);
subplot(5,1,2);
semilogy(f2',power_spectra2_2(1:length(f2)));
xlabel('Sec');
ylabel('AU');
title('Power spectra of 10-point filter over half duration');
%Task 6.2.3 Magnitute
figure (9)
freqz(b2,a2,[],fs);
%Task 6.3 Dervative based filter
figure (3);
a_der2=[1,-0.995];
b_der2=fs*[1,-1];
der_filter2=filter(b_der2,a_der2,ecg_signal_2);
Nfft_der2=2^nextpow2(length(der_filter2));
D2=fft(der_filter2,Nfft_der2);
power_spectra3_2=(D2.*conj(D2)/Nfft_der2);
%Task 6.3.1
subplot(5,2,5);
plot(der_filter2);
xlabel('Sec');
ylabel('mV');
title('Derivative based filter over one full duration');
subplot(5,2,6);
x=linspace(1,2,1001);
plot(x',der_filter2(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('Derivative based filter over one cardiac cycle');
%Task 6.3.2
figure (4);
subplot(5,1,3);
semilogy(f2',power_spectra3_2(1:length(f2)));
xlabel('Sec');
ylabel('AU');
title('Power spectra of derivative based filter over half duration');
%Task 6.3.3 Magnitute
figure (10)
freqz(b_der2,a_der2,[],fs);
%Task 6.4 Comb filter
b_comb2=[0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310];
a_comb2=1;
comb_filter2=filter(b_comb2,a_comb2,ecg_signal_2);
Nfft_comb2=2^nextpow2(length(comb_filter2));
C2=fft(comb_filter2,Nfft_comb2);
power_spectra4_2=(C2.*conj(C2)/Nfft_comb2);
%Task 6.4.1
figure (3);
subplot(5,2,7);
plot(comb_filter2);
xlabel('Sec');
ylabel('mV');
title('Comb filter over one full duration');
subplot(5,2,8);
x=linspace(1,2,1001);
plot(x',comb_filter2(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('Comb filter over one cardiac cycle');
%Task 6.4.2
figure (4);
subplot(5,1,4);
semilogy(f2',power_spectra4_2(1:length(f2)));
xlabel('Sec');
ylabel('AU');
title('Power spectra of comb filter over half duration');
%Task 6.4.3 Magnitute
figure (11)
freqz(b_comb2,a_comb2,[],fs);
%Task 6.5 Use all 3 filters
a_conv2=conv(a2,a_der2);
a_conv2=conv(a_conv2,a_comb2);
b_conv2=conv(b2,b_der2);
b_conv2=conv(b_conv2,b_comb2);
conv_filter2=filter(b_conv2,a_conv2,ecg_signal_2);
Nfft_conv2=2^nextpow2(length(conv_filter2));
CO2=fft(conv_filter2,Nfft_conv2);
power_spectra5_2=(CO2.*conj(CO2)/Nfft_conv2);
%Task 6.5.1
figure (3);
subplot(5,2,9);
plot(conv_filter2);
xlabel('Sec');
ylabel('mV');
title('3 filter over one full duration');
subplot(5,2,10);
x=linspace(1,2,1001);
plot(x',conv_filter2(1000:2000,1));
xlabel('Sec');
ylabel('mV');
title('3 filter over one cardiac cycle');
%Task 6.5.2
figure (4);
subplot(5,1,5);
semilogy(f2',power_spectra5_2(1:length(f2)));
xlabel('Sec');
ylabel('AU');
title('Power spectra of 3 filter over half duration');
%Task 6.5.3 Magnitute
figure (12)
freqz(b_conv2,a_conv2,[],fs);








