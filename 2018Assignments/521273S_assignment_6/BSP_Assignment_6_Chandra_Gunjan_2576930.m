data6 = load('data6.mat');
data = data6.data;
cycles = data6.cycles;
% ==== Plotting the ECG and PCG ==== %

for i = 1:5
    figure(i);
    subplot(2,1,1);
    plot(data(i).t,data(i).ECG)
    xlabel('Time (Seconds)');
    ylabel('mV');
    title('ECG signal')
    subplot(2,1,2);
    plot(data(i).t,data(i).PCG)
    xlabel('Time (Seconds)');
    ylabel('mV');
    title('PCG signal')
end
hold on


for i = 6:10
    figure(i);
    subplot(3,1,1);
    plot(cycles(i-5).t,cycles(i-5).ECG)
    xlabel('Time (Seconds)');
    ylabel('mV');
    title('ECG signal for 2 cycles')
    subplot(3,1,2);
    plot(cycles(i-5).t,cycles(i-5).PCG)
    xlabel('Time (Seconds)');
    ylabel('mV');
    title('PCG signal for 2 cycles')
    subplot(3,1,3);
    spectrogram(cycles(i-5).PCG,50,45,[],'MinThreshold',-30,'yaxis')
end

% ==== resample ==== %
for i = 1:5
    R_data(i).ECG = resample(data(i).ECG,1,5);
    R_data(i).ECG = R_data(i).ECG-R_data(i).ECG(1,1);
end
% ==== Low Pass Filter  H(z) = 1/32*((1 - z^(-6))^2)/(1 - z^(-1))^2 ==== %
b = [1 0 0 0 0 0 -2 0 0 0 0 0 1];
a = [1 -2 1]*32;
for i = 1:5
    R_data(i).ECG = filter(b,a,R_data(i).ECG);
end
% ==== High Pass filter (All pass filter - Low pass filter) H(z) = (-1+32z^(-16)+z^(-32))/(1+z^(-1)) ==== %
b_h = [-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 -32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
a_h = [1 -1]*32;
for i = 1:5
    R_data(i).ECG = filter(b_h,a_h,R_data(i).ECG);
end
% ==== Derivative operator H(z) = (1/8)(-z^(-2) - 2z^(-1) + 2z + z^(2))==== %
b_der = [1 2 0 -2 -1].*(1/8);
a_der = 1;
for i = 1:5
    R_data(i).ECG = filter(b_der,a_der,R_data(i).ECG);
end
% ==== Squaring operation ==== %
for i = 1:5
    R_data(i).ECG = (R_data(i).ECG).^2;
end
% ==== Moving Window Integration ==== %
b_int = ones(1,30);
a_int = 30;
for i = 1:5
    R_data(i).ECG = filter(b_int,a_int,R_data(i).ECG);
end
% ==== Peak detection ==== %
for i = 1:5
    [peakOnsets,peakOffsets]=detectPeaks(R_data(i).ECG);
    peakOnset(i).start = peakOnsets*5;
    peakOffset(i).end = peakOnsets*5+330;
    figure(i)
    subplot(2,1,2)
    hold on
    %plot(data(i).t(peakOnsets*5),data(i).PCG(peakOnsets*5),'r*');
    plot(data(i).t(peakOnsets*5),0,'r*');
    hold on
    plot(data(i).t((peakOnsets*5)+330),0,'ro');
   
end
% ==== Segment the systolic parts of the PCG signals ==== %

figure
for i = 1:5
    subplot(5,3,1+3*(i-1));
    plot(data(i).t(1,peakOnset(i).start(1):peakOffset(i).end(1)),data(i).PCG(peakOnset(i).start(1):peakOffset(i).end(1)));
    subplot(5,3,2+3*(i-1));
    [PSD,f] = pwelch(data(i).PCG(peakOnset(i).start(1):peakOffset(i).end(1)),[],[],[],1000);
    PSDD(i).p = PSD;
    fF(i).f = f;
    plot(fF(i).f,(PSDD(i).p))
    xlabel('Frequency (Hz)')
    ylabel('PSD (dB/Hz)')
    MeanF(i) = meanfreq(PSDD(i).p,fF(i).f);
end 
subplot(5,3,3);
for aa = 1:length(peakOnset(1).start)
    [PSDa,fa] = pwelch(data(1).PCG(peakOnset(1).start(aa):peakOffset(1).end(aa)),[],[],[],1000);
    PSDDa(:,aa) = PSDa;
    Average_PSD1 = mean(PSDDa,2);
end
plot(fF(1).f,Average_PSD1);
subplot(5,3,6);
for aa = 1:length(peakOnset(2).start)
    [PSDb,fb] = pwelch(data(2).PCG(peakOnset(2).start(aa):peakOffset(2).end(aa)),[],[],[],1000);
    PSDDb(:,aa) = PSDb;
    Average_PSD2 = mean(PSDDb,2);
end
plot(fF(2).f,Average_PSD2);
subplot(5,3,9);
for aa = 1:length(peakOnset(3).start)
    [PSDc,fc] = pwelch(data(3).PCG(peakOnset(3).start(aa):peakOffset(3).end(aa)),[],[],[],1000);
    PSDDc(:,aa) = PSDc;
    Average_PSD3 = mean(PSDDc,2);
end
plot(fF(3).f,Average_PSD3);
subplot(5,3,12);
for aa = 1:length(peakOnset(4).start)
    [PSDd,fd] = pwelch(data(4).PCG(peakOnset(4).start(aa):peakOffset(4).end(aa)),[],[],[],1000);
    PSDDd(:,aa) = PSDd;
    Average_PSD4 = mean(PSDDd,2);
end
plot(fF(4).f,Average_PSD4);
subplot(5,3,15);
for aa = 1:length(peakOnset(5).start)
    [PSDe,fe] = pwelch(data(5).PCG(peakOnset(5).start(aa):peakOffset(5).end(aa)),[],[],[],1000);
    PSDDe(:,aa) = PSDe;
    Average_PSD5 = mean(PSDDe,2);
end
plot(fF(5).f,Average_PSD5);


    
    