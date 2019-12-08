% +++++++++++ Pure sum of signals ++++++++++++++ %

% Load problem1.mat to have access to variables abd_sig1 and mhb
load('problem1.mat');

% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = [0:1/FS:(length(abd_sig1)-1)/FS];

% Estimate c2 from abd_sig1 and mhb using the scalar projection formula
c2_projection = transpose(abd_sig1)*mhb/(transpose(mhb)*mhb);

% Estimate c2 from abd_sig1 and mhb using the pseudoinverse function (pinv)
c2_pinv = pinv(mhb)*abd_sig1;

% Estimate c2 from abd_sig1 and mhb using the backslash operator (\)
c2_operator = mhb\abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using projection based estimation coefficient
fetus = abd_sig1 - c2_projection*mhb;

% +++++++++++  Delayed sum of signals ++++++++++++++ %

% Load problem2.mat to have access to variables abd_sig1 and mhb_ahead
load('problem2.mat');

% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = [0:1/FS:(length(abd_sig1)-1)/FS];

% Estimate the time lag using cross correlation
% (Calculate cross correlation using the xcorr function and then
% use the max function to find the lag giving maximal correlation)
% d = double(fix(max(xcorr(mhb_ahead))));
[c,lags] = xcorr(abd_sig1, mhb_ahead);
stem(lags,c);
index = knnsearch(c, max(c));
d = lags(index);

% Shift the chest ECG mhb_ahead back in time d samples padding with nearest value
mhb = zeros(length(mhb_ahead),1);
% Define a padding value for delay
mhb(1:d)  = mhb_ahead(1);
mhb(d+1:length(mhb_ahead)) = mhb_ahead(1:length(mhb_ahead)-d);

% Estimate c2 from abd_sig1 and mhb
c2 = pinv(mhb)*abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using projection based estimation coefficient
fetus = abd_sig1 - c2*mhb;

% +++++++++++   Delayed sum of signals - subsample accuracy ++++++++++++++ %

% Load problem3.mat to have access to variables abd_sig1 and mhb_ahead
load('problem3.mat');

% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = [0:1/FS:(length(abd_sig1)-1)/FS];

% Estimate the time lag using cross correlation with the 'xcorr' function
% Fit a spline to the cross correlation using 'spline' function, and then find the delay with maximum correlation using 'fnmin'
% NOTE: to use minimization function for maximization, please invert the objective function!

[c, lags] = xcorr(mhb_ahead, abd_sig1);
pp = spline(lags , -c);
[y,x] = fnmin(pp);
d = -x;

% Shift the chest ECG mhb_ahead back in time d samples
% Use linear interpolation with extrapolation with the function 'interp1'


% mhb = zeros(length(mhb_ahead),1);
% % % Define a padding value for delay
% new_start = floor(d)+1;
% mhb(1:new_start) = mhb_ahead(1);
% xq = [new_start+1-d:length(mhb_ahead)-d];
% vq = interp1(mhb_ahead,xq,'linear','extrap');
% mhb(new_start+1:length(mhb_ahead))  = vq;

mhb_a = interp1(mhb_ahead,(1:length(mhb_ahead))-d,'linear','extrap');
mhb = mhb_a';
% 
% size(mhb)
% size(abd_sig1)
% % Estimate c2 from abd_sig1 and mhb
% c2 = (mhb'*mhb)\(abd_sig1'*mhb);

c2 = pinv(mhb)*abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using projection based estimation coefficient
fetus = abd_sig1 - c2*mhb;


% +++++++++++    Full adaptive filtering  ++++++++++++++ %

function [best_m, best_c, best_w, best_mse] = findBestFilterParameters(chestECG, abdomenECG, fetalECG, m_list, c_list, mu_max)
% This function finds the best LMS filter parameter combination from the
% given lists using two inner functions.
% To be completed by you!
%
% INPUTS:
%   chestECG    ECG from the chest, maternal ECG only, reference input, Nx1
%   abdomenECG  ECG from the abdomen, fetal and maternal mixed, primary input, Nx1
%   fetalECG    ECG from the fetus alone, signal of interest, Nx1 (cannot be measured directly, but is given for evaluation here)
%   m_list      list of filter lengths/orders to test, Mx1
%   c_list      list of step size fractions to test, Cx1 (each >0 & <1)
%   mu_max      maximum step size, scalar
%
% OUTPUTS:
%   best_m      the best filter length (from the m_list), scalar
%   best_c      the best fraction of mu_max (from the m_list), scalar
%   best_w      the best filter coefficients, best_m x 1 vector
%   best_mse    the lowest mean squared error obtained with the best parameters, scalar

% When evaluating the results in evaluateResult(), skip this many samples from the beginning to avoid initial adaptation transient
INITIAL_REJECTION = 2000;

% Here you go through all the possible combinations of filter lengths in m_list and learning rate fractions in c_list selecting the best performing one
% << INSERT YOUR CODE HERE >>

    best_mse = exp(1000);

    
    function [y,e,w] = doLMSFiltering(m,step,r,x)
    % Does the actual LMS filtering.
    % To be completed by you!
    %
    % INPUTS:
    %   m       filter length
    %   step    LMS learning rule step size
    %   r       reference input (to be filtered)
    %   x       primary observed signal
    %
    % OUTPUTS:
    %   y       filtered signal r
    %   e       filter output, estimate of the signal of interest v

    % Create the dsp.LMSFilter object and use it to filter the input data
    % << INSERT YOUR CODE HERE >>
        LMS= dsp.LMSFilter('Method','LMS','Length',m,'StepSize',step);
        [y,e,w]=LMS(r,x);
    end

    function mse = evaluateResult(v)
    % Calculates the mean squared error between the filtered signal v and
    % the known fetal ECG.
    %
    % NOTE1:    Skip INITIAL_REJECTION number of samples in the beginning of both signals to not include initial adaptation transient
    % 
    % NOTE2:    This nested function can access the desired output value in fetalECG directly!
    %
    % INPUTS:
    %   v       estimate of the signal of interest 
    %
    % OUTPUTS:
    %   mse     mean squared error between v and fetalECG    

    % You can call the 'immse' function for the signals without the initial rejection parts
    % << INSERT YOUR CODE HERE >>
        new_v = v(INITIAL_REJECTION :length(v));
        new_fetal = fetalECG(INITIAL_REJECTION :length(fetalECG));
        mse = immse(new_fetal, new_v);
        
    end
    
    for leng = m_list'
        for learning_rate = c_list'
            
            step = (2*learning_rate*mu_max)/leng;
            
            [y,e,w] = doLMSFiltering(leng,step,chestECG,abdomenECG);
            
            mse = evaluateResult(e)
            
            if  mse < best_mse

                best_m = leng;
                best_c = learning_rate;
                best_w = w;
                best_mse = mse;
            end
        end
    end

end