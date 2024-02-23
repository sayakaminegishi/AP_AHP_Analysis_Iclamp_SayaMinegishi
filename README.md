# AP_AHP_Analysis
Detects bursts and singlet AP spikes from either a single abf file or a batch of abf files in the same directory, and gives summary tables (with excel exports) of action potential and afterhyperpolarization properties. 

## Description of each script that you can run
• “CMA_batch_analysisFeb17.m” –click on Run button to analyze all abf files in the same directory where this script & its function scripts are stored. Gives results for each file in tables.

 • “feb17_single.m” – run analysis on an abf file of interest. Specify its file name after “filename1=”. Then hit Run.

 NB: store the abf files of interest in the SAME DIRECTORY (same folder) as the rest of the scripts! Sample files to test are in the zip folder (you have to open it and copy-paste the files into your working folder).

 • “Feb23_batchEVOKED.m” – click run to perform batch-analysis on the properties of the FIRST AP DETECTED IN EACH CELL (+freq in the trace). Creates a summary table. For evoked samples.

 • “Feb23_singleEVOKED.m” – specify abf file, click run to perform single-cell analysis on the properties of the FIRST AP DETECTED IN THE ABF FILE (+freq in the trace). Creates a summary table. Used for analysis of evoked samples.
![image](https://github.com/sayakaminegishi/AP_AHP_Analysis/assets/47896245/863bb0aa-c99d-48a6-9fa5-a0e9e7c3f58f)


For any questions or concerns, please feel free to contact me at minegishis@brandeis.edu



Sayaka (Saya) Minegishi
