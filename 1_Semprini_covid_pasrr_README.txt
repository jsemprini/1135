README File for Initial Do-File, 
"How Did Covid-19 Emergency State Waivers Suspending Pre-Admission Screenings Impact Cases, Deaths, and Capacity in Skilled-Nursing Facilities?"
Author: Jason Semprini, MPP

Date: 11/17/20
Inputs: 
1) CMS SNF/Covid dataset
2) CMS VBP (2019) dataset
3) CMS Quality (2019) dataset
4) NYT County-Level covid-19 Cases & Deaths (2020) dataset
5) Kaggle (Offer) and ERS USDA ZipCode and Rura/Urban Codes for FIPS
6) CMS State Waivers (2020) dataset, CMS State PASRR Defs (2019) dataset, and CMS PASRR Stats (2019) dataset

This initial do-file (1-initialize) creates the initial dataset using raw data from CMS, NYT, and other federal government sources. The outcome data comes from CMS and contains outcome data and SNF-identifiers. Pre-pandemic CMS data on quality metrics were merged to this data. Note, the merge process involved two stages, given that CMS provides both string and numeric identifer codes. 
Next, county-level case and death data were merged by county FIPS codes after merging county-level fips codes to the zip code for each SNF. Several fips codes were manually entered. Also note, NYT treats NYC, Joplin MO, and Kansas City as distinct sites for covid-19 tracking, so SNFs in those cities were merged accordingly. County-level Rural/Urban continuum codes were obtained via USDA ERS. 
The state-level data comes from earlier work by Semprini & Kaskie (2020). This data contains the status and date of a state's PASRR request, 2019 state Pasrr deficiencies, and 2019 state pasrr statistics. 


