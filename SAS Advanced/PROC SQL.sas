
data test;
a = 'abc';
b = 'c';
c = 1;
run;

proc sql;
  insert into work.test
    set a = 'a',
      b = 'b'
    set a = 'aa',
      c = .22
      ;
  select *
    from work.test;
  insert into work.test
    (a,c)
    values('',12)
    values('1',.);
  select *
    from work.test
    where a is not missing;
  select *
    from work.test;
  
  create view work.tmp as
    select *
      from work.test;
  describe view work.tmp;
quit;

proc sql;
  update work.test
    set c = c*100
    where a = 'aa';
  select *
    from work.test;
quit;

proc sql;
  drop view work.tmp;
quit;

proc sql;
  create table work.test2 as
    select *
      from work.test;
  update work.test2
    set a = 'a';
quit;

proc sql;
  select *
    from work.test;
  select *
    from work.test2;
  select a, c
    from work.test union
  select a, c
    from work.test2;
quit;


* Advanced SQL;
proc sql;
  select a
    into: m_a separated by ' '
    from work.test;
quit;

%put &m_a;

%put %eval(1 = 2);
