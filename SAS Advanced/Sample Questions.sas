/* Question 1 */

data act01;
  set sashelp.pricedata;
  array p[*] price:;
  do _i = 1 to dim(p);
    p[_i] = p[_i]*1.1;
  end;
run;

/* Question 2 */

data _null_;
  set sashelp.cars(obs = 1);
  call symputx('CarMaker', Make);
run;
%put &CarMaker;


/* Question 3 */

proc sql;
  create table work.sql01 as
    select make, avg(mpg_city) as avgcitympg
      from sashelp.cars
      group by make;
quit;