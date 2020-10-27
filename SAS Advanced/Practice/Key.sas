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


proc sql;

select avg(city) into: cityavg from work.city where region = "ARM" group by region;quit; %put &cityacg
/* Practice Lab Tasks */

data temp;
  set sashelp.cars(obs = 10);
run;

/* Lab 1 */

proc sql;
  select a.type, a.make, avg(b.MSRP)
    from sashelp.cars as a inner join work.temp as b
      on a.type = b.type and a.make = b.make
    group by a.type, a.make;
quit;












proc fcmp outlib = work.function.lab;
  function trans(in);
    cm = in*2.54;
  return(cm);
  endsub;
run;

options cmplib = work.function;

data lab2;
  set work.tmp2;
  newheight = trans(height);
  
  array New[3] CM1 - CM3;
  array LS[3] IN1 - IN3;
  array num[*] _numeric_;
  
  do i = 1 to 3;
    New[i] = trans(LS[i]);
  end;
  
  
  do i = 1 to dim(num);
    if num[i] = . then num[i] = 0;
  end;
  
run;










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
  input in1 in2 in3 height;
  do _i = 1 to 3;
    new[_i] = trans(old[_i]);
    if missing(new[_i]) then new[_i] = 0;
  end;
  newheight = trans(height);
  
  datalines;
  1 1.2 2 12
  2 . 3 4
  . 3.3 4 .
  4 5.2 . 7
  ;
run;

/* lab 3 */

%let num = 1.25;
%macro incre;

/* %put: This is a comment */

  %do %until (&num ge 2);
    %let num = %sysevalf(&num + 0.25);
    %put &num;
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






/* lab 5 */

data act01;
  set sashelp.pricedata;
  array p[*] price:;
  do _i = 1 to dim(p);
    p[_i] = p[_i]*1.1;
  end;
run;


/* lab 6 */

data _null_;
  set sashelp.cars(obs = 1);
  call symputx('CarMaker', Make);
run;
%put &CarMaker;


/* lab 7 */

proc sql;
  create table work.sql01 as
    select make, avg(mpg_city) as avgcitympg
      from sashelp.cars
      group by make;
quit;
