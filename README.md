# AP_AHP_Analysis_Iclamp_SayaMinegishi
Detects bursts and singlet AP spikes from either a single abf file or a batch of abf files in the same directory, and gives summary tables (with excel exports) of action potential and afterhyperpolarization properties. Used for current-clamp recordings.

## Description of each script that you can run

 NB: store the abf files of interest in separate folders in the 'data' folder. 
 All the function scripts required are in the Apr_8_scripts folder

**instructions for analysis of evoked and spontaneous recordings between strains are available here:** https://docs.google.com/document/d/1Dt-N9spfyecrz-NfVQ8llY4SRXOmuahhmHoIWT_Pxhw/edit?usp=sharing 

### For analysis of Spontaneous Recordings:
Run CMA_batch_analysisFeb17(), where the first argument is the folder name of where your spontaneous files of interest are stored in the ‘data’ directory, and the second argument is the name of the output excel table.

• “CMA_batch_analysisFeb17.m” - function to analyze all abf files in the specified data directory. Gives results for each file in tables.

### For analysis of Evoked Recordings:
see the Google doc. 

Scripts were checked for accuracy by visual inspection and by comparing with the results from pclamp's analysis tool when applicable. 

For any questions or concerns, please feel free to contact me at minegishis@brandeis.edu



Sayaka (Saya) Minegishi
