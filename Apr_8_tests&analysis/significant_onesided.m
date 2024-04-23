% Analysis of AP % AHP properties between WKY and SHR neurons for the LAST
% SWEEP
% Created by Sayaka (Saya) Minegishi
% Contact: minegishis@brandeis.edu
% Last Updated: 3/31/2024

close all
clear all

% Define the headers for the table
headers = {'Property', 'p-val', 'alpha', 'Result'};

% Create the table
sumtable= zeros(0,numel(headers));
summaryTable = array2table(sumtable, 'VariableNames', headers);




%%%% load data from excel spreadsheets

SHRTable = readtable("/Users/sayakaminegishi/MATLAB/Projects/AP_AHP_Analysis_Iclamp_SayaMinegishi/Analysis&Tests/SHRevoked_apr15.xlsx","TextType","string");
WKYTable = readtable("/Users/sayakaminegishi/MATLAB/Projects/AP_AHP_Analysis_Iclamp_SayaMinegishi/Analysis&Tests/WKYevoked_apr15.xlsx","TextType","string");

strain = ["WKYN", "SHRN"];

alpha = 0.05;


%%%%%%%% compare ap_threshold  - one sided test %%%%%%%%%%%%%%

shr_thresh= str2double(SHRTable.frequency_Hz_); %SHR threshold values for 1st AP detected
wky_thresh = str2double(WKYTable.frequency_Hz_); 

[h,p,ci,stats] = ttest2(wky_thresh,shr_thresh,'Vartype','unequal', 'Tail', 'right') %test Ha: wky  > shr 

% Interpret the results
if h == 1
    str = 'The mean firing frequency for WKYN is greater than the mean for SHRN.';
else
   str = 'There is no significant difference in the mean current_injected_pA_ between the two strains.';
end

% make side-by-side boxplot of the data
figure(1)
% Determine the number of data points in each dataset
num_shr = numel(shr_thresh);
num_wky = numel(wky_thresh);


% Determine the maximum number of data points
max_num_data = max(num_shr, num_wky);

% Pad the smaller dataset with NaN values to match the size of the larger dataset
if num_shr < max_num_data
    shr_thresh = [shr_thresh; nan(max_num_data - num_shr, 1)];
elseif num_wky < max_num_data
    wky_thresh = [wky_thresh; nan(max_num_data - num_wky, 1)];
end

% Combine the data into a single matrix
combined_data = [shr_thresh, wky_thresh];

% Create a new figure for the boxplot
figure(5);

% Plot the boxplot
boxplot(combined_data, 'Labels', {'SHR', 'WKY'});
title('Comparison of SHR and WKY frequencies');
xlabel('Strain');
ylabel('frequency (Hz)');

% Set the same y-axis limits for both boxplots
ylim([min(min(combined_data)), max(max(combined_data))]);



display(str)

