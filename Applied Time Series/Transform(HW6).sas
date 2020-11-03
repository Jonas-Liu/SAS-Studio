/* Author: Zheng Liu */
/* Purpose: This program is to get the answer for the homework 6*/

x "cd D:/Repository/SAS-Studio/Applied Time Series/";

/* Read in dataset */
filename rawdata 'Data';

/* Rawdata names */
%let liquor = US liquor sales;
  %let v_liquor = month : $3. year value;
  %let d_liquor = input(cat('01',month,year), date9.);
  
%let gas = personal consuption of gasoline;
  %let v_gas = qtr year value;
  %let d_gas = yyq(year, qtr);
  
%macro fit(d_name);
  data &d_name;
    format time date9.;
    infile rawdata("&&&d_name...txt");
    input &&&v_&d_name;
    time = &&&d_&d_name;
  run;
  
  title "Plot of &&&d_name";
  proc sgplot data = &d_name;
    series x = time y = value;
  run;
  title;
  
  proc transreg data = &d_name;
    model boxcox(value) = identity(time);
  run;
%mend fit;


/* Liquor dataset analysis */

%fit(liquor);
/* Data transformation */
data liquor;
  set liquor;
  z = 1/sqrt(value);
run;
/* Data analysis using proc arima */
proc arima data = liquor;
  identify var = z; run;
  identify var = z(1,12); run;
  estimate q = (1,12);
  estimate q = (1)(12); run;
  forecast lead = 24 out = r_liquor; run;
quit;
/* Data transformation */
data r_liquor;
  set r_liquor;
  n = _n_;
  value = (1/z)**2;
  estimate = (1/forecast)**2;
run;
title "Plot of US liquor sales forecasting";
proc sgplot data = r_liquor;
  series x = n y = value / legendlabel = 'Actual'
  lineattrs = (thickness = 2) transparency = 0.2;
  series x = n y = estimate / legendlabel = 'Forecasting'
  lineattrs = (thickness = 2) transparency = 0.4;
  xaxis grid label = 'Observations';
  yaxis grid label = 'Value';
run;
title;

/* Gas dataset analysis */

%fit(gas);
/* Data transformation */
data gas;
  set gas;
  z = 1/sqrt(value);
run;
/* Data analysis using proc arima */
proc arima data = gas;
  identify var = z; run;
  identify var = z(1); run;
  estimate p = 1; run;
  estimate p = (1,8); run;
  forecast lead = 8 out = r_gas; run;
quit;
/* Data transformation */
data r_gas;
  set r_gas;
  n = _n_;
  value = (1/z)**2;
  estimate = (1/forecast)**2;
run;
title "Plot of personal consuption of gasoline forecasting";
proc sgplot data = r_gas;
  series x = n y = value / legendlabel = 'Actual'
  lineattrs = (thickness = 2) transparency = 0.2;
  series x = n y = estimate / legendlabel = 'Forecasting'
  lineattrs = (thickness = 2) transparency = 0.4;
  xaxis grid label = 'Observations';
  yaxis grid label = 'Value';
run;
title;