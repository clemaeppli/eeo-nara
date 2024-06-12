/*****************************************************
* read_eeo_text.do
* Updated 6.12.2024
* Clem Aeppli
*
* Imports and processes the raw ASCII-format EEO data files,
* downloaded from the National Archives. 
* See download.bat for the URLs from which these are downloaded.
* 
* Steps:
*  1. Read in caret-delimited text files 1966-1988
*  2. Read in fixed-width text files 1990-1993
*  3. Additional year-by-year editing
*  4. Append it all into one file
*
* In order to use this script: you must set PATH_EEO to the right location.
*
*****************************************************/

clear all

global PATH_EEO "C:/Users/caaep/Documents/EEO"
cd "$PATH_EEO"

/***************************
* Step 1. Read in EEO text files for 1966-1988 
* (must be unzipped).
****************************/

global filelist "1966/RG403.EEO1.Y1966.txt" ///
 "1967/RG403.EEO1.Y1967.txt" ///
 "1968/RG403.EEO1.Y1968.txt" ///
 "1969/RG403.EEO1.Y1969.txt" ///
 "1970/RG403.EEO1.Y1970.txt" ///
 "1971/RG403.EEO1.Y1971.txt" ///
 "1972/RG403.EEO1.Y1972.txt" ///
 "1973/RG403.EEO1.Y1973.txt" ///
 "1974/RG403.EEO1.Y1974.txt" ///
 "1975/RG403.EEO1.Y1975.txt" ///
 "1978/RG403.EEO1.Y1978_ASCII.txt" ///
 "1980/RG403.EEO1.Y1980_ASCII.txt" ///
 "1982/RG403.EEO1.Y1982_ASCII.txt" ///
 "1984/RG403.EEO1.Y1984.txt" ///
 "1986/RG403.EEO1.Y1986.txt" ///
 "1988/RG403.EEO1.Y1988.txt" 
 

// Loop through each year:
// --> dta_format/raw_19XX.dta files
foreach f in "$filelist" {
	disp "`f'"
	import delimited "$PATH_EEO/`f'", delimiters("^") clear stripquotes(yes) bindquotes(nobind)
	local y = substr("`f'", 1, 4)
		
	save "$PATH_EEO/dta_format/raw_`y'", replace
}

// Additional cleaning for each year:
// --> dta_format/clean_19XX.dta files
foreach y of numlist 1966/1975 1978 1980 1982 1984 1986 1988 {
	use "$PATH_EEO/dta_format/raw_`y'", clear
	
	capture drop blank*
	capture drop year
	foreach v of varlist * {
		capture tostring `v', force replace
	}
	
	foreach v in total* male* female* asian* oriental* black* negro* hispan* spanish* white* amerin* {
		capture destring `v', force replace
	}
	
	gen year = `y'
	compress
	save "$PATH_EEO/dta_format/clean_`y'", replace
}


/*************************
* Step 2. Deal with 1990-1993 
* These files are in fixed-width format rather
* than caret-delimited (as for pre-1988).
*************************/ 
// Create dictionary file for 1990-1993. Start with varlist90.txt,
// which has the documentation PDF (160_9DP-1.pdf) text directly copied in.
// The following lines turn it into correct format for a stata dictionary file,
// saving as "dict90.dct".
import delimited "$PATH_EEO/varlist90.txt", delimiter(whitespace) clear 

ren v1 pos
destring pos, replace force
ren v2 length
destring length, replace force
ren v3 type
ren v4 name
drop v5

gen _type = "long" if strupper(type) == "R"
replace _type = "str50" if strupper(type) == "C"
gen s = "_column(" + string(pos) + ")   " + _type + "   " + name + "   %" + string(length) + "s"
list s
keep s

// Last step in creating dictionary: add "dictionary {" to start
// and "}" to end:
insobs 1, before(1)
replace s = "dictionary {" if _n == 1
insobs 1, after(`=_N')
replace s = "}" if _n == _N

outfile using "$PATH_EEO/dict90.dct", replace noquote

// Now can use the dictionary file to read in 1990-93:
forvalues y = 90/93 {
	disp "Working on 19`y'"
	clear all
	infile using "$PATH_EEO/dict90.dct", using("$PATH_EEO/19`y'/E1STAT`y'.DAT.txt")
	gen year = 19`y'
	compress
	save "$PATH_EEO/dta_format/clean_19`y'", replace
}


/***************************
* Step 3. Some editing year-by-year, renaming variables to consistent convention.
****************************/

// Rename matrix vars for 1966, 67, 68, 69, 70, 71, 72, 73, 74:
foreach y of numlist 1966/1974 {
	use "$PATH_EEO/dta_format/clean_`y'", clear
	foreach j in officia profes techni sale office craft operat labore servic total {
		disp "------ `j'"	
		
		ren totals`j' M_tot_t_`j' 
		ren male`j' M_tot_m_`j' 
		ren female`j' M_tot_f_`j'
		
		ren amerindianmale`j' M_amind_m_`j'
		ren amerindianfemale`j' M_amind_f_`j'
		
		ren spanishmale`j' M_hisp_m_`j' 
		ren spanishfemale`j' M_hisp_f_`j'
		
		ren orientalmale`j' M_asian_m_`j' 
		ren orientalfemale`j' M_asian_f_`j' 
		
		ren negromale`j' M_black_m_`j' 
		ren negrofemale`j' M_black_f_`j' 
	}
	drop *appre* // apprentices
	drop *tra* // trainees
	
	save "$PATH_EEO/dta_format/cleaner_`y'", replace
}


// Rename matrix vars for 1975, 78, 80, 82, 84, 86:
foreach y of numlist 1975 1978 1980 1982 1984 1986 1988 {
//	local y = 1978
	use "$PATH_EEO/dta_format/clean_`y'", clear
	foreach j in officia profes techni sale office craft operat labore servic prevyeartotal {
		disp "------ `j'"	
		
		ren totalmaleandfemale`j' M_tot_t_`j' 
		ren totalmale`j' M_tot_m_`j' 
		ren totalfemale`j' M_tot_f_`j' 
		
		ren amerinalnatvmale`j' M_amind_m_`j' 
		ren amerinaknatvfemale`j' M_amind_f_`j'  // careful with lettering here -- weird change

		ren hispanicmale`j' M_hisp_m_`j' 
		ren hispanicfemale`j' M_hisp_f_`j' 
		
		ren asianpimale`j' M_asian_m_`j' 
		ren asianpifemale`j' M_asian_f_`j' 
		
		ren blackmale`j' M_black_m_`j'
		ren blackfemale`j' M_black_f_`j'
		
		foreach g in totals male female negromale orientalmale amerindianmale ///
		spanishmale negrofemale orientalfemale amerindianfemale spanishfemale {
			capture drop `g'`j'
		}
	}
		
	ren totalmaleandfemalecolumntot M_tot_t_total
	ren totalmalecolumntot M_tot_m_total
	ren totalfemalecolumntot M_tot_f_total 
	
	ren amerinalnatvmalecolumntot M_amind_m_total
	ren amerinaknatvfemalecolumntot M_amind_f_total  // careful with lettering here -- weird change (typo?) for male total

	ren hispanicmalecolumntot M_hisp_m_total
	ren hispanicfemalecolumntot M_hisp_f_total 
		
	ren asianpimalecolumntot M_asian_m_total
	ren asianpifemalecolumntot M_asian_f_total 
	
	ren blackmalecolumntot M_black_m_total
	ren blackfemalecolumntot M_black_f_total
		
	capture drop *columntotal
	
	drop *onthejob* // on-the-job trainees
	
	save "$PATH_EEO/dta_format/cleaner_`y'", replace
}



// 1990-1993:
global glist "officia profes techni sale office craft operat labore servic total prevyeartotal"

forvalues y = 1990/1993 {
	use "$PATH_EEO/dta_format/clean_`y'", clear
	
	forvalues x = 1/11 {
		local j: word `x' of $glist
		disp "`x' -- `j'"
		
		ren TOTAL`x' M_tot_t_`j' 
		ren MT`x' M_tot_m_`j' 
		ren FT`x' M_tot_f_`j' 
		
		ren AIANM`x' M_amind_m_`j' 
		ren AIANF`x' M_amind_f_`j'
		ren AIANT`x' M_amind_t_`j'

		ren HISPM`x' M_hisp_m_`j' 
		ren HISPF`x' M_hisp_f_`j' 
		ren HISPT`x' M_hisp_t_`j' 
		
		ren AAPIM`x' M_asian_m_`j' 
		ren AAPIF`x' M_asian_f_`j' 
		ren AAPIT`x' M_asian_t_`j' 
		
		ren BLKM`x' M_black_m_`j'
		ren BLKF`x' M_black_f_`j'
		ren BLKT`x' M_black_t_`j'
		
		ren WHM`x' M_white_m_`j'
		ren WHF`x' M_white_f_`j'
		ren WHT`x' M_white_t_`j'
	}
	
	save "$PATH_EEO/dta_format/cleaner_`y'", replace
}



/***************************
* Step 4. Append all together.
****************************/
foreach y of numlist 1965/1975 1978 1980 1982 1984 1986 1988 1990/1993 {
	disp "Now `y'"
	tab1 ag*, m
}



use "$PATH_EEO/dta_format/cleaner_1966", clear
foreach y of numlist 1967/1975 1978 1980 1982 1984 1986 1988 1990/1993 {
	append using "$PATH_EEO/dta_format/cleaner_`y'"
}


foreach v of varlist M_* {
	replace `v' = 0 if missing(`v')
}

destring status, force replace
destring statuscode, force replace
destring U_STATUS, force replace
replace status = statuscode if inrange(year, 1975, 1988)
replace status = U_STATUS if inrange(year, 1990, 1993)

// EEO's unit ID:
// reportingunit (str): 1966
// unit (str): 1969-1970
// companyunitidentify (str): 1969
// unitnumber (str): 1971-1988
// UNIT_NBR (str): 1990-1991

gen unit_id = reportingunit if year == 1966
replace unit_id = controlnumber if inrange(year, 1967, 1968)
replace unit_id = unit if inrange(year, 1969, 1970)
replace unit_id = unitnumber if inrange(year, 1971, 1988)
replace unit_id = UNIT_NBR if inrange(year, 1990, 1993)
replace unit_id = stritrim(strtrim(unit_id))

// EEO's HQ or company ID
// unclear what it is for 1966-1967
// headquartersnumber (str): 1968-1974
// companynumber (str): 1975-1988
// HDQ_NBR (str): 1990-1991

gen hq_id = headquartersnumber if inrange(year, 1968, 1974)
replace hq_id = companynumber if inrange(year, 1975, 1988)
replace hq_id = HDQ_NBR if inrange(year, 1990, 1993)
replace hq_id = stritrim(strtrim(hq_id))



// ZIP code with 5 digits:
recast str20 zipcode, force
egen zipcode_ = sieve(zipcode), keep(numeric) 
// get rid of any nonnumeric characters
gen zip = substr(stritrim(strtrim(zipcode)), 1, 5) if inrange(year, 1966, 1988)
tostring ZIP1, gen(ZIP1_)
replace zip = substr(stritrim(strtrim(ZIP1_)), 1, 5) if inrange(year, 1990, 1993)

// county code
destring countycode, replace force
destring FIP3, replace force
replace countycode = FIP3 if inrange(year, 1990, 1993)

// state code
destring statecode, replace force
destring FIP2, replace force
replace statecode = FIP2 if inrange(year, 1990, 1993)


/*foreach v of varlist *ein* *EI* {
	capture confirm numeric variable `v' 
	if !_rc {
		disp "`v' -- number!"
		quietly gen h_`v' = !missing(`v')
	}
	if _rc {
		disp "`v' -- string!"
		quietly gen h_`v' = (`v' != "")
	}
	tab year h_`v', m
	quietly drop h_`v'
}*/
// einumber: 1966-1974
// parenteinumber: 1966, 1969-1974
// companyeinumber: 1975-1988
// uniteinumber: 1978-1988
// previouseinumber: 1978-1980
// COMP_EI: 1990-1991
// EI_NBR: 1990-1991

gen ein = einumber if year <= 1974
// what about 1975???
replace ein = uniteinumber if inrange(year, 1978, 1988)
replace ein = EI_NBR if inrange(year, 1990, 1993)
destring ein, replace force

gen parent_ein = parenteinumber if year == 1966 | inrange(year, 1969, 1974)
replace parent_ein = companyeinumber if inrange(year, 1975, 1988)
replace parent_ein = COMP_EI if inrange(year, 1990, 1993)
destring parent_ein, replace force

gen state_abbr = stateabbreviation if year <= 1988
replace state_abbr = FIP2NM if year >= 1990

replace address = address if year <= 1988
replace address = ADDR if year >= 1990	
replace address = strtrim(stritrim(address))
recast str200 address, force  // can't be strL

/*foreach v of varlist *par* *company* *unit* *est* {
	quietly gen h_`v' = (`v' != "")
	tab year h_`v', m
	quietly drop h_`v'
}*/

// unitname: 1975-1988
// establishmentname: 1967 (not 66)-1974
// companyname: 1966
// nameparentcompany: 1972
// parentcompanyname: 1974-1988
// P_NAME: 1990-1991
// UNIT_NM: 1990-1991

// Estab name
// Note: 1966 just asked for "company name", so use this
gen est_name = companyname if year == 1966
replace est_name = establishmentname if inrange(year, 1967, 1974)
replace est_name = unitname if inrange(year, 1975, 1988)
replace est_name = UNIT_NM if inrange(year, 1990, 1993)
gen has_est_name = (est_name != "")
tab year has_est_name, m

// Parent name
// Note 1: same "company name" field in 1966
// Note 2: the EEO forms from 1967-1970 don't seem to 
// have asked for parent/company name, just estab name.
gen parent_name = companyname if year == 1966
replace parent_name = parentcompany if inlist(year, 1971, 1973)
replace parent_name = nameparentcompany if year == 1972
replace parent_name = parentcompanyname if inrange(year, 1974, 1988)
replace parent_name = P_NAME if inrange(year, 1990, 1993)


/*foreach v of varlist *city* *CITY* {
	capture confirm numeric variable `v' 
	if !_rc {
		disp "`v' -- number!"
		quietly gen h_`v' = !missing(`v')
	}
	if _rc {
		disp "`v' -- string!"
		quietly gen h_`v' = (`v' != "")
	}
	tab year h_`v', m
	quietly drop h_`v'
}*/

// city: 1967-1970, 1974
// cityname: 1966, 1971-1973, 1975-1988
// CITY_NM: 1990-1991

// city already named city for 1967-1970 and 1974
replace city = cityname if (year == 1966) | inrange(year, 1971, 1973) | inrange(year, 1975, 1988)
replace city = CITY_NM if inrange(year, 1990, 1993)


// Find which years use which names for SIC:
foreach v of varlist *indus* *sic* *SIC* {
	capture confirm numeric variable `v' 
	if !_rc {
		disp "`v' -- number!"
		quietly gen h_`v' = !missing(`v')
	}
	if _rc {
		disp "`v' -- string!"
		quietly gen h_`v' = (`v' != "")
	}
	tab year h_`v', m
	quietly drop h_`v'
}

// siccode (str): 1966-1967, 1971
// sic (str): 1968-1970, 1972-1974
// standardindustrialcode (str): 1975-1988
// SIC2 (num): 1990-1991
// SIC3 (num): 1990-1991
// SIC4_PRETEST (num): 1990-1991

gen sicc3 = siccode if inrange(year, 1966, 1967) | year == 1971
replace sicc3 = sic if inrange(year, 1968, 1970) | inrange(year, 1972, 1974)
replace sicc3 = standardindustrialcode if inrange(year, 1975, 1988)
tostring SIC3, gen(SIC3_)
replace sicc3 = SIC3_ if inrange(year, 1990, 1993)

egen sicc3_ = sieve(sicc3), keep(numeric) // get rid of any nonnumeric characters
replace sicc3 = strtrim(stritrim(sicc3_))
drop sicc3_
destring sicc3, gen(sicc3_) // create numeric version


keep year unit_id hq_id est_name parent_name status sicc3 sicc3_ ein parent_ein address state_abbr city zip statecode countycode M_*

// Verify years have variables:
foreach v of varlist unit_id hq_id est_name parent_name status sicc3 sicc3_ ein parent_ein address state_abbr city zip statecode countycode {
	capture confirm numeric variable `v' 
	if !_rc {
		disp "`v' -- number!"
		quietly gen h_`v' = !missing(`v') & `v' != 0
	}
	if _rc {
		disp "`v' -- string!"
		quietly gen h_`v' = (`v' != "")
	}
	tab year h_`v', m
	quietly drop h_`v'
}


// Rename occupations to nicer 4-letter convention:
global newnames "mngr prof tech sale cler craf oper labr srvc tot prev"
global oldnames "officia profes techni sale office craft operat labore servic total prevyeartotal ""

forvalues i = 1/11 {
	local old `:word `i' of $oldnames'
	local new `:word `i' of $newnames'
	disp "Now: `old' --> `new'"
	foreach d in tot white hisp amind asian black {
		foreach g in m t f {
			disp "M_`d'_`g'_`old' --> M_`d'_`g'_`new'"
			ren M_`d'_`g'_`old' M_`d'_`g'_`new'
		}
	}
}


compress
save "$PATH_EEO/dta_format/eeo", replace



