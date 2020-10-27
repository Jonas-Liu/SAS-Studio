/* Author: Zheng */
/* Purpose: Try the MCMC method for PD modeling */



/* Import the delinquent training data from google drive */

%let id = %nrstr(17507kG2kskvOiz49Xp9k8Fs5PqFhDuEi);
%let _url = %nrstr(https://docs.google.com/uc?export=download&id=)&&id;

filename _tmp "%sysfunc(getoption(work))/del.sas7bdat";
proc http method="get" 
 url="&_url" 
 out=_tmp;
run;
filename _tmp clear;

data example;
  set del;
  rename cscore_b = fico gdp_annual_rate = gdp;
  if next_stat = "SDQ" then SDQ = 1;
    else SDQ = 0;
  keep cltv cscore_b gdp_annual_rate sdq;
run;

/* Try with the binary logistic regression model */

proc logistic data = example;
  model sdq = CLTV FICO GDP / outroc = roc_example rsq;
  store out = log_example;
run;

/* Using MCMC method without any prior information */

proc mcmc data = example
          statistics = all
          diagnostics = all
          nmc = 10000 scale = 5 mintune = 5 
          nbi = 1000 thin = 2 propcov = quanew
          seed = 123
          ;
  parms b0 b1 b2 b3;
  prior b0 b1 b2 b3 ~ normal(0, var = 1000);
  pd = probnorm(b0 + b1*CLTV + b2*FICO + b3*GDP);
  model sdq ~ binomial(1,pd);
run;
