
proc import datafile="&p_git/wineQualityTrain.csv" out=GIT.Wine dbms=csv;
run;


%let resp = quality;

data red(drop = type) white(drop = type);
  set GIT.Wine;
  if type = "Red" then output red;
  if type = "White" then output white;
run;


%macro logs(d_wine);
  ods output PearsonCorr = tmp(keep = variable P&resp
                               where = (P&resp < 0.05));
  proc corr data = &d_wine;
  run;
  
  data _null_;
    set tmp(where = (variable ne "&resp")) end = last;
    call symputx ('var'||left(_n_), variable);
    if last then call symputx ("num", _n_);
  run;
  
  %let var =;
  %macro varlist();
  %do i = 1 %to &num;
    %let var = &var &&var&i;
  %end;
  %mend varlist;
  %varlist;
  
  %put &var;
  
  title "Model selection for &d_wine wine data";
  proc logistic data = &d_wine;
    model &resp = &var / selection = score best = 1;
  run;
%mend logs;

%logs(red);
%logs(white);