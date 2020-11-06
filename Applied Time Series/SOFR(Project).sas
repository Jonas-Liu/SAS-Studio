/* Label: Introduction */
/* Author: Zheng Liu, Huixuan Bao */
/* Purpose: This program is to use the ARIMA model to analyze SOFR data */


*---------------------------------------------------------------------*
| About the SOFR:                                                     |
| The Secured Overnight Financing Rate (SOFR) is a broad measure of   |
| the cost of borrowing cash overnight collateralized by Treasury     |
| securities. The SOFR includes all trades in the Broad General       |
| Collateral Rate plus bilateral Treasury repurchase agreement (repo) |
| transactions cleared through the Delivery-versus-Payment (DVP)      |
| service offered by the Fixed Income Clearing Corporation (FICC),    |
| which is filtered to remove a portion of transactions considered    |
| "specials".                                                         |
*---------------------------------------------------------------------*;

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
data sofr;
  set sofr nobs = nobs;
  if _n_ lt &ratio*nobs then train = rate; * Take logarithm to prevent negative value;
  else test = rate;
  covid = date ge "16MAR2020"d;
  crunch = date eq "17SEP2019"d;
  ltrain = log(train);
run;

%put ____________________________________________________________Analyses start here:;

/* Label: Exploratory Data Analysis */

/* Univariate analysis on the SOFR */
title "Univariate Analysis";
proc univariate data = sofr;
  histogram Rate / normal kernel;
  inset mean std normal / position = ne;
run;
title;

title "Time Series Graph";
proc sgplot data = sofr;
  series x = date y = rate;
run;
title;


/* Label: Trend and Correlation Analysis */

/* Diagnostics and stationary test */

title "Diagnostics for SOFR";
proc arima data = sofr;
  title2 "Original Data";
  identify var = train stationarity = (adf = 0); run;
quit;

proc arima data = sofr;
  title2 "Regular Differencing";
  identify var = train(1); run;
quit;

proc arima data = sofr;
  title2 "Seasonal Differencing (lag 5)";
  identify var = train(1,5); run;
quit;
title;

/* Label: Transformation */


/* Box-Cox test */
proc transreg data = sofr;
  model boxcox(rate) = identity(Date);
run;


/* Label: Model Fitting */
/* ods powerpoint file = 'C:/Users/jonas/Desktop/output.ppt' style = sapphire; */

/* Model fitting */
proc arima data = sofr;
  title "Intervention Analysis";
  identify var = train(1) crosscorr = (covid(1) crunch);
  estimate q = (1,8) input = (covid crunch) method = ml; run;
  forecast lead = 130 out = f_sofr_1; run;
  
  identify var = ltrain(1) crosscorr = (covid(1) crunch);
  estimate q = (1,3,5,10) p = (17,18,19,24) input = (covid crunch) method = ml;run;
  forecast lead = 130 out = f_sofr_2; run;
quit;
title;



/* Label: Backtesting */


data r_sofr;
  set f_sofr_1(keep = train forecast l95 u95 where = (missing(train)));
  set sofr(keep = train test date where = (missing(train)));
  rename test = rate;
run;

title "Forecasting";
proc sgplot data = r_sofr;
  band x = date upper = u95 lower = l95 /
    transparency = 0.5 legendlabel = '95% Confidence Interval';
  series x = date y = rate /
    lineattrs = (color = 'Blue' thickness = 1) legendlabel = 'Actual';
  series x = date y = forecast /
    lineattrs = (color = 'LightRed' thickness = 1) legendlabel = 'Forecasting';
run;
title;

data r_sofr;
  set f_sofr_2(keep = ltrain forecast l95 u95 where = (missing(ltrain)));
  set sofr(keep = train test date where = (missing(train)));
  rename test = rate;
  
  forecast = exp(forecast);
  l95 = exp (l95);
  u95 = exp(u95);
run;

title "Forecasting";
proc sgplot data = r_sofr;
  band x = date upper = u95 lower = l95 /
    transparency = 0.5 legendlabel = '95% Confidence Interval';
  series x = date y = rate /
    lineattrs = (color = 'Blue' thickness = 1) legendlabel = 'Actual';
  series x = date y = forecast /
    lineattrs = (color = 'LightRed' thickness = 1) legendlabel = 'Forecasting';
run;
title;

/* ods powerpoint close; */

/* Label: Conclusion */

/* Date: 11/05/2020 */
/* Author: Zheng Liu, Huixuan Bao */
/* Final Conclusion */

*---------------------------------------------------------------------*
| 1. Logarithm transformation solves the problem of negative interest |
|    rates but may change the impact on interventions.                |
| 2. Special events prediction.                                       |
| 3. Further study: GARCH Model or SDE (Vasicek or CIR Model).        |
*---------------------------------------------------------------------*;