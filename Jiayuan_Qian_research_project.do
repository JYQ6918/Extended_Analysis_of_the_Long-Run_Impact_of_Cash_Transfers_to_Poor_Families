capture log close

log using "Jiayuan_Qian_Research_Paper.log", replace

clear all
clear mata
set more 1
set memory 500m
set matsize 5000
program drop _all


use MP_data, replace

****** Global macros ******
global mom "divorced husbandaway marst_miss"
global kid "childageyears length_name sib2-sib8  maxage minage"
global county10 "sei_mean sei_sd p_urban p_widows children_singlemom poverty fem_lfp child_labor val_farm"
global countyd "CID2-CID75"
global match "datemiss"
global state "S2-S11"
global state_year "manwrat ageent labage contschl gen_total char_tot tot_edu_schools work_required limited_duration  monthlyallowfirstchild monthlyallowaddchild"
global state_year2 "manwrat ageent labage contschl gen_total char_tot tot_edu_schools  work_required limited_duration  monthlyallowfirstchild monthlyallowaddchild"
global cohort "yob1 yob2"
global cohortd "BY2-BY26"
global det "year yob childageyears datemiss numkids  maxage minage length_name widow divorced husbandaway marst_miss famearn miss nmatches keepssn ageatdeath2 logageatdeath"
global det2 "year yob childageyears datemiss numkids  maxage minage length_name widow divorced husbandaway marst_miss famearn miss nmatches"

****** Measure ATE for people in different states ******

*** table 1
*** ATE for people in Wisconsin
preserve
keep if nmatches==1 

sum ageatdeath2 if ~accepted & state == "Wisconsin"
local M=r(mean)

reg logageatdeath accepted $state $cohortd if state == "Wisconsin", cluster(fips)
outreg2  using Table13,  br se bdec(4) replace excel keep(accepted) addstat(Mean, `M') ctitle("Age at death state and cohort FE") title("Age at death in Wisconsin")

reg logageatdeath accepted $kid  $mom  $match $county10 $state_year $cohortd if state == "Wisconsin", cluster(fips)
outreg2  using Table13,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death all controls no county FE")

reg logageatdeath accepted $kid  $mom  $match $countyd $state_year $cohortd if state == "Wisconsin", cluster(fips)
outreg2  using Table13,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death county FE")

reg logageatdeath_sa accepted $kid  $mom  $match $countyd $state_year $cohortd if state == "Wisconsin", cluster(fips)
outreg2  using Table13, br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death SSA DOB")



*** ATE for people in North Dakota
keep if nmatches==1 

sum ageatdeath2 if ~accepted & state == "North Dakota"
local M=r(mean)

reg logageatdeath accepted $state $cohortd if state == "North Dakota", cluster(fips)
outreg2  using Table11,  br se bdec(4) replace excel keep(accepted) addstat(Mean, `M') ctitle("Age at death state and cohort FE") title("Age at death in North Dakota")

reg logageatdeath accepted $kid  $mom  $match $county10 $state_year $cohortd if state == "North Dakota", cluster(fips)
outreg2  using Table11,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death all controls no county FE")

reg logageatdeath accepted $kid  $mom  $match $countyd $state_year $cohortd if state == "North Dakota", cluster(fips)
outreg2  using Table11,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death county FE")

reg logageatdeath_sa accepted $kid  $mom  $match $countyd $state_year $cohortd if state == "North Dakota", cluster(fips)
outreg2  using Table11, br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death SSA DOB")

*** ATE for people in Oregon
keep if nmatches==1 

sum ageatdeath2 if ~accepted & state == "Oregon"
local M=r(mean)

reg logageatdeath accepted $state $cohortd if state == "Oregon", cluster(fips)
outreg2  using Table12,  br se bdec(4) replace excel keep(accepted) addstat(Mean, `M') ctitle("Age at death state and cohort FE") title("Age at death in Oregon")

reg logageatdeath accepted $kid  $mom  $match $county10 $state_year $cohortd if state == "Oregon", cluster(fips)
outreg2  using Table12,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death all controls no county FE")

reg logageatdeath accepted $kid  $mom  $match $countyd $state_year $cohortd if state == "Oregon", cluster(fips)
outreg2  using Table12,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death county FE")

reg logageatdeath_sa accepted $kid  $mom  $match $countyd $state_year $cohortd if state == "Oregon", cluster(fips)
outreg2  using Table12, br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("Age at death SSA DOB")




****** replicate table 4 using regression adjustment and ipw ******

*** table 2

** unique matches using teffects ra
* Column 1
keep if nmatches==1

sum ageatdeath2 if ~accepted 
estadd local M = r(mean), replace
* ereturn list

teffects ra (logageatdeath $state $cohortd) (accepted), vce(robust)
est store model1



* 2

keep if nmatches==1

teffects ra (logageatdeath $kid  $mom  $match $county10 $state_year $cohortd) (accepted), vce(robust)
est store model2




* 3

keep if nmatches==1


teffects ra (logageatdeath $kid  $mom  $match $countyd $state_year $cohortd) (accepted), iter(20) vce(robust)
est store model3




* 4

keep if nmatches==1

teffects ra (logageatdeath_sa $kid  $mom  $match $countyd $state_year $cohortd) (accepted), iter(20) vce(robust)
est store model4

esttab _all using table21.csv, se(3) keep(r1vs0.accepted) replace star(* 0.10 ** 0.05 *** 0.01) label coef(r1vs0.accepted "Accepted") mtitle("State Cohort FE" "Controlled Characteristics" "County FE" "age_dc") title("Replicated Cash Transfer Effect Using Regression Adjustment")





** unique matches using teffect ipw

* Column 1

keep if nmatches==1

teffects ipw (logageatdeath) (accepted $state $cohortd), vce(robust)
est store model21

* 2

keep if nmatches==1

teffects ipw (logageatdeath) (accepted $kid  $mom  $match $county10 $state_year $cohortd), vce(robust)
est store model22

* 3

keep if nmatches==1

teffects ipw (logageatdeath) (accepted $kid  $mom  $match $countyd $state_year $cohortd), pstolerance(1.00e-10) iter(20) vce(robust)
est store model23



* 4

keep if nmatches==1

teffects ipw (logageatdeath_sa) (accepted $kid  $mom  $match $countyd $state_year $cohortd), pstolerance(1.00e-10) iter(20) vce(robust)
est store model24


esttab _all using table31.csv, se(3) keep(r1vs0.accepted) replace star(* 0.10 ** 0.05 *** 0.01) label coef(r1vs0.accepted "Accepted") mtitle("State Cohort FE" "Controlled Characteristics" "County FE" "age_dc") title("Replicated Cash Transfer Effect Using Inverse Probability Weighting")


****** estimate ATT ******

*** table 3

** Obtain ATT with teffects ra
* 1
keep if nmatches==1

teffects ra (logageatdeath $state $cohortd) (accepted), atet
est store model31

* 2

keep if nmatches==1

teffects ra (logageatdeath $kid  $mom  $match $county10 $state_year $cohortd) (accepted), atet vce(robust)
est store model32

* 3

keep if nmatches==1

teffects ra (logageatdeath $kid  $mom  $match $countyd $state_year $cohortd) (accepted), iter(20) vce(robust) atet
est store model33

* 4

keep if nmatches==1

teffects ra (logageatdeath_sa $kid  $mom  $match $countyd $state_year $cohortd) (accepted), iter(20) vce(robust) atet
est store model34


esttab _all using table41.csv, se(3) keep(r1vs0.accepted) replace star(* 0.10 ** 0.05 *** 0.01) label coef(r1vs0.accepted "Accepted") mtitle("State Cohort FE" "Controlled Characteristics" "County FE" "age_dc") title("Cash Transfer ATT Regression Adjustment")



** Obtain ATT with ipw

* Column 1

keep if nmatches==1

teffects ipw (logageatdeath) (accepted $state $cohortd), atet vce(robust)
est store model41

* 2

keep if nmatches==1

teffects ipw (logageatdeath) (accepted $kid  $mom  $match $county10 $state_year $cohortd), atet vce(robust)
est store model42

* 3

keep if nmatches==1

teffects ipw (logageatdeath) (accepted $kid  $mom  $match $countyd $state_year $cohortd), pstolerance(1.00e-10) iter(20) atet vce(robust)
est store model43



* 4

keep if nmatches==1

teffects ipw (logageatdeath_sa) (accepted $kid  $mom  $match $countyd $state_year $cohortd), pstolerance(1.00e-10) iter(20) atet vce(robust)
est store model44

esttab _all using table51.csv, se(3) keep(r1vs0.accepted) replace star(* 0.10 ** 0.05 *** 0.01) label coef(r1vs0.accepted "Accepted") mtitle("State Cohort FE" "Controlled Characteristics" "County FE" "age_dc") title("Cash Transfer ATT Using Regression Adjustment IPW")



****** sensitivity analysis ******

*** table 4

** Column 1 of Table 4 in the original paper

keep if nmatches==1 

sum ageatdeath2 if ~accepted 
local M=r(mean)


reg logageatdeath accepted $state $cohortd, cluster(fips)
outreg2  using table6,  br se bdec(4) replace excel keep(accepted) addstat(Mean, `M') ctitle("original model") title("Sensitivity Analysis")

reg logageatdeath accepted $state $cohortd $mom, cluster(fips)
outreg2  using table6,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("mom characteristics") title("Sensitivity Analysis")

reg logageatdeath accepted $state $cohortd $mom $kid, cluster(fips)
outreg2  using table6,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("kid characteristics") title("Sensitivity Analysis")

reg logageatdeath accepted $state $cohortd $mom $kid year, cluster(fips)
outreg2  using table6,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("year of MP application") title("Sensitivity Analysis")

reg logageatdeath accepted $state $cohortd $mom $kid year widow, cluster(fips)
outreg2  using table6,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("widow dummy") title("Sensitivity Analysis")


*** table 5

** Column 2-4 of Table 4 in the original paper
keep if nmatches==1 

sum ageatdeath2 if ~accepted 
local M=r(mean)

reg logageatdeath accepted $kid  $mom  $match $county10 $state_year $cohortd, cluster(fips) 
outreg2  using Table7,  br se bdec(4) replace excel keep(accepted) addstat(Mean, `M') ctitle("All controls no county FE") title("Sensitivity Analysis Column 2-4")

reg logageatdeath accepted $kid  $mom  $match $countyd $state_year $cohortd, cluster(fips) 
outreg2  using Table7,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("County FE")

reg logageatdeath_sa accepted $kid  $mom  $match $countyd $state_year $cohortd, cluster(fips) 
outreg2  using Table7, br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("SSA DOB")



reg logageatdeath accepted childageyears sib2-sib8  maxage minage  divorced husbandaway $county10 ageent labage contschl gen_total char_tot tot_edu_schools work_required limited_duration  monthlyallowfirstchild monthlyallowaddchild $cohortd, cluster(fips) 
outreg2  using Table7,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("All controls no county FE with Covariates dropped")

reg logageatdeath accepted childageyears sib2-sib8  maxage minage  divorced husbandaway $countyd ageent labage contschl gen_total char_tot tot_edu_schools work_required limited_duration  monthlyallowfirstchild monthlyallowaddchild $cohortd, cluster(fips) 
outreg2  using Table7,  br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("County FE with Covariates dropped")

reg logageatdeath_sa accepted childageyears sib2-sib8  maxage minage  divorced husbandaway $countyd ageent labage contschl gen_total char_tot tot_edu_schools work_required limited_duration  monthlyallowfirstchild monthlyallowaddchild $cohortd, cluster(fips) 
outreg2  using Table7, br se bdec(4) append excel keep(accepted) addstat(Mean, `M') ctitle("DOB on death certificate with Covariates dropped")



log close










