% +++++++++++ Resample spirometer data +++++++++++ %

% Load the data/variables from the file named spirometer.txt
spiro = load('spirometer.txt')

% The spirometer data 'spiro' is a 2Nx1 vector
% Resample the spirometer data into 50 Hz
spiro_resampled = resample(spiro, 5, 10)

% +++++++++++  Predict respiratory airflows +++++++++++ %

% Load the belt data into Nx2 matrix from the file beltsignals.txt
belt = load('beltsignals.txt')

% Load the resampled spirometer data into Nx1 vector from the file spiro_resampled.mat
spiro_resampled = load('spiro_resampled.mat')

% Load the regression coefficients vector for the model 1 from the file regressioncoefficients1.txt
coeff1 = load('regressioncoefficients1.txt')

% Load the regression coefficients vector for the model 2 from the file regressioncoefficients2.txt
coeff2 = load('regressioncoefficients2.txt')

% Load the regression coefficients vector for the model 3 from the file regressioncoefficients3.txt
coeff3 = load('regressioncoefficients3.txt')

s_ch = belt(1:3000).'

s_ab = belt(3001:6000).'

% Predict the airflow using the model 1, that is with coeff1
flow1 = coeff1(1)*s_ch + coeff1(2)*s_ab

% Predict the airflow using the model 2, that is with coeff2
flow2 = coeff2(1)*s_ch + coeff2(2)*s_ab + coeff2(3)*(s_ch.^2) + coeff2(4)*(s_ab.^2)

% Predict the airflow using the model 3,  that is with coeff3
flow3 = coeff3(1)*s_ch + coeff3(2)*s_ab + coeff3(3)*(s_ch.*s_ab)

% +++++++++++  Evaluate model performances +++++++++++ %

% Load the data from the file problem3.mat
data = load('problem3.mat')

% Nx1 vectors flow1, flow2, and flow3 contain the model predictions
% Nx1 vector spiro_resampled contains the resampled reference spirometer data

belt = data.belt;
flow1 = data.flow1;
flow2 = data.flow2;
flow3 = data.flow3;
spiro_resampled = data.spiro_resampled;

N = 3000;
ave_flow1 = mean(flow1);
ave_flow2 = mean(flow2);
ave_flow3 = mean(flow3);


% Compute the correlation coefficient for the model 1, between flow1 and spiro_resampled
corr1 = corr(flow1, spiro_resampled);

% Compute the correlation coefficient for the model 2, between flow2 and spiro_resampled
corr2 = corr(flow2, spiro_resampled);

% Compute the correlation coefficient for the model 3, between flow3 and spiro_resampled
corr3 = corr(flow3, spiro_resampled);

% Compute the RMSE for the model 1, between flow1 and spiro_resampled
rmse1 = sqrt(mean((flow1-spiro_resampled).^2));

% Compute the RMSE for the model 2, between flow2 and spiro_resampled
rmse2 = sqrt(mean((flow2-spiro_resampled).^2));

% Compute the RMSE for the model 3, between flow3 and spiro_resampled
rmse3 = sqrt(mean((flow3-spiro_resampled).^2));