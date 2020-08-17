
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
		from work.test;
quit;


%put %eval(1 = 2);
