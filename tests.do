set more off
clear all

adopath ++ .

sysuse auto, clear 
binipolate price, binsize(500) by(foreign) classical
list, ab(20) 
