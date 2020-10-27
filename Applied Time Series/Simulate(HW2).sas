/* Author: Zheng Liu */
/* Purpose: This program is to get the answer for the homework 2 */

/* Set a seed for reproducibility */
%let myseed = 0909;


/* This macro function will get the simulation result and pass it to the PROC ARIMA */
/* The parameter for the AR model is phi, and theta for the MA model */

%macro sim_arima(param,        /* Parameter list (space separated, comma separated for ARMA) */
                 type = p,     /* p = for the AR model   */
                               /* q = for the MA model   */
                               /* number = for the ARMA model (i.e. 2 means first 2 parameters for AR) */
                 n_sim = 1000, /* Simulation times */
                 print = 1     /* Print the identify and estimate */
                 )/minoperator;
  
  /* Get the number of parameters */
  %let n = %sysfunc(countw("&param", ' '));
  
  data work.sim_data;
    drop _:;
    array lag[&n] (&n*0);         /* Initialization */
    array param[&n] (&param);
    
    do _i = -100 to &n_sim;       /* Burn-in period of length 100 */
      q = rannor(&myseed);
      _sum = 0;
      
      do _j = 1 to &n;
        _sum + lag[_j] * param[_j];
      end;
      
      p = q + _sum;
      if _i gt 0 then output work.sim_data;
      
      %if &type in p q %then %do;  
        do _j = &n to 1 by -1;
          if _j = 1 then lag[_j] = &type;
            else lag[_j] = lag[_j-1];
        end;
      %end;
      %else %do;
        do _j1 = &n to %eval(&type+1) by -1;
          if _j1 = %eval(&type+1) then lag[_j1] = q;
            else lag[_j1] = lag[_j1-1];
        end;
        do _j2 = &type to 1 by -1;
          if _j2 = 1 then lag[_j2] = p;
            else lag[_j2] = lag[_j2-1];
        end;
      %end;
      
    end;
    
  run;
  
/*   title "Parameters: &param"; */
/*   title2 "Simulation times: 50"; */
/*   proc arima data = work.sim_data(obs = 50  */
/*                                   rename = (p = z)); */
/*     identify var = z nlag = 24; */
/*     run; */
/*     %if &type in p q %then %do; */
/*       estimate &type = &n; */
/*       run; */
/*     %end; */
/*     %else %do; */
/*       estimate p = &type q = %eval(&n-&type); */
/*       run; */
/*     %end; */
/*   quit; */
/*   title2; */
  
  %if &print %then %do;
    title2 "Simulation times: &n_sim";
    proc arima data = work.sim_data(rename = (p = z));
      identify var = z nlag = 24;
      run;
      %if &type in p q %then %do;
        estimate &type = &n;
        run;
      %end;
      %else %do;
        estimate p = &type q = %eval(&n-&type);
        run;
      %end;
    quit;
    title2;
    title;
  %end;
  
%mend sim_arima;

%macro sim_run();
  /* Output to a pdf file */
  ods pdf file = "HW2.pdf"
          style = Sapphire;
    ods noproctitle;
    options nodate nonumber pdfpageview = FITPAGE;
    
    /* Start simulation */
    %sim_arima(0.3 -0.4)
    %sim_arima(1.2 -0.8)
    %sim_arima(0.5 0.24, type = q)
    %sim_arima(0.9, type = q)
    %sim_arima(1.7 -0.7)
  
  ods pdf close;
  quit;
%mend sim_run;
