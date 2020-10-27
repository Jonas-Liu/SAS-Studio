/* Author: Zheng Liu */
/* Purpose: This program is to get the answer for the homework 4*/

x "cd D:/Repository/SAS-Studio/Applied Time Series/";

/* Read in dataset */
filename rawdata 'Data';

%macro fit(d_name);
  data &d_name;
    infile rawdata("&d_name..txt");
    input n z;
    drop n;
  run;
  
  title "Diagnostic of &d_name";
  proc arima data = &d_name;
    identify var = z;
    run;
  quit;
  title;
%mend fit;


/* Dataset 3 */
%fit(data3)

/* Analysis */
proc arima data = data3;
  identify var = z stationarity = (adf = 2); run;
  identify var = z(1); run;
  estimate q = 2; run;
  estimate q = 3; run;
quit;

/* Dataset 4 */
%fit(data4)

/* Analysis */
proc arima data = data4;
  identify var = z; run;
  estimate p = 1; run;
quit;