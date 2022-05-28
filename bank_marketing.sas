/*load data into SAS*/
proc import datafile = "/home/yiekhye19990/bank_marketing/bank.csv"
out = work.bank
dbms = csv replace;
run;

/*
data step -> read & modify data 
proc step -> analyze data
*/
 
/*rename column names*/
data bank;
set work.bank;
rename default = is_credit_default
	   balance = average_yearly_balance
	   housing = housing_loan
	   loan = personal_loan
	   contact = contact_type
 	   day = last_contact_day
	   month = last_contact_month
	   duration = last_contact_duration
	   campaign = total_current_contact
	   pdays = total_passed_day
 	   poutcome = previous_outcome
	   previous = total_previous_contact
	   y = subscribed;
run;

/*show contents*/
proc contents data = work.bank;
run;

/*show 10 observations*/
proc print data = work.bank(obs=10);
run;

/*query*/
proc sql outobs=100;
select total_passed_day, total_previous_contact
from work.bank
where total_passed_day = -1
order by total_passed_day asc;
quit;

/*replace values*/
data bank;
set work.bank;
total_passed_day = tranwrd(total_passed_day,-1,0);
run;

/*format missing values*/
proc format;
 value $missfmt ' '='Missing' other='Not Missing';
 value  missfmt  . ='Missing' other='Not Missing';
run;

/*count missing values*/
proc freq data = work.bank;
format _character_ $missfmt.;
tables _character_ / missing nocum nopercent;
format _numeric_ missfmt.;
tables _numeric_ / missing nocum nopercent;
run;

/*descriptive statistics*/
proc means data = work.bank;
var _numeric_ ;
run;

proc freq data = work.bank order = freq;
tables _character_;
run;

/*data visualization*/
ods select histogram;
proc univariate data=work.bank;
histogram _numeric_;
run;

proc gchart data=work.bank;
vbar _character_;
run;

proc template;
	define statgraph data_visualization;
		begingraph;
			entrytitle "data_visualization";
 
			
			layout lattice / rows = 2 columns = 2;
 
				
				layout overlay;
					barchart category=subscribed;
				endlayout;
 
				
				layout overlay;
					scatterplot x=total_previous_contact y=last_contact_duration / 
					group=subscribed name="legend" datalabel=name;
        			discretelegend "legend";
				endlayout;
 
				
				layout overlay;
					histogram age;
				endlayout;				
 
				
				layout region;
					piechart category=job;
				endlayout;
			endlayout;
		endgraph;
	end;
run;
 
proc sgrender data=work.bank template=Data_Visualization;
run;


