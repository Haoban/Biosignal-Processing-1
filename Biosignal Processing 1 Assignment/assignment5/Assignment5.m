% ++++++++++++ Linear modeling ++++++++++++ %

% The sampling rate is 2000 Hz 
FS = 2000;

% Load the signals from data.mat into the struct 'data'
% << insert loading code here >>
load('data.mat');
% Number of segments
N = numel(data);  

% Calculate average force of each segment (1xN vector)
AF(1) = mean(data(1).force);
AF(2) = mean(data(2).force);
AF(3) = mean(data(3).force);
AF(4) = mean(data(4).force);
AF(5) = mean(data(5).force);

% Calculate EMG dynamic range in each segment (1xN vector)
DR(1) = peak2peak(data(1).EMG);
DR(2) = peak2peak(data(2).EMG);
DR(3) = peak2peak(data(3).EMG);
DR(4) = peak2peak(data(4).EMG);
DR(5) = peak2peak(data(5).EMG);

% Calculate EMG mean squared value in each segment (1xN vector)

MS(1) = (1/data(1).length)*(sum((data(1).EMG).^2));
MS(2) = (1/data(2).length)*(sum((data(2).EMG).^2));
MS(3) = (1/data(3).length)*(sum((data(3).EMG).^2));
MS(4) = (1/data(4).length)*(sum((data(4).EMG).^2));
MS(5) = (1/data(5).length)*(sum((data(5).EMG).^2));

% Calculate EMG zero crossing rate in each segment (1xN vector)

ZCR(1) = sum(abs(diff(sign(data(1).EMG))))/2*FS/data(1).length;
ZCR(2) = sum(abs(diff(sign(data(2).EMG))))/2*FS/data(2).length;
ZCR(3) = sum(abs(diff(sign(data(3).EMG))))/2*FS/data(3).length;
ZCR(4) = sum(abs(diff(sign(data(4).EMG))))/2*FS/data(4).length;
ZCR(5) = sum(abs(diff(sign(data(5).EMG))))/2*FS/data(5).length;

% Calculate EMG turns rate in each segment (1xN vector)


for i = 1:5
    % Compute the derivative of the EMG signal
    derivate = diff(data(i).EMG);
    % Compute sign of derivate
    signs = sign(derivate);
    % Compute points of change in its sign
    turn = signs(1:end-1).*signs(2:end);
    turn_count = find(turn<=0)+1;
    extreme = data(i).EMG(turn_count);
%     diff_b_extreme = extreme(1:end-1) - extreme(2:end);
    diff_b_extreme = diff(extreme);
    extreme_turn_point = find((abs(diff_b_extreme)>0.1));    
    tc = length(extreme_turn_point);
    TCR(i) = tc/(data(i).t(end)-data(i).t(1));

%     TCR(i) = tc/(data(i).length);
end

% Calculate the linear model coefficients for each parameter
% The models are in the form: parameter(force) = constant + slope * force,
% and the coefficients are stored in a 1x2 vectors: p_<param> = [constant slope]
% For example, p_DR(1) is the constant and p_DR(2) is the slope of the linear model mapping the average force into the dynamic range
% You can use the 'polyfit' (or the 'regress') command(s) to find the model coefficients

p_DR = polyfit(AF,DR,1);
p_MS = polyfit(AF,MS,1);
p_ZCR = polyfit(AF,ZCR,1);
p_TCR = polyfit(AF,TCR,1);

% Calculate correlation coefficients between the average forces and each of the parameters using 'corr'
% Force = [data(1).force;data(2).force;data(3).force;data(4).force;data(5).force];
% EMG = [data(1).EMG;data(2).EMG;data(3).EMG;data(4).EMG;data(5).EMG];
% 
% Ave_Force = mean(Force);
% Dynamic_Range = peak2peak(EMG);

c_DR = corr(AF',DR');
c_MS = corr(AF',MS');
c_ZCR = corr(AF',ZCR');
c_TCR = corr(AF',TCR');
