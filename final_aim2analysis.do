*********AIM 2 ANALYSIS************
clear all
 use "C:\Users\jsemprini\Documents\federalism\aim2impact\covidcounties_toanalyze.dta"
 
 gen regday=day if waiver==1
 
 sort state day
bysort state: carryforward regday, gen(regday2)
gen negday=-day

sort state negday
bysort state: carryforward regday, gen(regday3)
 
 replace regday2=regday3 if regday2==. & regday3!=.
 
 gen normdate=day-regday2
 
 sort state normdate
 
 gen rural=0
 replace rural=1 if rucca>=7
 gen metro=0
 replace metro=1 if rucca<=3
 
 order normdate rural metro
 
 xtset countyfips day
 
 
 
 ***************************fix cases/deaths, gen pscore, gen IV***********************
 replace cases_pc=(cases/popstate)*100000
replace cases_pc=0 if cases_pc==.
replace deaths_pc=(deaths/popstate)*100000
replace deaths_pc=0 if deaths_pc==.

logit waiver1 history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil, asis
predict ps1, xb
gen ps_odds=exp(ps1)
gen pscore=ps_odds/(1+ps_odds)

reg count_reg history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil
predict count_reg_hat, xb


duplicates tag countyfips day, gen(dup_id)
tab dup_id
drop if dup_id>0

************by full/extra waiver*********
gen full1135=0
replace full1135=1 if suspendffs_preauth==1 & extendauth_phe==1 &  sus_pasrr==1 &  delay_appeal==1 &  prov_enroll==1 & alt_set==1

gen extra1135=0
replace extra1135=1 if spa_waiver_tribal==1 |  spa_waiver_deadlines==1 |  pa_waive==1 |  exped_prov_enroll==1 |  evac_fac_alt==1 |  hsbc_benefit==1 


****create bandwidth*****

gen late_bw=0
replace late_bw=1 if normdate>=-6 & normdate<=6

gen half_bw=0
replace half_bw=1 if normdate>=-3 & normdate<=3

gen double_bw=0
replace double_bw=1 if normdate>=-13 & normdate<=13

xtset countyfips day
********************final analysis*************************
foreach bw in late_bw half_bw double_bw{
eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.full1135, vce(cluster countyfips)
eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.full1135 if rural==0, vce(cluster countyfips)
eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.full1135 if rural==1, vce(cluster countyfips)

eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.extra1135, vce(cluster countyfips)
eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.extra1135 if rural==0, vce(cluster countyfips)
eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.extra1135 if rural==1, vce(cluster countyfips)

eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135, vce(cluster countyfips)
eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 if rural==0, vce(cluster countyfips)
eststo: xtreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 if rural==1, vce(cluster countyfips)

}


esttab using fereg_deaths.csv, b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) nogaps replace
eststo clear

foreach bw in late_bw half_bw double_bw{
eststo: reg countydeaths_pc c.normdate##c.`bw'##c.full1135 i.fips i.day[aweight=invpscore], vce(cluster countyfips)
eststo: reg countydeaths_pc c.normdate##c.`bw'##c.full1135 i.fips i.day[aweight=invpscore]if rural==0, vce(cluster countyfips)
eststo: reg countydeaths_pc c.normdate##c.`bw'##c.full1135 i.fips i.day[aweight=invpscore]if rural==1, vce(cluster countyfips)

eststo: reg countydeaths_pc c.normdate##c.`bw'##c.extra1135 i.fips i.day[aweight=invpscore], vce(cluster countyfips)
eststo: reg countydeaths_pc c.normdate##c.`bw'##c.extra1135 i.fips i.day[aweight=invpscore]if rural==0, vce(cluster countyfips)
eststo: reg countydeaths_pc c.normdate##c.`bw'##c.extra1135 i.fips i.day[aweight=invpscore]if rural==1, vce(cluster countyfips)

eststo: reg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 i.fips i.day[aweight=invpscore], vce(cluster countyfips)
eststo: reg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 i.fips i.day[aweight=invpscore]if rural==0, vce(cluster countyfips)
eststo: reg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 i.fips i.day[aweight=invpscore]if rural==1, vce(cluster countyfips)
}


esttab using pscore_deaths.csv, b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) nogaps replace
eststo clear



foreach bw in late_bw half_bw double_bw{
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135 (waiver1=history1135), vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135 (waiver1=history1135)if rural==0, vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135 (waiver1=history1135)if rural==1, vce(cluster countyfips)

eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.extra1135 (waiver1=history1135), vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.extra1135 (waiver1=history1135)if rural==0, vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.extra1135 (waiver1=history1135)if rural==1, vce(cluster countyfips)

eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135  (waiver1=history1135), vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 (waiver1=history1135)if rural==0, vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 (waiver1=history1135)if rural==1, vce(cluster countyfips)
}


esttab using ivreg_deaths.csv, b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) nogaps replace
eststo clear


foreach bw in late_bw half_bw double_bw{
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135 (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil), vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135 (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil)if rural==0, vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135 (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil)if rural==1, vce(cluster countyfips)

eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.extra1135 (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil), vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.extra1135 (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil)if rural==0, vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.extra1135 (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil)if rural==1, vce(cluster countyfips)

eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135  (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil), vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil)if rural==0, vce(cluster countyfips)
eststo: xtivreg countydeaths_pc c.normdate##c.`bw'##c.full1135##c.extra1135 (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil)if rural==1, vce(cluster countyfips)
}


esttab using fullivreg_deaths.csv, b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) nogaps replace
eststo clear





********************tests**********************************


xtivreg countydeaths_pc c.normdate##c.late_bw##c.count_reg (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil)

xtivreg countydeaths_pc c.normdate##c.late_bw##c.count_reg (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil) if rural==0


xtivreg countydeaths_pc c.normdate##c.late_bw##c.count_reg (waiver1=history1135 multi1135 pctpopover65 mmc_adults medicaid_tot_pct medicare_tot med_enroll_total totalhosp icu_pc waiver1115 leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed p_demsenate p_demhouse p_libcitizens demgub exp_health_mil exp_hospitals_mil med_spend_total_mil) if rural==1