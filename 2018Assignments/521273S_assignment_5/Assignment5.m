fs = 2000;

% 1.1 ==== All segments of the normalized force ==== %
%figure(1)
%norm_data1 = (data(1).force-min(data(1).force))./(max(data(1).force)-min(data(1).force));
%plot(data(1).t,norm_data1);

figure(1);
subplot(2,1,1);

plot(data(1).t,data(1).force);
hold on
plot(data(2).t,data(2).force);
hold on 
plot(data(3).t,data(3).force);
hold on 
plot(data(4).t,data(4).force);
hold on 
plot(data(5).t,data(5).force);
xlabel('Time (Seconds)');
ylabel('Force(% MVC)');
title('Normalized force')
hold off

% 1.2 ==== All segments of EMG signal ==== %

subplot(2,1,2);
plot(data(1).t,data(1).EMG);
hold on
plot(data(2).t,data(2).EMG);
hold on 
plot(data(3).t,data(3).EMG);
hold on 
plot(data(4).t,data(4).EMG);
hold on 
plot(data(5).t,data(5).EMG);
xlabel('Time (Seconds)');
ylabel('EMG amplitude (mV)');
title('EMG signal')
hold off


% 2 ====  Average force exerted within each segment of the force signal =

%Average_Force = (sum(data(1).force)/3233);

Average_Force(1) = mean(data(1).force);
Average_Force(2) = mean(data(2).force);
Average_Force(3) = mean(data(3).force);
Average_Force(4) = mean(data(4).force);
Average_Force(5) = mean(data(5).force);

%{
s = 5;
Average_Force(5) = data(s).force;
for i = 1:s
   Average_Force(i,1) = mean(data(s).force);
end
%}

% 3 ==== Compute the DR for each segment of the EMG signal ==== %

DR_EMG(1) = peak2peak(data(1).EMG);
DR_EMG(2) = peak2peak(data(2).EMG);
DR_EMG(3) = peak2peak(data(3).EMG);
DR_EMG(4) = peak2peak(data(4).EMG);
DR_EMG(5) = peak2peak(data(5).EMG);

% 4 ==== Compute the MS for each segment of the EMG signal ==== %

MS_EMG(1) = (1/data(1).length)*(sum((data(1).EMG).^2));
MS_EMG(2) = (1/data(2).length)*(sum((data(2).EMG).^2));
MS_EMG(3) = (1/data(3).length)*(sum((data(3).EMG).^2));
MS_EMG(4) = (1/data(4).length)*(sum((data(4).EMG).^2));
MS_EMG(5) = (1/data(5).length)*(sum((data(5).EMG).^2));

% 5 ==== Compute the ZCR for each segment of the EMG signal ==== %
%test = abs(diff(sign(data(1).EMG)));
ZCR_EMG(1) = sum(abs(diff(sign(data(1).EMG))))/2*fs/data(1).length;
ZCR_EMG(2) = sum(abs(diff(sign(data(2).EMG))))/2*fs/data(2).length;
ZCR_EMG(3) = sum(abs(diff(sign(data(3).EMG))))/2*fs/data(3).length;
ZCR_EMG(4) = sum(abs(diff(sign(data(4).EMG))))/2*fs/data(4).length;
ZCR_EMG(5) = sum(abs(diff(sign(data(5).EMG))))/2*fs/data(5).length;

% 6 ==== Compute the TCR for each segment of the EMG signal ==== %

% 6.1 Compute the derivative of the EMG signal

Der_EMG_1= diff(data(1).EMG);
Der_EMG_2= diff(data(2).EMG);
Der_EMG_3 = diff(data(3).EMG);
Der_EMG_4 = diff(data(4).EMG);
Der_EMG_5 = diff(data(5).EMG);

% 6.2 Detect points of change in its sign

%sign_EMG_1 = sign(data(1).EMG);
%sign_EMG_2 = sign(data(2).EMG);
%sign_EMG_3 = sign(data(3).EMG);
%sign_EMG_4 = sign(data(4).EMG);
%sign_EMG_5 = sign(data(5).EMG);

% 6.3 Detect significant turn in signal

%ipt = findchangepts(Der_EMG_1);
%test = sign(Der_EMG_1)>0.1;

TCR_EMG = zeros(1,5);
for i = 1:5
    derivate = diff(data(i).EMG);
    signs = sign(derivate);
    turn = signs(1:end-1).*signs(2:end);
    turn_count = find(turn<0)+1;
    extreme = data(i).EMG(turn_count);
    diff_b_extreme = diff(extreme);
    
    extreme_turn_point = find((abs(diff_b_extreme)>0.1));
    
    tc = length(extreme_turn_point);
    TCR_EMG(i) = tc/(data(i).t(end))-(data(i).t(1));
    
    
end   

%TCR_EMG = (sum(abs(diff(sign(Der_EMG_1))>0.1))/2/(length(Der_EMG_1)/fs));
        
%find(Der_EMG_1(1:end-1)>0.1 & Der_EMG_1(2:end) < 0.1)
%find(diff(Der_EMG_1>=0),1)

% 7 ==== Plot the DR, MS, ZCR, and TCR parameters (y axis) versus the average force in %MVC (x axis) ==== %
figure(2);

subplot(2,2,1);
plot(Average_Force,DR_EMG,'r*');
hold on
subplot(2,2,2);
plot(Average_Force,MS_EMG,'r*');
hold on
subplot(2,2,3);
plot(Average_Force,ZCR_EMG,'r*');
hold on
subplot(2,2,4);
plot(Average_Force,TCR_EMG,'r*');
hold on
% 8 ==== straight-line (linear) fit to represent the variation of each EMG ==== %

subplot(2,2,1)
x=linspace(1,100);
p1 = polyfit(Average_Force,DR_EMG,1);
y1 = polyval(p1,x);
plot(x,y1);

subplot(2,2,2)
x=linspace(1,100);
p1 = polyfit(Average_Force,MS_EMG,1);
y1 = polyval(p1,x);
plot(x,y1);

subplot(2,2,3)
x=linspace(1,100);
p1 = polyfit(Average_Force,ZCR_EMG,1);
y1 = polyval(p1,x);
plot(x,y1);

subplot(2,2,4)
%x=linspace(1,100);
p1 = polyfit(Average_Force,TCR_EMG,1);
y1 = polyval(p1,Average_Force);
plot(Average_Force,y1);

% 9 ==== Correlation coefficients (r) ==== %

corr_DR = corr(Average_Force,DR_EMG);
corr_MS = corr(Average_Force,MS_EMG);
corr_ZCR = corr(Average_Force,ZCR_EMG);
corr_TCR = corr(Average_Force,TCR_EMG);













