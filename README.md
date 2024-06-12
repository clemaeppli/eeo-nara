# eeo-nara
Update 6.12.2024

**Overview**

EEO-1 files are publicly released by the National Archives (NARA) after 30 years. Years 1966-1993 are currently available on NARA's website. This is a collection of scripts to download and process the data.


**Contents**
1. download.BAT -- Windows batch script that (a) creates directories for each EEO year (1966 thru 1993) as well as a documentation folder ("doc"); (b) downloads everything to those folders; (c) unzips the zipped files (several years are stored on NARA's website zipped).
2. read_eeo_text_v2.DO -- Stata script that reads in this data as produced by download.BAT. Does some preliminary cleaning.
3. varlist90.TXT -- a list of variables in the 1990 round. You don't need to run or edit this. read_eeo_text_v2.do uses it to produce a dictionary to read in the 1990s EEOs.
4. eeo_fix.DO -- Stata script that fixes some issues in the raw EEO data. For the matrix data (demographic by occupation counts) certain columns seem to have been swapped; this script unswaps them.

**Steps to use these scripts**
1. Create a folder where you want the data, and put the 4 files into it.
2. Run download.BAT (by double-clicking or by running it from command line)
3. Edit PATH_EEO macros in read_eeo_text_v2.DO and eeo_fix.DO
4. Run read_eeo_text_v2.DO
5. Run eeo_fix.DO.



