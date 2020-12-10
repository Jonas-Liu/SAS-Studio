/* Author: Zheng Liu */
/* Purpose: Simulate for practice */

/* Set a seed for reproducibility */
%let myseed = 0930;

%include "D:/Repository/SAS-Studio/Applied Time Series/Simulate(HW2).sas";

%sim_arima(-1.3 -0.65 -0.325 -0.16125 -0.08063, n_sim = 300);

proc arima data = work.sim_data(rename = (p = z));
  identify var = z;
  run;
  estimate p = 1 q = 1;
  run;
quit;


%sim_arima(-0.8 -0.5, type = 1, n_sim = 300);

proc arima data = work.sim_data(rename = (p = z));
  identify var = z;
  run;
  estimate p = 5;
  run;
quit;


%include "D:/Repository/SAS-Studio/Applied Time Series/Createdata.sas";

proc arima data = t_data_1;
  title "Without differencing";
  identify var = z stationarity = (adf = 2);
  run;
  estimate p = 1;
  run;
  estimate p = 3;
  run;
  title "With differencing";
  identify var = z(1);
  run;
  estimate q = 2;
  run;
quit;

  
proc arima data = t_data_2;
  identify var = z stationarity = (adf = 2);
  run;
  estimate p = 1;
  run;
  estimate p = 1 q = 1;
  run;
  estimate q = 1;
  run;
  estimate q = 2;
  run;
quit;


/* Practice for seasonal data */

data sim_season1;
  lastz1 = 0; lastz2 = 0; lastz3 = 0; lastz4 = 0; lastz5 = 0;
  lasta1 = 0; lasta2 = 0; lasta3 = 0; lasta4 = 0; lasta5 = 0;
  do i = -50 to 500;
    a = rannor(893);
    z = lastz1 + lastz4 - lastz5 + a - 0.8*lasta1 - 0.5*lasta4 + 0.4*lasta5;
    if i > 0 then output;
    lastz5 = lastz4; lastz4 = lastz3; lastz3 = lastz2; lastz2 = lastz1; lastz1 = z;
    lasta5 = lasta4; lasta4 = lasta3; lasta3 = lasta2; lasta2 = lasta1; lasta1 = a;
  end;
run;

proc arima data = sim_season1;
  identify var = z; run;
  identify var = z(1); run;
  identify var = z(1, 4); run;
  
  estimate q = (1,3,4,5); run;
  estimate q = (1)(4); run;
  estimate q = (1,4,5); run;
quit;


x "cd D:/Repository/SAS-Studio/Applied Time Series/";

/* Read in dataset */
filename rawdata 'Data';

data beer;
  infile rawdata("quarterly US beer production 1975 to 1982.txt");
  input _qt _year z;
  date = yyq(_year, _qt);
  format date yyq.;
  drop _:;
run;

proc arima data = beer;
  identify var = z; run;
quit;

/* Ozone dataset practice */
data ozone;
  set ozone;
  date = intnx('month','31DEC1954'd,_n_);
  format date monyy.;
run;

proc arima data = ozone;
  identify var = z(12); run;
  estimate q = (1)(12); run;
quit;



%include "D:/Repository/SAS-Studio/Applied Time Series/Createdata.sas";

/* leading sales practice */
proc arima data = lsale;
/*   identify var = x stationarity = (adf = 0); */
  identify var = x(1); run;
  estimate q = 1; run;
  identify var = y(1) crosscorr = (x(1)); run;
  estimate q = 1; run;
  estimate q = 1 input = (3$(2)/(1)x); run;
quit;






/* Final Exam */

x "cd D:/Repository/SAS-Studio/Applied Time Series/";

/* Read in dataset */
filename rawdata 'Data';

data hotel;
  infile rawdata("monthly hotel room averages.txt");
  input month room;
run;

/* Time series plot */
title "Monthly Hotel Room Averages";
proc sgplot data = hotel;
  series x = month y = room;
  xaxis label = 'Month' grid;
  yaxis label = 'Room' grid;
run;
title;

/* Box-Cox test */
proc transreg data = hotel;
    model boxcox(room) = identity(month);
run;

/* Reciprocal */
data hotel;
  set hotel;
  rec_room = 1/room;
run;

proc arima data = hotel;
  identify var = rec_room stationarity = (adf = 0); run;
  
  identify var = rec_room(12);
  estimate p = (1,6,12); *-2774.31;
  estimate p = (1,3,6,10,12,13); *-2792.16;
  run;  
quit;

