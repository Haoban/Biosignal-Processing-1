 % +++++++++++++ Spectrograms and Power Spectral Densities +++++++++++%
 
 % Load the data from the file 'data6.mat'
% << INSERT YOUR CODE HERE >>
load('data6.mat');
% The ECG sampling rate is 1000 Hz
FS = 1000;

% QRS detector operates on 200 Hz signals
FS_QRS = 200;

% The number of subjects
N = numel(data);

% Windowing length
window = 50;

% Number of overlapped samples 
nbroverlap = 45;

% Specify nfft parameter as empty. 
nfft = [];

% Minimum spectrogram threshold
th = -30; 

% Using the pre-extracted cardiac cycles (struct 'cycles'), compute the spectrogram for each subject
% Store the results in a similar 1xN struct array called 'SPCs' with the fields s, f, t, and p corresponding to the outputs of the function 'spectrogram'
% E.g. SPCs(3).p is the power spectral density spectrogram (a matrix) of the subject 3.

for i = 1:5
    [s,f,t,p] = spectrogram(cycles(i).PCG,window,nbroverlap,nfft,FS,'MinThreshold',th,'yaxis');
    SPCs(i) = struct('s', s, 'f', f, 't',t ,'p', p);
end

% Using the full data (struct 'data'), find the QRS complexes using the function 'QRSDetection'
% Store only the QRS onset indice vectors of each subject in the elements of the 1xN cell array 'onsets'
% Note: QRS detection works at a lower data rate of 200 Hz instead of 1000 Hz, so you must resample the data first
% Also you must map the detected onsets back to the original sampling rate by multiplying with the correct factor

% ==== resample ==== %
onsets = {};
for i = 1:5
    R_data(i).ECG = resample(data(i).ECG,1,5);
    R_data(i).ECG = R_data(i).ECG-R_data(i).ECG(1,1);
    [QRSOnsets, QRSOffsets] = QRSDetection(R_data(i).ECG);
    onsets(i) = mat2cell(QRSOnsets*5,1);
end


% The systolic part of the PCG signal is expected to span this many samples starting from the QRS onset in each beat
segment_length = 300;

% Using the previously computed onsets, for each subject 
% pick all their PCG segments corresponding to the systolic parts in a 1xN cell array 'systoles'
% So, each cell corresponds to a subject, and contains a m-by-segment_length sized matrix of their m PCG segments

systoles = {};
IndexMatrix = [];
for i = 1:5
    onsetPCG = cell2mat(onsets(i));
    matrix = [];
    for j = 1:length(onsetPCG)
        matrix(j,:) = data(i).PCG(onsetPCG(j):onsetPCG(j)+segment_length-1);
    end
    systoles{end+1} = matrix;
    onsetPCG = 0;
end


% For each subject, compute the power spectral density (PSD) of all the PCG segments separately
% Use the 'pwelch' function with the default arguments but specifying the sampling rate
% Store the results in a 1xN struct array 'PSDs' with the fields Pxx and F corresponding to the outputs of the pwelch function
% In addition, add the field Pxx_mean which is the average of all the PSD of that subject averaged across the beats
% Thus, PSDs(i).Pxx is a mxk matrix, PSDs(i).F is a kx1 vector, and PSDs(i).Pxx_mean is a 1xk vector

for i = 1:5
    t = length(cell2mat(onsets(i)));
    pxxvalue = [];
    pxxmean = [];
    for j = 1:t
        segPCG = cell2mat(systoles(i));
        [pxx,f] = pwelch(segPCG(j,:),[],[],[],FS);
        pxxvalue(j,:) = pxx;
    end
    pxxmean = mean(pxxvalue,1);
    PSDs(i) = struct('Pxx', pxxvalue, 'F',f, 'Pxx_mean',pxxmean);
end

