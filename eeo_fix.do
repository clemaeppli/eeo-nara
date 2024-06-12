/*************************************************************
* eeo_fix.do
* Updated 2.7.2024
* Clem Aeppli
* 
* Corrects issues with EEO data from Archives.	
 	IN:
		eeo_text/dta_format/eeo.dta
	OUT:
		eeo_text/dta_format/eeo_fixed.dta		
*************************************************************/


clear all

global PATH_EEO "C:/Users/caaep/Documents/EEO"
cd "$PATH_EEO"


// List of occupation names in order in the Archives data:
global occs_ascii "mngr prof tech sale cler craf oper labr srvc tot prev"
// Demographic names in Archives:
global dems_ascii "white black hisp asian amind" 
// Demographic names in Nate data:
global dems_eeof "wh blk hisp asian aian"



log using "$PATH_EEO/eeo_fix_log.txt", text replace

use  "$PATH_EEO/dta_format/eeo.dta", clear 



/*********************************************
* Part 1: Edits to 1978.
* In 1978 a bunch of variables seem to have been 
* labeled incorrectly. I identified the switches 
* by comparing to a firm-level copy (not included)
*********************************************/

// Macros of all the changes we need to make:
// format is true_<name of actual quantity> <what it was labeled as>
global true_white_m tot_m
global true_hisp_m black_m
global true_black_m tot_f

global true_white_f hisp_m
global true_hisp_f asian_f
global true_asian_f amind_f
global true_amind_f hisp_f

global change_list ///
 white_m hisp_m black_m ///
 white_f hisp_f asian_f amind_f

// Create temp variables to swap out values:
foreach v in $change_list {
	foreach o in $occs_ascii {
		disp "Replacing M_`v'_`o' <-- M_${true_`v'}_`o'"
		gen temp_`v'_`o' = M_${true_`v'}_`o' if year == 1978
	}
}
// Assign correct values to the corresponding labels:
foreach v in $change_list {
	foreach o in $occs_ascii {
		replace M_`v'_`o' = temp_`v'_`o' if year == 1978
	}
}
drop temp_*

// Recalculate the occup-ethnicity totals:
foreach r in white black hisp asian amind {
	foreach o in $occs_ascii {
		replace M_`r'_t_`o' = M_`r'_f_`o' + M_`r'_m_`o' if year == 1978
	}
}
// Recalculate the occup-gender totals:
foreach g in f m t {
	foreach o in $occs_ascii {
		replace M_tot_`g'_`o' = M_white_`g'_`o' + M_black_`g'_`o' + M_hisp_`g'_`o' + M_asian_`g'_`o' + M_amind_`g'_`o' if year == 1978
	}
}


/*********************************************
* Part 2: Edits to other years.
*********************************************/

// For each ethnicity-occupation group, the gender total columns 
// (*_t_*) are wrong/empty pre 1990. Replace with sum of 
// male + female for each ethnicity/occup.
foreach e in black hisp amind asian {
	foreach o in mngr prof tech sale cler craf oper labr srvc tot prev {
		replace M_`e'_t_`o' = M_`e'_m_`o' + M_`e'_f_`o' if ///
			!inlist(year, 1978, 1990, 1991) // 1992, 1993?
	}
}

// For each gender-occup group, the "white" columns don't 
// exist until 1990, so create them by subtracting sum of 
// black/hisp/asian/amind from the total column.
foreach o in mngr prof tech sale cler craf oper labr srvc tot prev {
	foreach g in m t f {
		replace M_white_`g'_`o' = M_tot_`g'_`o' - ///
			(M_black_`g'_`o' + M_hisp_`g'_`o' + ///
			M_asian_`g'_`o' + M_amind_`g'_`o') if ///
			!inlist(year, 1978, 1990, 1991) // 1992, 1993?
	}
}

save "$PATH_EEO/dta_format/eeo_fixed.dta", replace 






/*********************************************
* Part 3: Verification: tabulations of race/ethnicity by occup.
*********************************************/
use "$PATH_EEO/dta_format/eeo_fixed.dta", clear
keep if inlist(status, 1, 3, 4) // get estab-level data
tab year

collapse (sum) M_*, by(year)

// Calculate proportion of occup-gender that is each race/ethnicity:
foreach r in white black hisp asian amind {
	foreach g in m f t {
		foreach o in $occs_ascii {
			disp "M_`r'_`g'_`o'"
			gen p_`r'_`g'_`o' = M_`r'_`g'_`o'/M_tot_`g'_`o'
		}
	}
}

// Look at some tabulations -- do they look smooth through 1975-78-80?
list year M_tot_t_tot p_*_t_tot
list year M_tot_t_oper p_*_t_oper
list year M_tot_m_oper p_*_m_oper
list year M_tot_m_cler p_*_m_cler
list year M_tot_f_cler p_*_f_cler

log close _all









