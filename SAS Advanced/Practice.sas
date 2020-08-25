/* 63 Questions */


/* #11 */

data work.temp work.errors / view = work.temp;
  input Xa Xb Xc;  
  if Xa = . then output work.errors;
    else output work.temp;
run;

/* #29 */

data _null_ work.bad_data / view = work.bad_data;
  set work.tmp(keep = Xa Xb Xc);
  length _Check_ $ 10;
  if Xa = . then _check_ = trim(_Check_)!!" Xa";
  if Xb = . then _check_ = trim(_Check_)!!" Xb";
  if Xc = . then _check_ = trim(_Check_)!!" Xc";
  put Xa = Xb = Xc = _check_ = ;
run;

proc print data = bad_data;run;

/* #39 */

%let Mv = shoes;
%macro product(Mv = bike);
  %let Mv = clothes;
  %put inner Mv = &mv;
%mend product;
%product(M = tents)
%put outter Mv = &mv;



/* Practice Lab Tasks */

data temp;
  set sashelp.cars(obs = 10);
run;

/* Lab 1 */

proc sql;
  select a.type, a.make, avg(b.MSRP)
    from sashelp.cars as a left join work.temp as b
      on a.type = b.type and a.make = b.make
    group by a.type, a.make;
quit;



/* lab 2 */

proc fcmp outlib = work.function.lab;
  function trans(in);
    cm = 2.45*in;
  return(cm);
  endsub;
run;

options cmplib = work.function;

data lab2;
  array old[3] in1 - in3;
  array new[3] cm1 - cm3;
  
  drop _:;
  input in1 in2 in3;
  do _i = 1 to 3;
    new[_i] = trans(old[_i]);
    if missing(new[_i]) then new[_i] = 0;
  end;
  
  datalines;
  1 1.2 2
  2 . 3
  . 3.3 4
  4 5.2 .
  ;
run;

/* lab 3 */

%let num = 1.25;
%macro incre;

/* This is a comment */

  %do %until (&num ge 2);
    %let num = %sysevalf(&num + 0.25);
  %end;
%mend incre;

%incre
%put x = &num;


/* lab 4 */

proc sql;
  create table work.lab4 as
    select avg(weight) as avg_w, type
      from sashelp.cars
      group by type
      having avg_w > (select avg(weight) from sashelp.cars);
  select *
    into: avgw1 - , :type separated by ', '
    from work.lab4;
      
quit;

%put &avgw1, &avgw2;
%put &type;
  