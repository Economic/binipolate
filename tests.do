set more off
clear all

adopath ++ .

sysuse auto, clear 
binipolate price, binsize(500) by(foreign) classical wide
list, ab(20) 

sysuse auto, clear 
binipolate price, binsize(500) by(foreign) wide
list, ab(20) 

sysuse auto, clear 
binipolate price, binsize(500) by(foreign) classical
list, ab(20) 

sysuse auto, clear 
binipolate price, binsize(500) by(foreign)
list, ab(20) 
