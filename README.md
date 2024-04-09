# AP_AHP_Analysis_Iclamp_SayaMinegishi
Detects bursts and singlet AP spikes from either a single abf file or a batch of abf files in the same directory, and gives summary tables (with excel exports) of action potential and afterhyperpolarization properties. Used for current-clamp recordings.

## Description of each script that you can run

 NB: store the abf files of interest in the SAME DIRECTORY (same folder) as the rest of the scripts! Sample files to test are in the zip folder (you have to open it and copy-paste the files into your working folder).

### For analysis of Spontaneous Recordings:
• **“CMA_batch_analysisFeb17.m”** –click on Run button to analyze all abf files in the same directory where this script & its function scripts are stored. Gives results for each file in tables.

 • **“feb17_single.m”** – run analysis on an abf file of interest. Specify its file name after “filename1=”. Then hit Run.
 
### For analysis of Evoked Recordings:
 • **Apr8_batchEVOKED.m (relies on analyzeSingleEvokedApr8.m)** - performs batch analysis of all ABF files in the folder. Analyzes the properties of the first AP detected in each cell. Access from Apr 8 scripts folder.

Scripts were checked for accuracy by visual inspection and by comparing with the results from pclamp's analysis tool when applicable. 

For any questions or concerns, please feel free to contact me at minegishis@brandeis.edu



Sayaka (Saya) Minegishi
