% ++++++++++++++ Load and select data ++++++++++++++ %

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Select the interval [2 s, 3s] samples from ECG 1
ecg1_interval = ecg1([2*FS:1:3*FS]);

% Sample times for the interval 1
ecg1_interval_t = [2:1/FS:3];

% Select the interval [1 s, 2s] samples from ECG 2
ecg2_interval =  ecg2([1*FS:2*FS]);

% Sample times for the interval 2
ecg2_interval_t =  [1:1/FS:2];


% ++++++++++++++  Compute power spectrum ++++++++++++++ %

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Compute ECG 1 power spectrum
N1 = length(ecg1);
P_ecg1 = (1/N1) *fft(ecg1).*conj(fft(ecg1));

% Compute ECG 2 power spectrum
N2 = length(ecg2);
P_ecg2 = (1/N2) *fft(ecg2).*conj(fft(ecg2));

% Compute power spectrum frequency bins from 0 Hz to the Nyquist frequency
% For ECG 1
f1 = [0:FS/N1:FS/2];
% ...and for ECG 2
f2 = [0:FS/N2:FS/2];

% ++++++++++++++  Moving average filtering ++++++++++++++ %

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Create moving average filter coefficients a and b:
b =  1/10.*ones(1,10);
a =  1;
     
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b,a,ecg1);

% ...and ecg2
ecg2_filtered = filter(b,a,ecg2);
 
% ++++++++++++++   Derivative based filtering ++++++++++++++ %

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Create moving average filter coefficients a and b:
N1 = length(ecg1);
N2 = length(ecg2);
b = [1,-1];
a = [1,-0.995];

b = b/max(freqz(b,a,[],FS));

% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b, a, ecg1);
% ...and ecg2
ecg2_filtered = filter(b, a, ecg2);
 
% ++++++++++++++   Comb filtering ++++++++++++++ %
 
 % The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Create moving average filter coefficients a and b:
b = [0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310];
a = 1;
    
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b,a,ecg1);
% ...and ecg2
ecg2_filtered = filter(b,a,ecg2);

% ++++++++++++++   Cascaded filtering ++++++++++++++ %

% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load('ecg_signal_1.dat');

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load('ecg_signal_2.dat');

% Create cascaded filter coefficients a and b using convolution
b1 =  1/10.*ones(1,10);
a1 =  1;

b2 = [1,-1];
a2 = [1,-0.995];

b2 = b2/max(freqz(b2,a2,[],FS));

b3 = [0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310];
a3 = 1;

b = conv(conv(b1,b2),b3);
a = conv(conv(a1,a2),a3);
    
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b,a,ecg1);
% ...and ecg2
ecg2_filtered = filter(b,a,ecg2);