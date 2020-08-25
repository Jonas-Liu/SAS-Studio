/* Practice the hash object */

/* proc print data = sashelp.cars(obs=10);run; */

%macro Topbottom(n);

  data tmp_t tmp_b;
    drop _:;
    if 0 then set sashelp.cars(keep = model type
                                      horsepower weight);
    if _n_ = 1 then do;
      declare hash tmp(dataset: 'sashelp.cars',
                       ordered: 'descending');
      tmp.definekey('horsepower', 'weight');
      tmp.definedata('model', 'type',
                     'horsepower', 'weight');
      tmp.definedone();
      declare hiter C('tmp');
    end;
    C.first();
    do _i = 1 to &n;
      output tmp_t;
      C.next();
    end;
    C.last();
    do _i = 1 to &n;
      output tmp_b;
      C.prev();
    end;
  run;

  title "Top &n Horsepower and Weight";
  proc print data = tmp_t;
  run;
  title;

  title "Bottom &n Horsepower and Weight";
  proc print data = tmp_b;
  run;
  title;

%mend Topbottom;

%Topbottom(2)
%Topbottom(7)

