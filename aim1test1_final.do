import delimited "C:\Users\jsemprini\Documents\federalism\waivercontent.csv"
save "C:\Users\jsemprini\Documents\federalism\waivercontent.dta"

clear all

import delimited "C:\Users\jsemprini\Documents\federalism\us-states.csv"

save "C:\Users\jsemprini\Documents\federalism\statecases.dta"

tab state
tab date

clear all

import delimited "C:\Users\jsemprini\Documents\federalism\date.csv", varnames(1) encoding(ISO-8859-2) 

save "C:\Users\jsemprini\Documents\federalism\dates.dta", replace

clear all

import delimited "C:\Users\jsemprini\Documents\federalism\stateabr.csv", varnames(1) 

cross using "C:\Users\jsemprini\Documents\federalism\dates.dta"

save "C:\Users\jsemprini\Documents\federalism\statedate.dta", replace

clear all

. use "C:\Users\jsemprini\Documents\federalism\statecases.dta"

. rename state statename

. save "C:\Users\jsemprini\Documents\federalism\statecases.dta", replace

clear all

use "C:\Users\jsemprini\Documents\federalism\statedate.dta"

merge 1:1 statename date using "C:\Users\jsemprini\Documents\federalism\statecases.dta"

drop if _merge==2

drop _merge

save "C:\Users\jsemprini\Documents\federalism\statedatecase.dta"

use "C:\Users\jsemprini\Documents\federalism\statedatecase.dta"

replace cases=0 if cases==.
replace deaths=0 if deaths==.

****add fips to WV 3/13-3/16***
. merge m:1 statename using "C:\Users\jsemprini\Documents\federalism\statepop.dta"
drop _merge

gen cases_pc=(cases/popstate)*100000
gen deaths_pc=(deaths/popstate)*100000

gen negdate=-normdate

bysort state (negdate): carryforward fips, gen(fips2)

replace fips=fips2 if fips==.
drop fips2 negdate

***issue with NH date (2002)***

merge 1:1 state date using "C:\Users\jsemprini\Documents\federalism\statereqdate.dta"

drop if statename==""

gen waiver=1 if request==1

sort state normdate

bysort state: carryforward waiver, gen (waiver1)

drop _merge

replace waiver1=0 if waiver1==.

gen waiver2=.
replace waiver2=0 if waiver1==0
replace waiver2=1 if waiver==1

merge m:1 state using "C:\Users\jsemprini\Documents\federalism\waiverhistory.dta"

replace history1135=0 if history==.
replace count1135=0 if count1135==.

drop _merge

gen multi1135=0
replace multi1135=1 if count1135>1

gen total1135=0
replace total1135=1 if count1135==1
replace total1135=2 if count1135>1

merge m:1 fips using "C:\Users\jsemprini\Documents\federalism\dettomerge.dta"
drop _merge
merge m:1 statename using "C:\Users\jsemprini\Documents\federalism\statenetworks.dta"
drop _merge

save "C:\Users\jsemprini\Documents\federalism\1.data.aim1.test1_final.dta"

****prev code includes merge-region***

merge m:1 region normdate using "C:\Users\jsemprini\Documents\federalism\regionpopcovidwaiver.dta", generate(_merge3)

merge m:1 region using "C:\Users\jsemprini\Documents\federalism\regionpop.dta", generate(_merge4)

drop _merge4 _merge _merge2 _merge3

gen regcases_pc=(regcases/popreg)*100000
gen regdeaths_pc=(regdeaths/popreg)*100000


***fix utah****

replace request=1 if state=="UT" & normdate==75
replace waiver1=1 if state=="UT" & normdate>=75
replace waiver2=1 if state=="UT" & normdate==75


merge m:1 state using "C:\Users\jsemprini\Documents\federalism\demgub.dta"
drop if _merge==2
drop _merge

****prep analysis*****
****non-panel****
drop if normdate<51
replace normdate=normdate-51
drop if normdate>36


xtset fips normdate
stset normdate, failure(waiver2==1)

gen exp_health_mil=exp_health/1000
gen exp_hospitals_mil=exp_hospitals/1000
gen med_spend_total_mil=med_spend_total/1000

***fix KS, IN***
replace normdate=8 if state=="KS"
replace normdate=7 if state=="IN"
replace request=1 if state=="NH" & normdate==6
replace waiver2=1 if state=="NH" & normdate==6
replace waiver1=1 if state=="NH" & normdate>=6

drop if waiver2!=1

save "C:\Users\jsemprini\Documents\federalism\1.data.aim1.test1_toanalyze_final.dta"

clear all


********************************************
****begin non-panel analysis****

use "C:\Users\jsemprini\Documents\federalism\1.data.aim1.test1_toanalyze_final.dta"

set scheme meta


***1: KM Failure Curve and Test***
sts graph, failure by(history1135) ytitle(Submit 1135 Waiver Request) xtitle(Days Since Emergency Waiver Declaration) legend(position(6))

sts test history1135, logrank

sts graph, failure by(multi1135) ytitle(Submit 1135 Waiver Request) xtitle(Days Since Emergency Waiver Declaration) legend(position(6))

sts test multi1135, logrank


***2: Cox PH***
stcox history1135
estat phtest
stphplot, by(history1135)

stcox multi1135
estat phtest
stphplot, by(multi1135)


***3: weibull ATF w/ multi-level effects***
mestreg history1135 || fips:, distribution(gamma) tratio vce(cluster fips)
mestreg multi1135 || fips:, distribution(gamma) tratio vce(cluster fips)

***4: cox seperate models****
stcox  pctpopover65 mmc_adults icu_pc totalhosp medicaid_tot_pct
estat phtest

stcox med_spend_total_mil waiver1115 exp_health_mil exp_hospitals_mil
estat phtest

stcox leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed 
estat phtest

stcox demgub p_demsenate p_libcitizens
estat phtest

stcox cases_pc deaths_pc newregwaiver
estat phtest

***best***
stcox history1135 pctpopover65 mmc_adults icu_pc totalhosp medicaid_tot_pct  med_spend_total_mil waiver1115 exp_health_mil exp_hospitals_mil leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed demgub p_demsenate p_libcitizens cases_pc deaths_pc newregwaiver
estat phtest




***5: weibull ATF w/ multilevel effects***


mestreg pctpopover65 mmc_adults icu_pc totalhosp medicaid_tot_pct || fips:, distribution(gamma) time tratio vce(cluster fips)

mestreg med_spend_total_mil waiver1115 exp_health_mil exp_hospitals_mil || fips:, distribution(gamma) time tratio vce(cluster fips)

mestreg leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed  || fips:, distribution(exponential) time tratio vce(cluster fips)

mestreg demgub p_demsenate p_libcitizens || fips:, distribution(gamma) time tratio vce(cluster fips)

mestreg cases_pc deaths_pc newregwaiver || fips:, distribution(gamma) time tratio vce(cluster fips)


mestreg history1135 pctpopover65 mmc_adults icu_pc totalhosp medicaid_tot_pct  med_spend_total_mil waiver1115 exp_health_mil exp_hospitals_mil leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed demgub p_demsenate p_libcitizens cases_pc deaths_pc newregwaiver || fips:, distribution(gamma) tratio vce(cluster fips)

******create pca*******
drop pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc med_spend_total waiver1115 exp_health exp_hospitals v16 v17 sess_length leg_realsalary leg_expend legprofscore gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens policy_lib_score

merge m:1 statename using "C:\Users\jsemprini\Documents\federalism\fulldettomerge.dta"
drop if _merge==2
drop _merge

destring(govhosp), force replace
destring(profithosp), force replace

pca history1135 newregwaiver regcases regdeaths popreg regcases_pc regdeaths_pc
predict pca_ext

pca total_pop pctwhite unemployment pctpopover65 mmc_adults medicaid_tot_pct
predict pca_demand

pca govhosp nfphosp profithosp totalhosp crudehosp all_icu icu_pc
predict pca_supply

pca exp_health exp_hospitals med_spend_adult med_spend_aged med_spend_child med_spend_disab med_spend_total waiver1115 count1115
predict pca_agency

pca sess_length leg_realsalary leg_expend legprofscore 
predict pca_leg

pca gubsalary gubstaff liv ex_auth ph_em_auth fedresp_auth appointedag appointedinscom
predict pca_gub

pca demgub p_demsenate p_demhouse p_libcitizens policy_lib_score
predict pca_lib


******survival analysis*****

stcox pca_demo pca_demand pca_supply pca_agency pca_leg pca_gub pca_lib pca_ext
estat phtest
mestreg pca_demo pca_demand pca_supply pca_agency pca_leg pca_gub pca_lib pca_ext|| fips:, distribution(weibull) time tratio







*****begin test 2******
merge m:1 state using "C:\Users\jsemprini\Documents\federalism\waivercontent.dta"
drop if _merge==2
drop _merge


gen full1135=0 
replace full1135=1 if suspendffs_preauth==1 & extendauth_phe==1 &  sus_pasrr==1 &  delay_appeal==1 &  prov_enroll==1 &  alt_set==1

gen extra1135=0
replace extra1135=1 if spa_waiver_tribal==1 | spa_waiver_deadlines==1 |  pa_waive==1 |  exped_prov_enroll==1 |  evac_fac_alt==1 |  hsbc_benefit==1 



gen gubpower=0
replace gubpower=1 if liv==1 & eo_phe_fed==1

gen dateweight=1/normdate

****begin pca****

foreach v in count_reg full1135 extra1135 suspendffs_preauth extendauth_phe delay_appeal prov_enroll alt_set  sus_pasrr{

eststo: reg `v'  pca_ext pca_demand pca_supply pca_agency pca_leg pca_gub pca_lib 

}


esttab using pcadet.csv, b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) nogaps replace
eststo clear

***count***

ologit  count_reg c.normdate##c.(history pca_ext pca_demand pca_supply pca_agency pca_leg pca_gub pca_lib), or


foreach v in count_reg full1135 extra1135 suspendffs_preauth extendauth_phe delay_appeal prov_enroll alt_set  sus_pasrr{

eststo: reg `v'  c.normdate##c.(history pca_ext pca_demand pca_supply pca_agency pca_leg pca_gub pca_lib)

}


esttab using pcadet2.csv, b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) nogaps replace
eststo clear
