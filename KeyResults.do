***Replication of Table 1 and Panel A, Table 2 of "Expected Returns to Crime and Crime Location"
***By Nils Braakman, Arnaud Chevalier and Tanya Wilson
***For ECO 726

capture cd "C:\Users\yanks\OneDrive\Desktop\Akpene\MA Work\Policy and Program Evaluation\Replication Project"
capture cd "your directory here"

cls
clear all

*installing relevant packages:
ssc install ftools
ssc install reghdfe
ssc install ppmlhdfe

*importing data:
use LSOAfinal, clear
describe
summarize

/*Generating Table 1, Table of Summary Statistics*/
estpost summarize BIPshare treat2 Blackshare DEshare urban totpop burglary robbery vehiclecrime violentcrime totexclburg //total dataset
eststo total

estpost summarize BIPshare treat2 Blackshare DEshare urban totpop burglary robbery vehiclecrime violentcrime totexclburg if treat2 == 0 // control group
eststo control

estpost summarize BIPshare treat2 Blackshare DEshare urban totpop burglary robbery vehiclecrime violentcrime totexclburg if treat2 == 1 //treatment group
eststo treatment 

esttab total control treatment, main(mean %15.3fc) aux(sd %15.3fc) ///
coeflabels(BIPshare "South Asian population" treat2 "Outlier in LA" Blackshare "Share of Black" ///
DEshare "Share of low-skilled households" urban "Rural(=1 if yes)" totpop "Total Population" ///
burglary "Burglary" robbery "Robbery" vehiclecrime "Vehicle crime" violentcrime "Violent crime" ///
totexclburg "Total crime, excluding burglary") ///
varwidth(36) mtitles("Total" "Control" "Treated")

esttab total control treatment using Table1.tex, replace ///
main(mean %15.3fc) aux(sd %15.3fc) ///
coeflabels(BIPshare "South Asian population" treat2 "Outlier in LA" Blackshare "Share of Black" ///
DEshare "Share of low-skilled households" urban "Rural(=1 if yes)" totpop "Total Population" ///
burglary "Burglary" robbery "Robbery" vehiclecrime "Vehicle crime" violentcrime "Violent crime" ///
totexclburg "Total crime, excluding burglary") ///
varwidth(36) mtitles("Total" "Control" "Treated")

/*Generating Panel A Table 2*/

*generating interaction terms for DiD 
generate interaction = BIPhypgoldpriceOUTLA 
generate BIParea = interaction > 0

*Table 2, Panel A, Column 1(local authority fixed trends, lsoa quadratic time trend)
reghdfe hypburg hypgoldprice BIParea interaction i.month, absorb(i.laid lsoaid#c.time lsoaid#c.time2) cluster(lsoaid)
eststo column1

*Table 2, Panel A, Column 2(lsoa fixed trends, lsoa quadratic time trend)
reghdfe hypburg hypgoldprice BIParea interaction i.month, absorb(i.lsoaid lsoaid#c.time lsoaid#c.time2) cluster(lsoaid)
eststo column2

*Table 2, Panel A, Column 3(local authority fixed trends, local authority by month and year fixed effects)
reghdfe hypburg hypgoldprice BIParea interaction, absorb(i.laid laid##i.time) cluster(lsoaid)
eststo column3

*Table 2, Panel A, Column 4(poisson regression, local authority fixed effects, lsoa quadratic time trend)
ppmlhdfe burglary hypgoldprice BIParea interaction i.month, absorb(i.laid lsoaid#c.time lsoaid#c.time2) cluster(lsoaid) sep(fe)
eststo column4

*Table 2, Panel A, Column 5(local authority fixed effects, lsoa quadratic time trends, regressor is binary variable indicating burglary)
generate anyburg = burglary > 0
reghdfe anyburg hypgoldprice BIParea interaction i.month, absorb(i.laid lsoaid#c.time lsoaid#c.time2) cluster(lsoaid)
eststo column5

esttab column1 column2 column3 column4 column5, ///
b(%9.3fc) se(%9.3fc) noconstant nodepvars indicate("Month Effects = *month") nostar ///
coeflabels(hypgoldprice "Gold Price" interaction "Treated neighbourhood*Gold price" BIParea "Treated neighbourhood") ///
varwidth(33) nomtitles

esttab column1 column2 column3 column4 column5 using Table2.tex, replace booktabs ///
b(%9.3f) se(%9.3f) nodepvars nostar stats(N, fmt(%9.0fc) labels("\$N\$")) ///
obslast noconstant alignment(D{.}{.}{-1}) varwidth(33) ///
coeflabels(hypgoldprice "Gold Price" interaction "Treated neighbourhood*Gold price" BIParea "Treated neighbourhood")  ///
indicate("Month Effects = *month") nomtitles
*log close






