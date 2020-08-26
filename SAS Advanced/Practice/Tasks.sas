/* This contains several practice tasks */
/* To get some basic sense about the advanced lab projects */

/* Please save your work with comments */
/* Run this to create datasets that used for practice */

data temp;
  set sashelp.cars(obs = 10);
run;

data tmp2;
  input in1 in2 in3 height;
  datalines;
    1 1.2 2 12
    2 . 3 4
    . 3.3 4 .
    4 5.2 . 7
  ;
run;


/* -------------------------------Start Here------------------------------ */
/* --------------------------------DONT RUN------------------------------- */


/* Lab 1 */

- Create a table work.lab1 from sashelp.cars which contains 
  - Columns: unique combination of Type and Make, and AvgMSRP
  - Calculate AvgMSRP as the average value of MSRP for each pair of Type and Make
  - Only show rows that match those type and make in work.temp
  
- Print work.lab1

/* Lab 2 */

- Create a function using PROC FCMP
  - Save that function in work.function table and called that package LAB
  - Named the function TRANS with one parameter
  - Use this function to transfer inch into centimeters(1in = 2.45cm)
  
- Guid SAS to find your function

- Create dataset work.lab2 using dataset work.tmp2
  - Call your function TRANS to transfer variable height from IN to CM and saved it newhieight
  - Keep the missing value as missing

/* Lab 2 Plus */

- Create dataset work.lab2P using dataset work.tmp2
  - This time, use array to transfer columns IN1 to IN3 from IN to CM
  - Create a new array NEW contains CM1 to CM3 to save the results
  - Use a new array NUM to save all the numeric variables and assign zero to the missing values

/* Lab 3 */

- Create a macro variable NUM with initial value 1.25 and a macro function INCRE
  - Use a macro do loop with until/while to increase NUM by 0.25
  - Print the value of NUM into log during each iteration
  - In your function, add a comment "%put: This is a comment" with out running it
  - Call the macro function
  
/* Lab 4 */

- Use SQL procedure to create table work.lab4 using sashelp.cars
  - Which contains the average WEIGHT for each type and the TYPE
  - Only show those rows with avg_WEIGHT larger than the overall mean level
  
- Save the value of those average weight as a series of macro variables: avgw1, avgw2 ....
  - Save those TYPEs as a macro variable and separated with ', '
  - Print them into the log
  - Dont print out anything else


/* Lab 5 */

- Use ARRAY update all the price with 10% tax
  - Save the output data as work.act01, use the sashelp.pricedata table
  - Update price colunms with an extra 10%
  - Dont create any new varables
  
  
/* Lab 6 */

- Use DATA step to create a macro variable
  - Which contains the MAKE of the first observation in sashelp.cars
  - Name it CARMAKER
  
/* Lab 7 */

- Use SQL to create a table work.sql01
  - From table sashelp.cars contains MAKE and avgcitympg
  - Create avgcitympg as the average of MPG_CITY for unique MAKE

