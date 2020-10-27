/* Author: Zheng Liu, Huixuan Bao */
/* Purpose: This program is to use the ARIMA model to analyze SOFR data */

/* Get URL */
%let URL_base = %nrstr(retrieve?multipleRateTypes=true&startdate=04022018&enddate=);
%let URL_prefix = %nrstr(https://websvcgatewayx2.frbny.org/mktrates_external_httponly/services/v1_0/mktRates/excel/);
%let URL_suffix = %nrstr(&rateType=R3);

%let URL_date = %sysfunc(today(),MMDDYYN8.);
%let URL_content = &URL_prefix.&URL_base.&URL_date.&URL_suffix;

/* Read in data */
filename rawdata url "&URL_content";

filename tmp "%sysfunc(pathname(work))./tmp.xls";
proc http url = "&URL_content" method = "get" out = tmp;
run;

proc import datafile = tmp dbms = excel replace out = _sofr;
run;

data sofr(keep = Date Rate);
  set _sofr(firstobs = 4 
            rename = ('Repo Rates'n = _Date 'Repo Rates2'n = _Rate)) 
            end = last nobs = nobs;
  format Date date9.;
  Date = input(_Date, YYMMDD10.);
  Rate = input(_Rate, best12.);
  if _n_ le nobs-10 then output;
run;


/* EDA */
proc arima data = sofr;
  identify var = Rate(1); run;
quit;