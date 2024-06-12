# eeo-nara
Updated 6.12.2024

## Overview
EEO-1 files are publicly released by the National Archives (NARA) after 30 years. Years 1966-1993 are currently available on NARA's website. However, there are some inconsistencies across years. This is a collection of scripts to download and process the data, producing a harmonized Stata-format dataset. Ideally it takes 3 clicks to run the whole thing (1 Batch file and 2 Stata do-files). 


## Contents
1. download.BAT -- Windows batch script that (a) creates directories for each EEO year (1966 through 1993) as well as a documentation folder (_doc_); (b) downloads everything to those folders; (c) unzips the zipped files (several years are stored on NARA's website zipped). 
2. read_eeo_text_v2.DO -- Stata script that reads in this data as produced by download.BAT. Does some preliminary cleaning.
3. varlist90.TXT -- a list of variables in the 1990 round. You don't need to run or edit this. _read_eeo_text_v2.do_ uses it to produce a dictionary to read in the 1990s EEOs.
4. eeo_fix.DO -- Stata script that fixes some issues in the raw EEO data. For the matrix data (demographic by occupation counts) certain columns seem to have been swapped; this script unswaps them.

## Steps to use these scripts
1. Create a folder where you want the data, and put the 4 files into it.
2. Run download.BAT (by double-clicking or by running it from command line)
3. Edit PATH_EEO macros in read_eeo_text_v2.DO and eeo_fix.DO
4. Run read_eeo_text_v2.DO. The resulting file, for all years, will be saved to _dta_format/eeo.dta_. (The folder _dta_format_ is created by download.BAT)
5. Run eeo_fix.DO to fix the column mixup issues. The resulting all-years file is saved to _dta_format/eeo_fixed.dta_. The last part of this script will tabulate some of the demographic counts across years, which lets you see whether things seem reasonable. If you find any issues please let me know!

## Notes for using the resulting data
The EEO-1 includes several types of reporting units, identified by the _status_ variable.
* 1 = single establishment employers
* 2 = consolidated report of multi-establishment employers
* 3 = headquarters report for multi-establishment emploeyrs
* 4 = establishment report for estabs with $\ge$ 50 employees
* 5 = special reporting procedure
  
(This is described on p.16 of the documentation file _160_8DP.pdf_, downloaded by _download.BAT_ to the _doc_ folder. Also available on the [NARA AWS page](https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_8DP.pdf))

So if you want to do an establishment-level analysis, you can start by filtering to status codes 1, 3, and 4. For a firm-level analysis, filter to status codes 1 and 2 -- though note that type 2 is not consistently included in every year.






