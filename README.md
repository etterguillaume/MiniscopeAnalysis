# MiniscopeAnalysis
Analysis package for miniscope data
This is an updated version of the Miniscope analysis package developed by Daniel Aharoni at UCLA in collaboration with the Golshani lab, Silva lab, and Khaki lab.
It combines core functions of the original ms package with NormCorre alignment and CNMFE source extraction.

INSTALLATION:

1) Uncompress the Miniscope_Analysis_2018 folder and add it to your Matlab path
2) You need to download or git-clone the latest versions of CNMFE (https://github.com/zhoupc/CNMF_E)  and NormCorre (https://github.com/flatironinstitute/NoRMCorre) and add them to your path. This is important as the Miniscope_Analysis_2018 package relies on these two toolboxes
OPTIONAL: You can use CellReg (Ziv lab, https://github.com/zivlab/CellReg ) for chronic cell registration. This analysis package outputs spatial footprints that can be directly used with that code.
3) Analyse your miniscope data:
- msRun2018: in Matlab, go to your folder containing your miniscope videos (one session) and type ‘msRun2018’
- msBatchRun2018: add the paths pointing to the folders containing your miniscope data (one folder for one session) to the ‘msBatchFileList.m’ file. Be careful not to enter them as strings (do not add the ‘’) but just as is (e.g. /Users/Documents/Calcium_data/cool_experiment/8_24_2018/H04_M37_S12/ )
Once you have entered all your sessions, just type in msBatchRun2018 and let it work. For your information the time spend analyzing is saved in each ms structure. This can give you an idea of the total time required to analyze all your sessions.

PARAMETERS:
-Downsampling: spatial downsampling is very important. It can really speed up your analysis but when done in excess can hinder you from finding cells. I would recommend a factor of 2 to start with, you can increase it up to 4 if your cells appear large and clear.

- Plotting: If false, does not plot anything. If set to True, will issue a summary plot at the end of each analysis (traces, shifts, cell founds and spatial footprints, example traces, behavioural exploration etc… which allows to have a quick look at anything that could have gone wrong during the analysis)

- Save to google drive: I implemented this one because I love to have my desktop analyse data, and then shoot it to the cloud once it’s done so I could access it from anywhere (café, bar, family reunion, etc…) If set to True, it will ask you to provide a root path where all your data will be backed up. Note that it can also be a hard-drive, a USB key, etc… Sub-folders will be created using the name that you enter for each subject in the DAQ software.

OUTPUT:
Although this package tries to be as consistent as possible with previous versions of the ms package, there are a few changes here and there.

ms.Experiment: your experiment name, taken from the subject name that you enter in the DAQ software
ms.CorrProj: Correlation projection from the CNMFE. Displays which pixels are correlated together and suggests the location of your cells
ms.PeakToNoiseRatio:




