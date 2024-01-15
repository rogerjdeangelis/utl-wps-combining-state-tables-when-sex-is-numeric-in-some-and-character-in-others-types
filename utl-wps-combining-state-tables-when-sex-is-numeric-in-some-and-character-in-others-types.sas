%let pgm=utl-wps-combining-state-tables-when-sex-is-numeric-in-some-and-character-in-others-types;

Combining 51 state tables when sex is numeric in some and character in others mixed types;

   ie Male   = M in master and Male=0(numeric) in transaction
   ie Female = F in master and Male=1(numeric in transaction

github
http://tinyurl.com/5ecws9dz
https://github.com/rogerjdeangelis/utl-wps-combining-state-tables-when-sex-is-numeric-in-some-and-character-in-others-types

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                            |                                            |                                              */
/*  Stack Ohio and Iowa       |          ERROR                             |      FIX                                     */
/*                            |                                            |                                              */
/*  data both;                |  ERROR: Variable SEX has been              |    proc sql;                                 */
/*    set sd1.ohio sd1.iowa;  |     defined as both character and numeric. |                                              */
/*  run;quit;                 |                                            |      create                                  */
/*                            |                                            |         table us as                          */
/*                            |                                            |      select                                  */
/*                            |                                            |         name                                 */
/*                            |                                            |        ,cats(sex) as sex                     */
/*                            |                                            |      from                                    */
/*                            |                                            |         ohio(obs=3)                          */
/*                            |                                            |      union                                   */
/*                            |                                            |         all                                  */
/*                            |                                            |      select                                  */
/*                            |                                            |         name                                 */
/*                            |                                            |        ,cats(sex) as sex                     */
/*                            |                                            |      from                                    */
/*                            |                                            |         sd1.iowa(obs=3)                      */
/*                            |                                            |                                              */
/*                            |                                            |    ;quit;                                    */
/*                            |                                            |                                              */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_ ___
| | `_ \| `_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.ohio;
  set sashelp.class(obs=3 keep=name sex);
run;quit;

data sd1.iowa;
   set sashelp.class(obs=3 drop=sex);
   sex=mod(_n_,2);
   keep name sex;
run;quit;

/**************************************************************************************************************************/
/*                        |                                                                                               */
/*         OHIO           |         IOWA                                                                                  */
/*                        |                                                                                               */
/*  SD1.OHIO total obs=3  |  SD1.IOWA total obs=3                                                                         */
/*                        |                                                                                               */
/*  Obs     NAME      SEX |  Obs     NAME      SEX                                                                        */
/*                        |                                                                                               */
/*   1     Alfred      M  |   1     Alfred      1                                                                         */
/*   2     Alice       F  |   2     Alice       0                                                                         */
/*   3     Barbara     F  |   3     Barbara     1                                                                         */
/*                        |                                                                                               */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utl_submit_wps64x('
libname sd1 "d:/sd1";
options validvarname=any;
proc sql;

  create
     table sd1.us as
  select
     name
    ,cats(sex) as sex
  from
     sd1.ohio(obs=3)
  union
     all
  select
     name
    ,cats(sex) as sex
  from
     sd1.iowa(obs=3)

;quit;
');

*/ /*************************************************************************************************************************
*/ /*
*/ /*
*/ /*  SD1.US total obs=6
*/ /*
*/ /*  Obs     NAME      SEX
*/ /*
*/ /*   1     Alfred      M
*/ /*   2     Alice       F
*/ /*   3     Barbara     F
*/ /*   4     Alfred      1
*/ /*   5     Alice       0
*/ /*   6     Barbara     1
*/ /*
*/ /*************************************************************************************************************************

/*__ _             _    __ _
 / _(_)_ __   __ _| |  / _(_)_  __
| |_| | `_ \ / _` | | | |_| \ \/ /
|  _| | | | | (_| | | |  _| |>  <
|_| |_|_| |_|\__,_|_| |_| |_/_/\_\

*/

/*----                                                                   ----*/
/*----  WORKS in WPS R any Python SQL                                    ----*/
/*----                                                                   ----*/

proc sql;
  create
    table sd1.usfix as
  select
    name
   ,case
      when (sex = '0') then 'M'
                     else 'F'
    end as sex
  from
    sd1.us
;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.USFIX total obs=6                                                                                                  */
/*                                                                                                                        */
/* Obs     NAME      SEX                                                                                                  */
/*                                                                                                                        */
/*  1     Alfred      F                                                                                                   */
/*  2     Alice       F                                                                                                   */
/*  3     Barbara     F                                                                                                   */
/*  4     Alfred      F                                                                                                   */
/*  5     Alice       M                                                                                                   */
/*  6     Barbara     F                                                                                                   */
/*                                                                                                                        */
/**************************************************************************************************************************/


/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
