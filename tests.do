set more off
clear all

adopath ++ .

append_extracts, begin(2016m1) end(2017m12) sample(org)
binipolate wage if wage > 0 & age <= 64 [pw=orgwgt], p(10 50 90) binsize(0.25) by(year female) collapsefun(gcollapse)
list
