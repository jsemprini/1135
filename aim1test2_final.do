foreach v in suspendffs_preauth extendauth_phe sus_pasrr delay_appeal prov_enroll alt_set spa_waiver_tribal spa_waiver_deadlines pa_waive exped_prov_enroll evac_fac_alt hsbc_benefit{

eststo: reg `v'  history1135

eststo: reg `v'  pctpopover65 mmc_adults icu_pc totalhosp medicaid_tot_pct

eststo: reg `v'   med_spend_total_mil waiver1115 exp_health_mil exp_hospitals_mil

eststo: reg `v'   leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed 

eststo: reg `v'   demgub p_demsenate p_libcitizens

eststo: reg `v'   cases_pc deaths_pc

eststo: reg `v'   history1135 pctpopover65 mmc_adults icu_pc totalhosp medicaid_tot_pct  med_spend_total_mil waiver1115 exp_health_mil exp_hospitals_mil leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed demgub p_demsenate p_libcitizens cases_pc deaths_pc 
}


esttab using aim2testfinal.csv, b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) scalars(F df_m df_r p) r2 ar2 nogaps replace
eststo clear


***with time***
foreach v in suspendffs_preauth extendauth_phe sus_pasrr delay_appeal prov_enroll alt_set spa_waiver_tribal spa_waiver_deadlines pa_waive exped_prov_enroll evac_fac_alt hsbc_benefit{

eststo: reg `v'  history1135 normdate

eststo: reg `v'  pctpopover65 mmc_adults icu_pc totalhosp medicaid_tot_pct normdate

eststo: reg `v'   med_spend_total_mil waiver1115 exp_health_mil exp_hospitals_mil normdate

eststo: reg `v'   leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed normdate

eststo: reg `v'   demgub p_demsenate p_libcitizens normdate

eststo: reg `v'   cases_pc deaths_pc normdate

eststo: reg `v'   history1135 pctpopover65 mmc_adults icu_pc totalhosp medicaid_tot_pct  med_spend_total_mil waiver1115 exp_health_mil exp_hospitals_mil leg_realsalary leg_expend gubsalary gubstaff liv eo_phe_fed demgub p_demsenate p_libcitizens cases_pc deaths_pc  normdate
}


esttab using aim2testfinaltime.csv, b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) scalars(F df_m df_r p) r2 ar2 nogaps replace
eststo clear


