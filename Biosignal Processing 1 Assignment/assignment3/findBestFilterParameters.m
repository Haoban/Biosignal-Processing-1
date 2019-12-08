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
    best_m = 0;
    best_c = 0;
    best_w = 0;
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
    
    for leng = m_list
        for learning_rate = c_list

            [y,e,w] = doLMSFiltering(leng,learning_rate*mu_max,chestECG,abdomenECG);
            max(size(y))
            
            mse = evaluateResult(y);
            
            if best_mse < mse

                best_m = leng;
                best_c = learning_rate;
                best_w = w;
                best_mse = mse;
            end
        end
    end

end