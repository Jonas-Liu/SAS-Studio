/* Label: Introduction */
/* Author: Zheng Liu, Huixuan Bao */
/* Purpose: This program is to use the ARIMA model to analyze SOFR data */


/* 
 About the SOFR:
 The Secured Overnight Financing Rate (SOFR) is a broad measure of the cost
 of borrowing cash overnight collateralized by Treasury securities. The SOFR 
 includes all trades in the Broad General Collateral Rate plus bilateral Treasury
 repurchase agreement (repo) transactions cleared through the Delivery-versus-Payment (DVP)
 service offered by the Fixed Income Clearing Corporation (FICC), which is filtered 
 to remove a portion of transactions considered "specials". 
*/

/* Label: Conclusion */

/* Date: 11/01/2020 */
/* Author: Zheng Liu, Huixuan Bao */
/* Final Conclusion */



/* Label: Import Data */

/* Get URL */
%let URL_base = %nrstr(retrieve?multipleRateTypes=true&startdate=04022018&enddate=);
%let URL_prefix = %nrstr(https://websvcgatewayx2.frbny.org/mktrates_external_httponly/services/v1_0/mktRates/excel/);
%let URL_suffix = %nrstr(&rateType=R3);

%let URL_date = %sysfunc(today(),MMDDYYN8.);
%let URL_date = 11012020;

%let URL_content = &URL_prefix.&URL_base.&URL_date.&URL_suffix;

/* Read in data */
filename rawdata url "&URL_content";

filename tmp "%sysfunc(pathname(work))./tmp.xls";
proc http url = "&URL_content" method = "get" out = tmp;
run;

proc import datafile = tmp dbms = excel replace out = _sofr;
  getnames = no;
run;

data sofr(keep = Date Rate);
  set _sofr(firstobs = 5
            rename = (F1 = _Date F3 = _Rate)) 
            end = last nobs = nobs;
  format Date date9.;
  Date = input(_Date, YYMMDD10.);
  Rate = input(_Rate, best12.);
  if _n_ le nobs-11 then output;
run;

/* Label: Sampling */

/* Set the proportion of the train set */
%let ratio = 0.8;

proc sort data = sofr;
  by date;
run;

/* Train-Test Split */
data train test;
  set sofr nobs = nobs;
  if _n_ lt &ratio*nobs then output train;
  else output test;
run;

%put ____________________________________________________________Analyses start here: (Data: Train/Test);

/* Set the working dataset name */
%let n_data = train;

/* Label: Exploratory Data Analysis */

/* Univariate analysis on the SOFR */
title "Univariate Analysis";
proc univariate data = &n_data;
  histogram Rate / normal kernel;
  inset mean std normal / position = ne;
run;
title;


/* ods powerpoint file = "C:\Users\jonas\Desktop\x.ppt" style = sapphire; */
/* ods powerpoint close; */

/* Label: Trend and Correlation Analysis */

/* Diagnostics and stationary test */

title "Diagnostics for SOFR";
proc arima data = &n_data;
  title2 "Original Data";
  identify var = Rate stationarity = (adf = 0); run;
quit;

proc arima data = &n_data;
  title2 "Regular Differencing";
  identify var = Rate(1); run;
quit;

proc arima data = &n_data;
  title2 "Seasonal Differencing (lag 21)";
  identify var = Rate(1,21); run;
quit;
title;

/* Label: Transformation */

/* Box-Cox test */

proc transreg data = &n_data;
  model boxcox(Rate) = identity(Date);
run;


/* Label: Model Fitting */

/* Model fitting */
proc arima data = &n_data;
  title2 "Regular Differencing";
  identify var = Rate(1,21); run;
  estimate q = (1)(21); run;
  forecast lead = 129 out = f_sofr; run;
quit;


/* Label: Backtesting */


data r_sofr;
  set f_sofr(keep = rate forecast l95 u95 where = (missing(rate)));
  set test;
run;

data f_sofr;
  set f_sofr;
  n = _n_;
run;
proc sgplot data = f_sofr;
  series x = n y = rate;
  series x = n y = forecast;
run;

title "Forecasting";
proc sgplot data = r_sofr;
  band x = date upper = u95 lower = l95 /
    transparency = 0.5 legendlabel = '95% Confidence Interval';
  series x = date y = rate /
    lineattrs = (color = 'Blue' thickness = 1);
  series x = date y = forecast /
    lineattrs = (color = 'LightRed' thickness = 1);
run;
title;

