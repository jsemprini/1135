****Final AH*****
clear all

use "C:\Users\jsemprini\Documents\federalism\2.0analysis\1.prelim-pasrr.dta" 

xtset fips day

gen testpasrr=waiver1*sus_pasrr
gen testanymedicaid=anymedicaid*waiver1
gen testanyfh=anyfh*waiver1 
gen testanyprov=anyprov*waiver1
replace defsp_nf=0 if state=="TX"
gen nhbeds_2p65=nhbeds_p65/100000
gen defsp_res=anydefs/avgres_day
gen defsp_2res=defsp_res*100000
gen avgscreen=pasrr_total/avgres_day
gen fp_beds=ncertbeds*propr_fp
gen inhosp_beds=prop_inhosp*ncertbeds
gen res_bed=avgres_day/ncertbeds
gen over65=popstate*(pctpopover65/100)
replace over65=over65/100000
gen n_fp=(ninhosp/prop_inhosp)*propr_fp

replace npasrrdefs=0 if state=="TX"

gen ndefs_pbed=npasrrdefs/ncertbeds
replace ndefs_pbed=ndefs_pbed*100

***RE/FE***
xtreg deaths_pc testpasrr cases_pc popstate pctpopover65
estimates store re_1

xtreg deaths_pc testpasrr cases_pc popstate pctpopover65, fe 
estimates store fe_1

hausman fe_1 re_1

xtreg deaths_pc c.testpasrr#c.(res_bed nhbeds_2p65 fp_beds inhosp_beds avgscreen ndefs_pbed) cases_pc popstate pctpopover65
estimates store re_2

xtreg deaths_pc c.testpasrr#c.(res_bed nhbeds_2p65 fp_beds inhosp_beds avgscreen ndefs_pbed) cases_pc popstate pctpopover65, fe
estimates store fe_2

hausman fe_2 re_2

***cluster robust***
xtreg deaths_pc testpasrr cases_pc popstate pctpopover65, vce(cluster fips)
estimates store crre_1

xtreg deaths_pc testpasrr cases_pc popstate pctpopover65, fe vce(cluster fips)
estimates store crfe_1

esttab crre_1 crfe_1 using t1.csv, replace


xtreg deaths_pc c.testpasrr#c.(res_bed nhbeds_2p65 fp_beds inhosp_beds avgscreen ndefs_pbed) cases_pc popstate pctpopover65, vce(cluster fips)
estimates store crre_2

xtreg deaths_pc c.testpasrr#c.(res_bed nhbeds_2p65 fp_beds inhosp_beds avgscreen ndefs_pbed) cases_pc popstate pctpopover65, fe vce(cluster fips)
estimates store crfe_2

coefplot crre_2 crfe_2, drop(cases_pc popstate pctpopover65 _cons) xline(0) vertical 

****flip capacity****
gen bedcap=1-res_bed
xtreg deaths_pc c.testpasrr#c.(bedcap nhbeds_2p65 fp_beds inhosp_beds avgscreen ndefs_pbed) cases_pc popstate pctpopover65, vce(cluster fips)
estimates store crre_3

xtreg deaths_pc c.testpasrr#c.(bedcap nhbeds_2p65 fp_beds inhosp_beds avgscreen ndefs_pbed) cases_pc popstate pctpopover65, fe vce(cluster fips)
estimates store crfe_3

coefplot crre_3, drop(cases_pc popstate pctpopover65 _cons) xline(0) xlabel(, labsize(vsmall)) ylabel(, grid) /// 
		xtitle("Marginal Effect on Deaths Per Capita", size(small)) /// 
		ytitle("") /// 
		title("Identifying Heterogeneous Effects of Suspending PASRR", size(small))  xsc(r(-10 .10)) /// 
		legend(off)
		
collapse total deaths popstate, by(testpasrr day) 	

		

twoway (connected deaths_pc day if testpasrr==1, sort) (connected deaths_pc day if testpasrr==0, sort lcolor(navy)), xline(45, lwidth(thin) lpattern(dash))
graph export "C:\Users\jsemprini\Documents\federalism\f2.tif", as(tif) name("Graph")