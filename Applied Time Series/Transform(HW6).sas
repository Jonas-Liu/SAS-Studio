/* Author: valueheng Liu */
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

proc arima data = liquor;
  identify var = z; run;


quit;



/* Gas dataset analysis */

%fit(gas);
/* Data transformation */
data gas;
  set gas;
  z = 1/sqrt(value);
run;

proc arima data = gas;
  identify var = z; run;


quit;
