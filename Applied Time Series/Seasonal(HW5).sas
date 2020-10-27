/* Author: Zheng Liu */
/* Purpose: This program is to get the answer for the homework 5*/

x "cd D:/Repository/SAS-Studio/Applied Time Series/";

/* Read in dataset */
filename rawdata 'Data';

/* Rawdata names */
%let airline = monthly airline passengers;
  %let v_airline = year month $ z;
  
%let liquor = US liquor sales;
  %let v_liquor = month $ year z;
  
%let gas = personal consuption of gasoline;
  %let v_gas = qt year z;
  
%macro fit(d_name);
  data &d_name;
    infile rawdata("&&&d_name...txt");
    input &&&v_&d_name;
  run;
  
  title "Diagnostic of &d_name";
  proc arima data = &d_name;
    identify var = z;
    run;
  quit;
  title;
%mend fit;


/* Airline dataset analysis */
%fit(airline);

proc arima data = airline;
  identify var = z(1,12); run;
  estimate q = 1; run;
  estimate q = (1)(12) p = (12); run;
  estimate p = 1; run;
quit;


/* Liquor dataset analysis */
%fit(liquor);

proc arima data = liquor;
  identify var = z(1,12); run;
  estimate q = 1; run;
  estimate q = (1)(12); run;
quit;


/* Gas dataset analysis */
%fit(gas);

proc arima data = gas;
  identify var = z(1); run;
  estimate p = 1; run;
  estimate p = (1)(4); run;

  identify var = z(1,4); run;
  estimate q = (1)(4); run;
quit;