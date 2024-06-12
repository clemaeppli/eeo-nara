:: download.bat
:: Updated 6.12.2024
:: Clem Aeppli
:: Script creates directory structure for NARA EEO-1, download the data from NARA/Amazon, and unzips the 7 years that are zipped.

ECHO OFF

echo MAKING FOLDERS
set list= 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1978 1980 1982 1984 1986 1988 1990 1991 1992 1993
(for %%a in (%list%) do ( 
  echo %%a 
  del %%a
  mkdir %%a
))
del doc
mkdir doc
del dta_format
mkdir dta_format


echo DOWNLOADING DATASETS TO YYYY FOLDERS
curl -o 1966/RG403.EEO1.Y1966.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1966.txt
curl -o 1967/RG403.EEO1.Y1967.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1967.txt
curl -o 1968/RG403.EEO1.Y1968.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1968.txt
curl -o 1969/RG403.EEO1.Y1969.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1969.txt
curl -o 1970/RG403.EEO1.Y1970.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1970.txt
curl -o 1971/RG403.EEO1.Y1971.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1971.txt
curl -o 1972/RG403.EEO1.Y1972.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1972.txt
curl -o 1973/RG403.EEO1.Y1973.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1973.txt
curl -o 1974/RG403.EEO1.Y1974.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1974.txt
curl -o 1975/RG403.EEO1.Y1975.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1975.txt
curl -o 1978/RG403.EEO1.Y1978_ASCII.zip https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1978_ASCII.zip
curl -o 1980/RG403.EEO1.Y1980_ASCII.zip https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1980_ASCII.zip
curl -o 1982/RG403.EEO1.Y1982_ASCII.zip https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1982_ASCII.zip
curl -o 1984/RG403.EEO1.Y1984.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1984.txt
curl -o 1986/RG403.EEO1.Y1986.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1986.txt
curl -o 1988/RG403.EEO1.Y1988.txt https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/RG403.EEO1.Y1988.txt
curl -o 1990/E1STAT90.DAT.zip https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/E1STAT90.DAT.zip
curl -o 1991/E1STAT91.DAT.zip https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/E1STAT91.DAT.zip
curl -o 1992/E1STAT92.DAT.zip https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/E1STAT92.DAT.zip
curl -o 1993/E1STAT93.DAT.zip https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/E1STAT93.DAT.zip


echo DOWNLOADING DOCUMENTATION FILES TO doc FOLDER
curl -o doc/160_1DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_1DP.pdf
curl -o doc/160_2DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_2DP.pdf
curl -o doc/160_3DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_3DP.pdf
curl -o doc/160_4DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_4DP.pdf
curl -o doc/160_5DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_5DP.pdf
curl -o doc/160_6DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_6DP.pdf
curl -o doc/160_7DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_7DP.pdf
curl -o doc/160_8DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_8DP.pdf
curl -o doc/160_9DP.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/160_9DP.pdf

echo DOWNLOADING RECORD FILES TO doc FOLDER
curl -o doc/EEO1_66_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_66_TSS160_1.pdf
curl -o doc/EEO1_67_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_67_TSS160_1.pdf
curl -o doc/EEO1_68_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_68_TSS160_1.pdf
curl -o doc/EEO1_69_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_69_TSS160_1.pdf
curl -o doc/EEO1_70_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_70_TSS160_1.pdf
curl -o doc/EEO1_71_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_71_TSS160_1.pdf
curl -o doc/EEO1_72_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_72_TSS160_1.pdf
curl -o doc/EEO1_73_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_73_TSS160_1.pdf
curl -o doc/EEO1_74_TSS160_1.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_74_TSS160_1.pdf
curl -o doc/EEO1_75_TSS160_2.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_75_TSS160_2.pdf

curl -o doc/EEO1_78_TSS160_3.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_78_TSS160_3.pdf
curl -o doc/EEO1_80_TSS160_4.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_80_TSS160_4.pdf

curl -o doc/EEO1_82_TSS160_5.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_82_TSS160_5.pdf
curl -o doc/EEO1_84_TSS160_6.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_84_TSS160_6.pdf
curl -o doc/EEO1_86_TSS160_7.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_86_TSS160_7.pdf
curl -o doc/EEO1_88_TSS160_8.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_88_TSS160_8.pdf
curl -o doc/EEO1_90_TSS160_9.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_90_TSS160_9.pdf
curl -o doc/EEO1_91_TSS160_9.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_91_TSS160_9.pdf

curl -o doc/EEO1_92_TSS160_9.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_92_TSS160_9.pdf
curl -o doc/EEO1_93_TSS160_9.pdf https://s3.amazonaws.com/NARAprodstorage/lz/electronic-records/rg-403/EEO1/EEO1_93_TSS160_9.pdf


echo UNZIPPING
tar -xf "1978/RG403.EEO1.Y1978_ASCII.zip" -O > 1978/RG403.EEO1.Y1978_ASCII.txt
tar -xf "1980/RG403.EEO1.Y1980_ASCII.zip" -O > 1980/RG403.EEO1.Y1980_ASCII.txt
tar -xf "1982/RG403.EEO1.Y1982_ASCII.zip" -O > 1982/RG403.EEO1.Y1982_ASCII.txt
tar -xf "1990/E1STAT90.DAT.zip" -O > 1990/E1STAT90.DAT.txt
tar -xf "1991/E1STAT91.DAT.zip" -O > 1991/E1STAT91.DAT.txt
tar -xf "1992/E1STAT92.DAT.zip" -O > 1992/E1STAT92.DAT.txt
tar -xf "1993/E1STAT93.DAT.zip" -O > 1993/E1STAT93.DAT.txt

echo DOWNLOAD COMPLETED...
pause
