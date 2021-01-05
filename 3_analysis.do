****Analysis for "How Did Covid-19 Emergency State Waivers Suspending Pre-Admission Screenings Impact Cases, Deaths, and Capacity in Skilled-Nursing Facilities?"

****Author: Jason Semprini, MPP****
****Note: Do-File runs w/out error with datafile in working directory****
****Date: 11/18/20****
****Hypothesis: Suspending PASRR is associated with outcomes****
****Claim: Previous studies fail to account for sample selection and endogeneity***
****Panel Models:
**1) LPM
**2) Probit
**3) Probit w/ Endog
**4) Probit w/ Treatment Endog
**5) Probit w/ Endog & Treatment Endog
**6) Probit w/ Selection
**7) Probit w/ Selection & Endog
**8) Probit w/ Selection & Treatment Endog
**9) Probit w/ Selection, Endog, & Treatment Endog
****Outputs: ****

****Initial Estimation for crude tables****

cd "C:\Users\jsemprini\Documents\c-polisci\stata_toanalyze"

set more off
  quietly log
  local logon = r(status)
  if "`logon'" == "on" { 
	log close 
	}
log using Semprini_PoliSciLog, replace text
clear all

use "semprini_polisci_project_toanalyze.dta"

gen cases_pc=cases/population_2010*100000

global outcomes admitcase_prob residentcases_prob coviddeaths_prob otherdeaths_prob staffshortage maskshortage hygeineshortage lacktest_cap lacktest_acc 

global timevariant_controls numberofallbeds perc_full cases_pc population_2010 

global snf_RE total_score baseline_vpn performance overall survey quality staffing incidents defs

global instrument pasrrcond_yes npasrrdefs med_spend_total history1135


egen panelid = group(provnum)


****1) Estimate linear probability model*****
xtset panelid week

foreach i in $outcomes {

eststo: xtreg `i' suspasrr $timevariant_controls if quality==1, vce(cluster statefips)

eststo: xtreg `i' suspasrr $timevariant_controls $snf_RE  if quality==1, vce(cluster statefips)

}

esttab using basicmodel_lpm.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear 

 ****2) Estimate probit model*****
 
foreach i in $outcomes {

eststo: xtprobit `i' suspasrr $timevariant_controls if quality==1, vce(cluster statefips)

eststo: xtprobit `i' suspasrr $timevariant_controls $snf_RE if quality==1, vce(cluster statefips)
}

esttab using basicmodel_probit.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear



****3) Estimate probit model, with endogenous covariate****
foreach i in $outcomes {

eststo: xteprobit `i' suspasrr $timevariant_controls if quality==1, endogenous(cases_pc = L.cases_pc) vce(cluster statefips)

eststo: xteprobit `i' suspasrr $timevariant_controls $snf_RE if quality==1, endogenous(cases_pc = L.cases_pc) vce(cluster statefips)
}

esttab using probit_endog.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear



****4) Estimate probit model, with endogenous treatment****
foreach i in $outcomes {

eststo: xteprobit `i' suspasrr $timevariant_controls  if quality==1, entreat(suspasrr = $instrument )  vce(cluster statefips)

eststo: xteprobit `i' suspasrr $timevariant_controls $snf_RE if quality==1, entreat(suspasrr = $instrument )  vce(cluster statefips)
}

esttab using probit_treatmentendog.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear


****5) Estimate probit model, with endogenous covariate and endogenous treatment****
foreach i in $outcomes {

eststo: xteprobit `i' suspasrr $timevariant_controls if quality==1, endogenous(cases_pc = L.cases_pc) entreat(suspasrr = $instrument )  vce(cluster statefips)

eststo: xteprobit `i' suspasrr $timevariant_controls $snf_RE if quality==1, endogenous(cases_pc = L.cases_pc) entreat(suspasrr = $instrument )  vce(cluster statefips)
}

esttab using probit_endog_treatmentendog.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear


****6) Estimate probit model, with selection****
foreach i in $outcomes {

eststo: xteprobit `i' suspasrr $timevariant_controls ,  select(submitted_quality =$snf_RE )  vce(cluster statefips)


eststo: xteprobit `i' suspasrr $timevariant_controls $snf_RE , select(submitted_quality =$snf_RE )  vce(cluster statefips)
}

esttab using probit_selection.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear


****7) Estimate probit model, with endogenous covariate and selection****
foreach i in $outcomes {

eststo: xteprobit `i' suspasrr $timevariant_controls , endogenous(cases_pc = L.cases_pc) select(submitted_quality =$snf_RE )  vce(cluster statefips)


eststo: xteprobit `i' suspasrr $timevariant_controls $snf_RE , endogenous(cases_pc = L.cases_pc) select(submitted_quality =$snf_RE )  vce(cluster statefips)

}

esttab using probit_select_endog.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear


****8) Estimate probit model, with selection and endogenous treatment****
foreach i in $outcomes {

eststo: xteprobit `i' suspasrr $timevariant_controls , select(submitted_quality =$snf_RE ) entreat(suspasrr = $instrument )  vce(cluster statefips)


eststo: xteprobit `i' suspasrr $timevariant_controls $snf_RE , select(submitted_quality =$snf_RE ) entreat(suspasrr = $instrument )  vce(cluster statefips)

}

esttab using probit_selection_treatmentendog.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear



****9) Estimate probit model, with selection, endogenous covariate and endogenous treatment****
foreach i in $outcomes {

eststo: xteprobit `i' suspasrr $timevariant_controls , select(submitted_quality =$snf_RE ) endogenous(cases_pc = L.cases_pc) entreat(suspasrr = $instrument )  vce(cluster statefips)


eststo: xteprobit `i' suspasrr $timevariant_controls $snf_RE , select(submitted_quality =$snf_RE ) endogenous(cases_pc = L.cases_pc) entreat(suspasrr = $instrument )  vce(cluster statefips)

}

esttab using probit_selection_endog_treatmentendog.csv, b(3) se(3) star(* 0.05 ** 0.01 *** 0.001) nogaps replace
eststo clear
