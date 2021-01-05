****Code Dataset for "How Did Covid-19 Emergency State Waivers Suspending Pre-Admission Screenings Impact Cases, Deaths, and Capacity in Skilled-Nursing Facilities?"

****Author: Jason Semprini, MPP****
****Date: 11/17/20****

clear all 

use "C:\Users\jsemprini\Documents\c-polisci\stata_data\cms_covid_snf_quality_countycases_rucca_state_final.dta"


****create numeric id*****
gen id=provnum
destring(id), force replace

order id

tab provnum if id==.

gen provnum2=provnum if id==.
tostring(provnum2), force replace

gen firsttwo=substr(provnum2,1,2)
gen lastthree=substr(provnum2,4,3)
gen newid=firsttwo+lastthree
destring(newid), force replace
replace id=newid if id==.

*****create numeric date*****
gen week=.
replace week=0 if weekending=="2020-05-24"
replace week=1 if weekending=="2020-05-31"
replace week=2 if weekending=="2020-06-07"
replace week=3 if weekending=="2020-06-14"
replace week=4 if weekending=="2020-06-21"
replace week=5 if weekending=="2020-06-28"
replace week=6 if weekending=="2020-07-05"
replace week=7 if weekending=="2020-07-12"
replace week=8 if weekending=="2020-07-19"
replace week=9 if weekending=="2020-07-26"
replace week=10 if weekending=="2020-08-02"
replace week=11 if weekending=="2020-08-09"
replace week=12 if weekending=="2020-08-16"
replace week=13 if weekending=="2020-08-23"
replace week=14 if weekending=="2020-08-30"
replace week=15 if weekending=="2020-09-06"
replace week=16 if weekending=="2020-09-13"
replace week=17 if weekending=="2020-09-20"
replace week=18 if weekending=="2020-09-27"
replace week=19 if weekending=="2020-10-04"
replace week=20 if weekending=="2020-10-11"
replace week=21 if weekending=="2020-10-18"
replace week=22 if weekending=="2020-10-25"
replace week=23 if weekending=="2020-11-01"



gen forprofit=.
replace forprofit=0 if owner=="Non profit - Other" | owner=="Non profit - Corporation" | owner=="Non profit - Church related" | owner=="Government - State" | owner=="Government - Hospital district" | owner=="Government - Federal" | owner=="Government - County" | owner=="Government - City/county" | owner=="Government - City" 
replace forprofit=1 if owner=="For profit - Corporation" | owner=="For profit - Individual" | owner=="For profit - Limited Liability company" | owner=="For profit - Partnership"

order week id state state_abbr county fips zip forprofit submitteddata passedqualityassurancecheck residentsweeklyadmissionscovid19 residentsweeklyconfirmedcovid19 residentsweeklysuspectedcovid19 residentsweeklyalldeaths residentsweeklycovid19deaths numberofallbeds totalnumberofoccupiedbeds testedresidentswithnewsignsorsym testedasymptomaticresidentsinaun testedasymptomaticresidentsfacil testedasymptomaticresidentswitho testedstaffandorpersonnelwithnew testedasymptomaticstaffandorpers tested_asymp_staff_case tested_asymp_staff_exposure staffweeklyconfirmedcovid19 staffweeklysuspectedcovid19 staffweeklycovid19deaths shortageofnursingstaff shortageofclinicalstaff shortageofaides shortageofotherstaff oneweeksupplyofn95masks oneweeksupplyofsurgicalmasks oneweeksupplyofeyeprotection oneweeksupplyofgowns oneweeksupplyofgloves oneweeksupplyofhandsanitizer ventilatordependentunit numberofventilatorsinfacility numberofventilatorsinuseforcovid oneweeksupplyofventilatorsupplie baseline_vpn performance overall survey quality staffing total_score incidents defs cases deaths population_2010 rucc_2013 description metro rural cmsdate newcmsdate thirty_afterfirst thirty_aftersecond suspasrr newpasrr no_pasrr pasrrcond_yes pasrr_total smi_yes smi_tot id_yes id_tot npasrrdefs med_spend_total history1135 popstate provnum2 firsttwo lastthree newid

*****begin coding outcome variables*****
gen submit=0
replace submit=1 if submitteddata=="Y"

gen qualityflag=0
replace qualityflag=1 if passedqualityassurancecheck=="Y"

gen submitted_quality=submit*qualityflag

gen admitcases_count=residentsweeklyadmissionscovid19 
gen admitcase_prob=0
replace admitcase_prob=1 if admitcases_count>0

gen residentcases_count=residentsweeklyconfirmedcovid19+residentsweeklysuspectedcovid19
gen residentcases_prob=0
replace residentcases_prob=1 if residentcases_count>0

gen coviddeaths_count=residentsweeklycovid19deaths
gen coviddeaths_prob=0
replace coviddeaths_prob=1 if coviddeaths_count>0
gen otherdeaths_count=residentsweeklyalldeaths
gen otherdeaths_prob=0
replace otherdeaths_prob=1 if otherdeaths_count>0

****6524 observations missing outcome data: changing to zero (flagged)****
gen missingflag=0
replace missingflag=1 if residentcases_count==. | coviddeaths_count==. | otherdeaths_count==.

replace residentcases_count=0 if residentcases_count==.
replace otherdeaths_count=0 if otherdeaths_count==.
replace coviddeaths_count=0 if coviddeaths_count==.



gen staffshortage=.
replace staffshortage=0 if shortageofnursingstaff=="N" | shortageofclinicalstaff=="N" |  shortageofaides=="N" |  shortageofotherstaff=="N" 
replace staffshortage=1 if shortageofnursingstaff=="Y" | shortageofclinicalstaff=="Y" |  shortageofaides=="Y" |  shortageofotherstaff=="Y" 

gen maskshortage=.
replace maskshortage=0 if oneweeksupplyofn95masks=="N" | oneweeksupplyofsurgicalmasks=="N" 
replace maskshortage=1 if oneweeksupplyofn95masks=="Y" | oneweeksupplyofsurgicalmasks=="Y" 

gen hygeineshortage=.
replace hygeineshortage=0 if oneweeksupplyofeyeprotection=="N" |  oneweeksupplyofgowns=="N" |  oneweeksupplyofgloves=="N" |  oneweeksupplyofhandsanitizer=="N" 
replace hygeineshortage=1 if oneweeksupplyofeyeprotection=="Y" |  oneweeksupplyofgowns=="Y" |  oneweeksupplyofgloves=="Y" |  oneweeksupplyofhandsanitizer=="Y" 

gen ventshortage=.
replace ventshortage=0 if oneweeksupplyofventilatorsupplie=="N"
replace ventshortage=1 if oneweeksupplyofventilatorsupplie=="Y"

save "C:\Users\jsemprini\Documents\c-polisci\early_toanalyze.dta", replace

clear all

use "C:\Users\jsemprini\Documents\c-polisci\early_toanalyze.dta"

***merge testing data***

merge m:1 provnum weekending using "C:\Users\jsemprini\Documents\c-polisci\stata_data\testdata.dta"

drop if _merge==2


****keep final data****
keep week id state state_abbr county fips zip forprofit numberofallbeds totalnumberofoccupiedbeds submit qualityflag submitted_quality residentcases_count residentcases_prob coviddeaths_count coviddeaths_prob otherdeaths_count otherdeaths_prob missingflag staffshortage maskshortage hygeineshortage ventshortage lacktest_cap lacktest_acc baseline_vpn performance overall survey quality staffing total_score incidents defs cases deaths population_2010 rucc_2013 metro rural thirty_afterfirst thirty_aftersecond suspasrr newpasrr no_pasrr pasrrcond_yes pasrr_total smi_yes smi_tot id_yes id_tot npasrrdefs med_spend_total history1135 popstate weekending provnum


order week id state state_abbr county fips zip forprofit numberofallbeds totalnumberofoccupiedbeds submit qualityflag submitted_quality residentcases_count residentcases_prob coviddeaths_count coviddeaths_prob otherdeaths_count otherdeaths_prob missingflag staffshortage maskshortage hygeineshortage ventshortage lacktest_cap lacktest_acc


gen perc_full=numberofallbeds/totalnumberofoccupiedbeds

gen first_pasrr=0
replace first_pasrr=1 if suspasrr==1 & newpasrr==0
gen second_pasrr=0
replace second_pasrr=1 if newpasrr==1


order week id fips zip forprofit numberofallbeds totalnumberofoccupiedbeds submit qualityflag perc_full submitted_quality residentcases_count residentcases_prob coviddeaths_count coviddeaths_prob otherdeaths_count otherdeaths_prob missingflag staffshortage maskshortage hygeineshortage ventshortage lacktest_cap lacktest_acc baseline_vpn performance overall survey quality staffing total_score incidents defs cases deaths population_2010 rucc_2013 metro rural thirty_afterfirst thirty_aftersecond suspasrr newpasrr no_pasrr pasrrcond_yes pasrr_total smi_yes smi_tot id_yes id_tot npasrrdefs med_spend_total history1135 popstate state state_abbr county

****reveise quality dataflag***
gen submit_quality=1
replace submit_quality=0 if submitteddata=="N" | passedqualityassurancecheck=="N" | passedqualityassurancecheck==""

gen qualityflag=0
replace qualityflag=1 if passedqualityassurancecheck=="Y"

gen submitted_quality=submit*qualityflag

sort id week 
quietly by id week: gen dup = cond(_N==1,0,_n)
drop if dup>0

egen panelid = group(provnum)


****1) Estimate linear probability model*****
xtset panelid week



save "C:\Users\jsemprini\Documents\c-polisci\stata_toanalyze\semprini_polisci_project_toanalyze.dta", replace



