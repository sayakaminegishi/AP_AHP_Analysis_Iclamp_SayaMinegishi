% This script analyzes properties of evoked APs. gives the properties of
% the first AP detected.

% Created by: Sayaka (Saya) Minegishi, with support from Dr. Stephen Van
% Hooser
% Contact: minegishis@brandeis.edu
% Date: Dec 8 2023



%start loading files
close all
clf 
clear 
%start loading files
filesNotWorking = []; %list of files with errors
list = dir('*.abf');
file_names = {list.name}; %list of all abf file names in the directory 

filenameExcelDoc = strcat('Evoked_lastSweep_WKYN_DEC8.xlsx');

multipleVariablesTable= zeros(0,23);
multipleVariablesRow = zeros(0, 23);


myVarnames1 = {'cell name','sweep no. of first AP in cell', 'current_injected(pA)', 'AP_frequency(Hz)', 'threshold (mV)', 'amplitude (mV)', 'AHP amplitude (mV)', 'first trough value (mV)', 'first trough location(ms)', 'first spike peak value(mV)', 'first spike location(ms)', 'half_width(ms)', 'AHP_30_val(mV)', 'AHP_50_val(mV)', 'AHP_70_val(mV)', 'AHP_90_val(mV)', 'half_width_AHP(ms)', 'AHP_width_10to10%(ms)', 'AHP_width_30to30%(ms)', 'AHP_width_70to70%(ms)', 'AHP_width_90to90%(ms)', 'Avg_ISI_first_half_of_data(ms)', 'Avg_ISI_last_half_of_data(ms)'};
T1= array2table(multipleVariablesTable, 'VariableNames', myVarnames1); %stores info from all the sweeps in an abf file

current_injected = [-50:15:310];
for n=1:size(file_names,2)
    
      
    
   filename = string(file_names{n});
    disp([int2str(n) '. Working on: ' filename{:}])
   
    [dataallsweeps, si, h] =abf2load(filename); %get si and h values from this abf file


    totalsweeps=size(dataallsweeps,3); %the total number of sweeps to be analyzed (25)
   
    
    %dataallsweeps d (first output) gives 3d array of size (data pts per sweep) x (no. of channels) x (no.of
    %sweeps).
    numpointspersweep = size(dataallsweeps, 1); %size of first column, which is the total no. of points per sweep in this ABF file
    
    si_actual = 1e-6 * si; %in ms. original si is in usec

    sweep_firstAP = -1; %first sweep no. at which AP is first detected. -1= no AP detected in any sweep from the cell.
    
    numspikes = 0;
    dV_thresh = 100 * 8e-6 / si_actual; %THRESHOLD SLOPE  ( 0.8 mV / ms)
    %dV_thresh = 8; %ADJUST
 %THRESHOLD SLOPE
    
    % itereate through 
    
    for a = totalsweeps:totalsweeps
       
        %display(a);
   
        data=dataallsweeps(:,1,a); %select sweep to analyze....data=dataallsweeps(:,1,9). this is the trace.
        x_axis_samples = 1:size(data,1);
        x_axis_actual = sampleunits_to_ms(si, x_axis_samples);
       
        restingpotential = data(1); %resting potential. used for calculating AHP troughs
        all_dV = find(diff(data) > dV_thresh);  %list of locations at which slope > threshold

        
        
        
        
        
        if (numel(all_dV) ~= 0 & sweep_firstAP == -1) %if an action potential is detected and this is the first AP in this abf, record data in table. if not, move onto next sweep
            threshold_voltage = data(all_dV(1)); 
            %define necessary variables
            %initialize, so that if a parameter measurement fails, the function still
            %runs
            amplitude = 0;
            AHP_amp = 0;
            half_width_AHP = 0;
            half_width_AP = 0;
            half_max_down_index(1)=0;
            half_max_up_index(1)=0;
            interp_hw_AP = 0;
            interp_hw_AHP = 0;
            half_max_up_index=0;
            AHP_decay_10to10 = 0;%calculate AHP 10-10% time
            AHP_decay_30to30 = 0; %calculate AHP 30-30% time
            AHP_decay_70to70 = 0; %calculate AHP 70-70% time
            AHP_decay_90to90 = 0;%calculate AHP 90-90% time

            allSpikeSamples = get_spikelocations(data,threshold_voltage); %get AP spike times
    
         %allSpikeTimes = si_actual * allSpikeSamples; %all the spike locations in ms!!!!
         allSpikeTimes = sampleunits_to_ms(si, allSpikeSamples); %all the spike locations in ms!!!!
    
            total_count_Aps = numel(allSpikeSamples); %update total count of APs detected from this cell
            
            % frequency of action potentials in Hz (counts of peaks / sec)
        %si = sampling interval in microseconds
         %totalduration_sec = si * 10^(-6) * numel(data); %total duration of the recording in sec for the whole trace, minus the transients
    
          %totalduration_sec = numel(data) * si_actual * 1/1000; %total duration of the recording in sec for the whole trace, minus the transients
        totalduration_milisec = sampleunits_to_ms(si, numel(data));
        totalduration_sec = totalduration_milisec * 10e-3;
         freq_in_hz = total_count_Aps/totalduration_sec;
            
          mainpeakloc = allSpikeSamples(1); %peak time. if we want 1st, make it 1.
          
          %Interspike interval
          ISI_list = find_isi(allSpikeTimes);
          halfwaymark = round(numel(ISI_list)/2);
          
          isi_firsthalf = ISI_list(1:halfwaymark);
          isi_secondhalf = ISI_list(halfwaymark + 1: end);

          avg_isi_firsthalf = mean(isi_firsthalf); %in ms
          avg_isi_secondhalf = mean(isi_secondhalf); %in ms
         
    %Spike times - extract waveform
   
    
   % manually examine and set the rising and falling
    %durations for the neuron.
    % risingDuration = ms_to_sampleunits(si, 132.7); %in sample units
    % fallingDuration = ms_to_sampleunits(si, 157.8); %in sample units

    risingDuration = 1279-947; 
   fallingDuration = 1542-1279;
   
    [test_spike,starttime,endtime] = extract_waveform3_ev(risingDuration,fallingDuration, mainpeakloc, data); %in sample units
  
    amplitude = max(test_spike) - test_spike(1);
    AHP_amp = test_spike(1) - min(test_spike);
    max_voltage = data(mainpeakloc);
    
    
    maxpoint = find(test_spike == max(test_spike));
    maxpoint = maxpoint(1);

    % Find the minimum value in the specified portion
    minValue = min(test_spike(maxpoint:end));

    % Find the index of the minimum value in the specified portion
    minpoint = find(test_spike(maxpoint:end) == minValue, 1, 'first') + maxpoint - 1;

    minpoint_val = test_spike(minpoint);

    figure;
    plot(x_axis_actual,data)
    hold on
    plot(sampleunits_to_ms(si, starttime + maxpoint), data(starttime + maxpoint), 'ro')
    plot(sampleunits_to_ms(si, starttime + minpoint), data(starttime + minpoint), 'rdiamond')
    xlabel("Time (ms)")
    ylabel("Membrane Potential (mV)")
    hold off
     % AHP properties
     AHP_10 = min(test_spike) + (AHP_amp * 0.9); %100-30 value
     AHP_30 = min(test_spike) + (AHP_amp * 0.7); %100-30
     AHP_90 = min(test_spike) + (AHP_amp * 0.1); %100-90
     AHP_70 = min(test_spike) + (AHP_amp * 0.3); %100-70
     AHP_50 = min(test_spike) + (AHP_amp * 0.5); %100-70
      % AP properties
     AP_50 = max(test_spike) - (amplitude * 0.5); %50% AP
 % %%%%%%%%%%%%%FINDING fractions of AP and AHP widths WITH interpolation
    % % Perform interpolation between max to min pt of test_spike
    x2 = [maxpoint:minpoint];
    xq_maxToMin = x2(1):0.2:x2(end);
    vq_maxToMin = interp1(x2, test_spike(x2), xq_maxToMin); %interpolated values of y between x = min:end
    %  % Create the x-values (assuming they are indices in this case)
    x = [minpoint:numel(test_spike)];
    % % Perform interpolation to get more detailed graph
    xq_minToEnd = x(1):0.2:x(end);
    vq_minToEnd = interp1(x, test_spike(x), xq_minToEnd); %interpolated values of y between x = min:end
    [~, ind_10_rise] = min(abs(vq_minToEnd-AHP_10)); %find the pt in the range (minpoint:end) where distance between value of test_spike at that point and AHP_10 value is the lowest. this finds the closest point to AHP_10.
    [~, ind_30_rise] = min(abs(vq_minToEnd-AHP_30));
    [~, ind_90_rise] = min(abs(vq_minToEnd-AHP_90));
    [~, ind_70_rise] = min(abs(vq_minToEnd-AHP_70));
    [~, ind_50_rise] = min(abs(vq_minToEnd-AHP_50));
    [~, ind_10_dec] = min(abs(vq_maxToMin-AHP_10));
    [~, ind_30_dec] = min(abs(vq_maxToMin-AHP_30));
    [~, ind_90_dec] = min(abs(vq_maxToMin-AHP_90));
    [~, ind_70_dec] = min(abs(vq_maxToMin-AHP_70));
    [~, ind_50_dec] = min(abs(vq_maxToMin-AHP_50));  
    % interpolation of y values between 1 to max pt
    x3 = 1:maxpoint;
    xq_1tomax= x3(1):0.2:x3(end);
    vq_1tomax = interp1(x3, test_spike(x3), xq_1tomax);
    % variables for finding half width of AP
    [~, AP_50_rise] = min(abs(vq_1tomax-AP_50));
    [~, AP_50_dec] = min(abs(vq_maxToMin-AP_50));


    %FIXED:
    interp_hw_AHP = numel(vq_maxToMin)+ind_50_rise - ind_50_dec;
    interp_hw_AHP_time = 0.2 * sampleunits_to_ms(si,  interp_hw_AHP);

    %adjusted accordingly (in sample units):
    AHP_decay_10to10 = numel(vq_maxToMin)+ind_10_rise - ind_10_dec; %AHP 10% to 10% width
    AHP_decay_30to30 = numel(vq_maxToMin)+ind_30_rise - ind_30_dec;  %calculate AHP 30-30% time
    AHP_decay_70to70 = numel(vq_maxToMin)+ind_70_rise - ind_70_dec; %calculate AHP 70-70% width
    AHP_decay_90to90 = numel(vq_maxToMin)+ind_90_rise - ind_90_dec;

    %convert from sampleunits to ms:
    dec10w = 0.2 * sampleunits_to_ms(si,  AHP_decay_10to10);
    dec30w = 0.2 * sampleunits_to_ms(si,  AHP_decay_30to30);
   dec70w =0.2 * sampleunits_to_ms(si,  AHP_decay_70to70);
   dec90w =0.2 * sampleunits_to_ms(si,  AHP_decay_90to90);

            
 
            
    %%%%%%%% AP properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    interp_hw_AP = numel(vq_1tomax)+ AP_50_dec - AP_50_rise;
    interp_hw_AP_time = 0.2 * sampleunits_to_ms(si,  interp_hw_AP);
   
    %minpoint and maxpoints, in terms of whole data
    
    minpoint_in_trace = find(test_spike == test_spike(minpoint) ) + starttime;
 
    maxpoint_in_trace = find(test_spike == test_spike(maxpoint) ) + starttime;
  
   %  % DURATION OF AP: include only if the spike window was not fixed! ,
   %  duration_ms(1) = , 'duration(ms)'
   %  duration_sampleunits = numel(test_spike);
   % duration_ms = sampleunits_to_ms(si, duration_sampleunits);
   % 
 
    spikeloc = sampleunits_to_ms(si,mainpeakloc); % %
    minp = data(minpoint_in_trace); % % 
    minpInTrace =sampleunits_to_ms(si, minpoint_in_trace(1));
    maxpointdata = data(maxpoint_in_trace); % % 
    maxpointInTrace =sampleunits_to_ms(si,maxpoint_in_trace(1)); % % 
    
   
   multipleVariablesRow1= [filename, a, current_injected(a), freq_in_hz, threshold_voltage(1), amplitude(1), AHP_amp(1), minp(1),minpInTrace(1), maxpointdata(1), maxpointInTrace(1), interp_hw_AP_time, AHP_30(1), AHP_50(1), AHP_70(1), AHP_90(1), interp_hw_AHP_time, dec10w(1), dec30w(1), dec70w(1), dec90w(1), avg_isi_firsthalf(1), avg_isi_secondhalf(1)];
            
   M1= array2table(multipleVariablesRow1, 'VariableNames', myVarnames1);
   T1 = [T1; M1];
   sweep_firstAP = 1;
   
end
    end
end
        
    
display(T1)
writetable(T1, filenameExcelDoc, 'Sheet', 1); %export summary table to excel