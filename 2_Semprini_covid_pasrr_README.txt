README File for Data-Coding Do-File, 
"How Did Covid-19 Emergency State Waivers Suspending Pre-Admission Screenings Impact Cases, Deaths, and Capacity in Skilled-Nursing Facilities?"
Author: Jason Semprini, MPP

Date: 11/17/20

This do-file codes the outcome, identifier, and covariate data for the analysis. First, the SNF identifiers are switched to a numeric format, which is necessary for panel data research in STATA. For snf's with identifiers that include a character, the first two and final three digits of the identifer were used to create a pseudo identifier. Note, the identifier no longer needs to be used for identifing SNFs across data, but only needs to identify SNFs across the panel data framework.
Similiarly, the weekending data was transformed to a numeric (0-23) indicator. The final identifier data transformation was the creation of a dummy variable for for-profit snfs. 
The next set of code creates consistent count and binary indicators for all outcomes (cases, deaths, and capacity). Finally, the issue of submitting high-quality data was coded through a set of binary variables. 
This filealso recoded the dummy variables for the treatment indicator (old waiver, new waiver, no waiver) as opposed to any waiver, new waiver, no waiver. 
Next, the code eliminated duplicates (~1,190), which was necessary for creating a balancd panel. 