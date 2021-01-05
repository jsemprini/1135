****Create Dataset for "How Did Covid-19 Emergency State Waivers Suspending Pre-Admission Screenings Impact Cases, Deaths, and Capacity in Skilled-Nursing Facilities?"

****Author: Jason Semprini, MPP****
****Date: 11/17/20****
****Inputs: ****
****1) CMS SNF/Covid dataset****
****2) CMS VBP (2019) dataset****
****3) CMS Quality (2019) dataset****
****4) NYT County-Level covid-19 Cases & Deaths (2020) dataset****
****5) Kaggle (Offer) and ERS USDA ZipCode and Rura/Urban Codes for FIPS****
****6) CMS State Waivers (2020) dataset, CMS State PASRR Defs (2019) dataset, and CMS PASRR Stats (2019) dataset*****


****First, import time-variant SNF-level outcome and identifier data****

clear all

import delimited "C:\Users\jsemprini\Documents\c-polisci\raw_data\COVID-19_Nursing_Home_Dataset_111220.csv"

keep weekending federalprovidernumber providerstate providerzipcode submitteddata passedqualityassurancecheck residentsweeklyadmissionscovid19 residentsweeklyconfirmedcovid19 residentsweeklysuspectedcovid19 residentsweeklyalldeaths residentsweeklycovid19deaths numberofallbeds totalnumberofoccupiedbeds testedresidentswithnewsignsorsym testedasymptomaticresidentsinaun testedasymptomaticresidentsfacil testedasymptomaticresidentswitho testedstaffandorpersonnelwithnew testedasymptomaticstaffandorpers v51 v52 staffweeklyconfirmedcovid19 staffweeklysuspectedcovid19 staffweeklycovid19deaths shortageofnursingstaff shortageofclinicalstaff shortageofaides shortageofotherstaff oneweeksupplyofn95masks oneweeksupplyofsurgicalmasks oneweeksupplyofeyeprotection oneweeksupplyofgowns oneweeksupplyofgloves oneweeksupplyofhandsanitizer ventilatordependentunit numberofventilatorsinfacility numberofventilatorsinuseforcovid oneweeksupplyofventilatorsupplie county threeormoreconfirmedcovid19cases initialconfirmedcovid19casethisw residentaccesstotestinginfacilit abletotestorobtainresourcestotes

drop threeormoreconfirmedcovid19cases initialconfirmedcovid19casethisw

order weekending federalprovidernumber providerstate county providerzipcode 

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_111720.dta", replace

clear all

****Import pre-pandemic, time-invariant SNF-level quality metrics****

import delimited "C:\Users\jsemprini\Documents\c-polisci\raw_data\cms_provider_111720.csv"
save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_provider_111720.dta", replace

clear all

import delimited "C:\Users\jsemprini\Documents\c-polisci\raw_data\cms_vbp_111720.csv", encoding(windows-1252) stringcols(3)
drop footnotesnfvbpranking footnotebaselineperiodfy2016risk footnoteperformanceperiodfy2018r footnoteachievementscore footnoteimprovementscore footnoteperformancescore footnoteincentivepaymentmultipli
rename providernumberccn provnum

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_vbp_111720.dta", replace

merge 1:1 provnum using "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_provider_111720.dta"


rename _merge mergeflag1

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_provider_vbp_111720.dta", replace


****merge quality metric data again, to account for non-numeric identifer codes****

gen provnum2=provnum
destring(provnum2), force replace

keep provnum snfvbpranking providerzipcode baselineperiodfy2016riskstandard performanceperiodfy2018riskstand overall_rating survey_rating quality_rating staffing_rating adj_total cycle_1_defs cycle_2_defs cycle_3_defs weighted_all_cycles_score incident_cnt cmplnt_cnt fine_cnt fine_tot mergeflag1 provnum2 ownership

rename baselineperiodfy2016riskstandard baseline16_2
rename performanceperiodfy2018riskstand final18_2

foreach i in  overall_rating survey_rating quality_rating staffing_rating adj_total cycle_1_defs cycle_2_defs cycle_3_defs weighted_all_cycles_score incident_cnt cmplnt_cnt fine_cnt fine_tot ownership{

rename `i' `i'2
}

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\tomergeagain_cms_covid_snf_quality_111720.dta", replace


clear all

use "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_111720.dta"

rename federalprovidernumber provnum

merge m:1 provnum using "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_provider_vbp_111720.dta"

rename _merge mergeflag22
save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_111720.dta", replace


gen provnum2=provnum
destring(provnum2), force replace

merge m:m provnum2 using "C:\Users\jsemprini\Documents\c-polisci\stata_data\tomergeagain_cms_covid_snf_quality_111720.dta"
save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality2_111720.dta", replace

drop if weekending==""


****ensure no missing quality data due to different identifier format***
gen baseline_vpn=baselineperiodfy2016riskstandard
replace baseline_vpn=baseline16_2 if baseline_vpn==.
gen performance=performanceperiodfy2018riskstand
replace performance=final18_2 if performance==.

gen owner=ownership 
replace owner=ownership2 if owner==""

gen overall=overall_rating 
replace overall=overall_rating2 if overall==.

gen survey=survey_rating 
replace survey=survey_rating2 if survey==.

gen quality=quality_rating 
replace quality=quality_rating2 if quality==.

gen staffing=staffing_rating 
replace staffing=staffing_rating2 if staffing==.

gen total_score=weighted_all_cycles_score 
replace total_score=weighted_all_cycles_score2 if total_score==.

gen incidents=incident_cnt
replace incidents=incident_cnt2 if incidents==.

gen defs=cycle_1_defs
replace defs=cycle_1_defs2 if defs==.

****keep snf-level variables****
keep weekending provnum providerstate county providerzipcode submitteddata passedqualityassurancecheck residentsweeklyadmissionscovid19 residentsweeklyconfirmedcovid19 residentsweeklysuspectedcovid19 residentsweeklyalldeaths residentsweeklycovid19deaths numberofallbeds totalnumberofoccupiedbeds testedresidentswithnewsignsorsym testedasymptomaticresidentsinaun testedasymptomaticresidentsfacil testedasymptomaticresidentswitho testedstaffandorpersonnelwithnew testedasymptomaticstaffandorpers v51 v52 staffweeklyconfirmedcovid19 staffweeklysuspectedcovid19 staffweeklycovid19deaths shortageofnursingstaff shortageofclinicalstaff shortageofaides shortageofotherstaff oneweeksupplyofn95masks oneweeksupplyofsurgicalmasks oneweeksupplyofeyeprotection oneweeksupplyofgowns oneweeksupplyofgloves oneweeksupplyofhandsanitizer ventilatordependentunit numberofventilatorsinfacility numberofventilatorsinuseforcovid oneweeksupplyofventilatorsupplie baseline_vpn performance owner overall survey quality staffing total_score incidents defs

rename v51 tested_asymp_staff_case
rename v52 tested_asymp_staff_exposure

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_final.dta", replace


*****begin county-level dataset (cases, deaths, and rural/urban codes)****
clear all

import delimited "C:\Users\jsemprini\Documents\c-polisci\raw_data\nyt_covid_county_cases_111720.csv"

rename date weekending

***keep only dates with week ending match to snf-outcome data****

keep if weekending=="2020-05-24" | weekending=="2020-05-31" | weekending=="2020-06-07" | weekending=="2020-06-14" | weekending=="2020-06-21" | weekending=="2020-06-28" | weekending=="2020-07-05" | weekending=="2020-07-12" | weekending=="2020-07-19" | weekending=="2020-07-26" | weekending=="2020-08-02" | weekending=="2020-08-09" | weekending=="2020-08-16" | weekending=="2020-08-23" | weekending=="2020-08-30" | weekending=="2020-09-06" | weekending=="2020-09-13" | weekending=="2020-09-20" | weekending=="2020-09-27" | weekending=="2020-10-04" | weekending=="2020-10-11" | weekending=="2020-10-18" | weekending=="2020-10-25" | weekending=="2020-11-01"

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\nyt_covid_111720.dta", replace

clear all 

import delimited "C:\Users\jsemprini\Documents\c-polisci\raw_data\mask-use-by-county.csv"
rename countyfp fips
save "C:\Users\jsemprini\Documents\c-polisci\stata_data\nyt_masks_111720.dta", replace

clear all

use "C:\Users\jsemprini\Documents\c-polisci\stata_data\nyt_covid_111720.dta"

do "C:\Users\JSEMPR~1\AppData\Local\Temp\STDac4_000000.tmp"
merge m:1 fips using "C:\Users\jsemprini\Documents\c-polisci\stata_data\nyt_masks_111720.dta"

rename _merge mergemaskflag

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\nyt_covid_masks_111720.dta", replace

clear all

import delimited "C:\Users\jsemprini\Documents\c-polisci\raw_data\ZIP-COUNTY-FIPS_2017-06.csv"
save "C:\Users\jsemprini\Documents\c-polisci\stata_data\offer_ziptocounty_111720.dta", replace

clear all

use "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_final.dta"

***Modify date format***
gen month=substr(weekending, 1, 2)
gen day=substr(weekending, 4, 2)
gen year=substr(weekending, 7, 4)

gen date=year+"-"+month+"-"+day

order date

drop weekending

rename date weekending

rename providerzipcode zip

***manually input fips for missing county codes from kaggle/offerman dataset****

replace fips=1031 if providerstate=="AL" & county=="Coffee"
replace fips=1053 if providerstate=="AL" & county=="Escambia"
replace fips=1055 if providerstate=="AL" & county=="Etowah"
replace fips=1081 if providerstate=="AL" & county=="Lee"
replace fips=4021 if providerstate=="AZ" & county=="Pinal"
replace fips=9001 if providerstate=="CT" & county=="Fairfield"
replace fips=12021 if providerstate=="FL" & county=="Collier"
replace fips=12103 if providerstate=="FL" & county=="Pinellas"
replace fips=13279 if providerstate=="GA" & county=="Toombs"
replace fips=17031 if providerstate=="IL" & county=="Cook"
replace fips=21125 if providerstate=="KY" & county=="Laurel"
replace fips=21217 if providerstate=="KY" & county=="Taylor"
replace fips=21213 if providerstate=="KY" & county=="Simpson"
replace fips=21193 if providerstate=="KY" & county=="Perry"
replace fips=20175 if providerstate=="KS" & county=="Seward"
replace fips=25017 if providerstate=="MA" & county=="Middlsex"
replace fips=25021 if providerstate=="MA" & county=="Norfolk"
replace fips=28151 if providerstate=="MS" & county=="Washington"
replace fips=37085 if providerstate=="NC" & county=="Harnett"
replace fips=37107 if providerstate=="NC" & county=="Lenoir"
replace fips=40047 if providerstate=="OK" & county=="Garfield"
replace fips=40097 if providerstate=="OK" & county=="Mayes"
replace fips=40121 if providerstate=="OK" & county=="Pittsburg"
replace fips=42045 if providerstate=="PA" & county=="Delaware"
replace fips=42071 if providerstate=="PA" & county=="Lancaster"
replace fips=48027 if providerstate=="TX" & county=="Bell"


drop if providerstate=="PR" | providerstate=="GU"

drop _merge


*****
merge m:m weekending fips using "C:\Users\jsemprini\Documents\c-polisci\stata_data\nyt_covid_masks_111720.dta"

*****NYT dataset treats NYC, Kansas City, and Joplin MO differently...so, adding county-level covarites specifically to city and zip****

drop if _merge==2
gen nyc=.
replace nyc=1 if _merge==1 & providerstate=="NY"

gen jop=.
foreach i in 06-28 07-05 07-12 07-19 07-26 08-02 08-09 08-16 08-23 08-30 09-06 09-13 09-20 09-27 10-04 10-11 10-18 10-25 11-01{
replace jop=1 if providerstate=="MO" & (county=="Jasper" | county=="Newton") & (weekending=="2020-`i'")

}

gen kc=.
foreach i in 64101	64102	64105	64106	64108	64109	64110	64111 64112	64113	64114	64116	64117	64118	64119	64120	64123	64124	64125	64126	64127	64128	64129	64130	64131	64132	64133	64134	64136	64137	64138	64139	64145	64146	64147	64149	64151	64152	64153	64154	64155	64156	64157	64158	64164	64165	64166	64167	64192{
replace kc=1 if zip==`i'

}



gen countykeep=""
replace countykeep="New York City" if nyc==1
replace countykeep="Joplin" if jop==1
replace countykeep="Kansas City" if kc==1


replace cases=cases2 if cases2!=.
replace deaths=deaths2 if deaths2!=.

drop month day year classfp never rarely sometimes frequently always mergemaskflag _merge jop kc countykeep nyc cases2 deaths2 never2 rarely2 sometimes2 frequently2 always2 keeper mergecases2
drop county_name2 state_abbr

rename providerstate state_abbr1
rename state_abbr1 state_abbr

order weekending provnum state state_abbr county fips zip owner

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_countycases_final.dta", replace


****rucca codes***
clear all
import delimited "C:\Users\jsemprini\Documents\c-polisci\raw_data\rucca_2013.csv"

gen metro=1
replace metro=0 if rucc_2013>3

gen rural=0
replace rural=1 if rucc_2013>7

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\rucca_111720.dta", replace

clear all
use "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_countycases_final.dta"
merge m:1 fips using "C:\Users\jsemprini\Documents\c-polisci\stata_data\rucca_111720.dta"
replace metro=1 if _merge==1
replace rural=0 if _merge==1
drop _merge

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_countycases_rucca_final.dta", replace

****add state policy data****
merge m:1 state_abbr using "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_pasrr_state_final.dta"

drop _merge
merge m:1 state_abbr using "C:\Users\jsemprini\Documents\c-polisci\stata_data\state_det.dta"

merge m:1 state using "C:\Users\jsemprini\Documents\federalism\statepop.dta"
drop if _merge==1
drop _merge

save "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_countycases_rucca_state_final.dta", replace







