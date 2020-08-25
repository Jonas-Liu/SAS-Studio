libname certadv "D:/Repository/SAS-Studio/SAS Advanced/certadv";

/* Scenario 1 */

proc fcmp outlib = work.function.add;
  function Adding(Val);
    Final = 38+Val;
  return(Final);
  endsub;
run;

option cmplib = work.function;

data work.StudentCost;
  set certadv.all;
  Final_Cost = Adding(Fee);
run;

proc print data = work.StudentCost;
  var Student_Name Course_Code Fee Final_Cost;
  format Final_Cost dollar5.;
run;


/* Scenario 2 */

proc format;
  picture monthfmt  low -< 1 = 'Not a valid month'
                    1 - 12 = '99'
                    12 <- high = 'Not a valid month'
                    ;
run;

proc print data = certadv.monsal;
  format month monthfmt.;
run;


/* Scenario 3 */

data success fail;
  length ctname $ 30;
  if _n_ = 1 then do;
    call missing(CtName);
    declare hash C (dataset:'certadv.continent');
      C.definekey('ID');
      C.definedata('CtName');
    C.definedone();
  end;
  set certadv.airports;
  rc = C.find();
  if rc then output fail;
    else output success;
run;


/* Scenario 4 */

%macro test(vars, dsn);
  footnote "Printed on %sysfunc(today(),worddate.)";
  proc print data = &dsn;
    var &vars;
    where begin_date = 21774;
  run;
  footnote;
%mend test;

%test(course_code fee, certadv.all)

/* Scenario 5 */

%macro courseloc();
  proc sql noprint;
    select distinct location
      into: loc1-
      from certadv.schedule;
  quit;
  %do i = 1 %to &sqlobs;
    title "Courses Offered in &&loc&i";
    proc print data = certadv.schedule;
      where location = "&&loc&i";
    run;
  %end;
  
%mend courseloc;
%courseloc()
  
/* Scenario 6 */

%let job = Analyst;
data staff;
  set certadv.staff(where = (jobtitle contains "&job")) end = last;
  total + salary;
  count + 1;
  if last then do;
    call symputx('avg', put(total/count,dollar9.));
  end;
run;

title "&job Staff";
footnote "Average Salary: &avg";
proc print data = staff;
run;
title;
footnote;
  

/* Scenario 7 */

proc sql;
  create table work.bonus as
    select EmpID, JobCode, Salary,
           Salary*.1 as Bonus
      from certadv.empdata
      order by jobcode, salary;
  select *
    from work.bonus;
quit;

/* Scenario 8 */

proc sql number;
  create table work.raise as
    select a.EmpID, LastName, a.Salary, NewSalary,
           newsalary-a.salary format = dollar10.2 as Raise
      from certadv.empdata a inner join certadv.newsals b
        on a.empid = b.empid
      where calculated Raise > 3000
      order by empid;
  select *
    from work.raise;
quit;

/* Scenario 9 */

proc sql;
  select cat('Total Paid to All', jobtitle, 'Staff'),
         sum(salary) format = dollar14. label = 'TotalSalary',
         count(jobtitle) format = comma14. label = 'Total'
    from certadv.salesstaff
    group by jobtitle;
quit;


/* Scenario 10 */ 
 
proc sql number;
  create view work.phonelist as
    select o.Department format = $25.,
           a.EmployeeName format = $25.,
           p.PhoneNumber format = $16. label = 'Home Phone'
      from certadv.empadd as a inner join certadv.emporg as o 
           on a.employeeid = o.employeeid 
           inner join certadv.empph as p
           on a.employeeid = p.employeeid
      where p.phonetype = 'Home';
  title 'Sales Management Department Home Phone Numbers';
  select EmployeeName, PhoneNumber
    from work.phonelist
    where Department = 'Sales Management'
    order by EmployeeName;
quit;




/* Practice */
libname certadv "D:/Repository/SAS-Studio/SAS Advanced/certadv";

proc fcmp outlib = work.function.add;
  function add(val);
    final = val + 38;
  return(final);
  endsub;
run;

options cmplib = work.function;

data studentcost;
  set certadv.all;
  final_cost = add(fee);
run;

proc print data = studentcost;
  var student_name course_code fee final_cost;
run;

proc format lib = certadv fmtlib;
  picture monthfmt 1 - 12 = '99'
                   other = 'Not a valid month';
run;

options fmtsearch = (certadv);
proc print data = certadv.monsal;
  format month monthfmt.;
run;

data success fail;
  length CtName $30;
  if _n_ = 1 then do;
    call missing(CtName);
    declare hash C (dataset: 'certadv.continent');
      C.definekey('ID');
      C.definedata('CtName');
      C.definedone();
  end;
  set certadv.airports;
  rc = C.find();
  if rc = 0 then output success;
    else output fail;
run;
proc print data = success; run;
title "Printed on %sysfunc(today(),worddate.)";
proc print data = fail; run;
title;