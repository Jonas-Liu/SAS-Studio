%let path=D:/Repository/SAS-Studio/SAS Advanced/certadv;
%macro setdelim;
   %global delim;
   %if %index(&path,%str(/)) %then %let delim=%str(/);
   %else %let delim=%str(\);
%mend;
%setdelim
libname certadv "&path";

