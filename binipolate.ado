* this code builds off of the program iquantile
* written by Nick Cox: https://ideas.repec.org/c/boc/bocode/s456992.html
* the main differences here are that this program will bin your data
* and then calculate both binned interpolated percentiles and classical percentiles
* and return those as a dataset
* also iquantile uses a slightly different definition of percentiles
* (based on the mid-distribution function)

program define binipolate
syntax varname(numeric) [if] [in] [fweight pweight], ///
BINsize(real) ///
[Percentiles(numlist >0 <100 int) by(varlist) collapsefun(string) wide classical bgen(name) cgen(name) pgen(name)]

* check bin size
capture assert `binsize' > 0
if _rc ~= 0 {
  noi di "binsize must be positive"
  error _rc
}

* check sample
marksample touse
if "`by'" != "" markout `touse' `by', strok
qui count if `touse'
if r(N) == 0 error 2000

* determine percentiles to calculate (default to 50th)
if "`percentiles'" == "" local percentiles 50

* identify by groups
if "`by'" == "" {
  tempvar by
  gen byte `by' = 1
}
tempvar group
qui egen `group' = group(`by') if `touse'
su `group' if `touse', meanonly
local numgroups = r(max)

* identify weights
tempvar w
if "`weight'" != "" {
	gen `w' `exp'
}
else {
	local weight pweight
	gen byte `w' = 1
}

* identify collapse function
* use specified function, or if not specified use Stata's official collapse
if "`collapsefun'" ~= "" noi di _n "Using collapse function `collapsefun'" _n
else local collapsefun collapse

* identify names of new bin/percentile names 
if "`bgen'" == "" local bgen `varlist'_binned
if "`cgen'" == "" local cgen `varlist'_classical
if "`pgen'" == "" local pgen percentile

* calculate percentiles
qui {

	if "`classical'" != "" {
		* calculate classical percentiles
		* define collapse list
		local collapselist ""
		foreach perc of numlist `percentiles' {
			local collapselist `collapselist' (p`perc') `cgen'`perc' = `varlist'
		}
		* collapse data
		noi di "Calculating classical percentiles..."
		preserve
		`collapsefun' `collapselist' (first) `group' [`weight' = `w'] if `touse', by(`by')
		reshape long `cgen', i(`group') j(`pgen')
		tempfile classical_data
		save `classical_data'
		restore
	}

	noi di "Calculating binned percentiles..."
	* collapse data by bin
	tempvar binvalue
	gen `binvalue' = floor((`varlist'-`binsize'/2)/`binsize')*`binsize'+ `binsize' + `binsize'/2
	`collapsefun' (sum) `w' (first) `group' if `touse', by(`by' `binvalue')

	* grab by-group mapping
	preserve
	`collapsefun' (first) `group', by(`by')
	keep `group' `by'
	tempfile bygroups
	save `bygroups'
	restore

	tempvar runningsum totalsum cdf
	bysort `by' (`binvalue'): gen `runningsum' = sum(`w')
	egen `totalsum' = total(`w'), by(`by')
	gen `cdf' = `runningsum' / `totalsum'

	* initialize postfile for results
	tempname memhold
	tempfile results
	local binnedoutputnames ""
	postfile `memhold' `group' `pgen' `bgen' using `results'

	* crucial that this is sorted
	sort `group' `binvalue'
	tempvar obs
	gen `obs' = _n

	forvalues g = 1/`numgroups' {
		foreach perc of numlist `percentiles' {
			sum `obs' if `cdf' <= `perc'/100 & `group' == `g'
			local below = r(max)
			local above = `below' + 1
			local value = `binvalue'[`below'] + (`binvalue'[`above']-`binvalue'[`below']) * (`perc'/100 - `cdf'[`below']) / (`cdf'[`above'] - `cdf'[`below'])
			post `memhold' (`g') (`perc') (`value')
		}
	}
	postclose `memhold'

	use `results', clear
	* merge bygroup mapping
	merge m:1 `group' using `bygroups', assert(3) nogenerate
	if "`classical'" != "" merge 1:1 `group' `pgen' using `classical_data', assert(3) nogenerate
	sort `by'
	order `by'
}

if "`wide'" != "" {
	qui {
		if "`classical'" != "" reshape wide `bgen' `cgen', i(`group') j(`pgen')
		else reshape wide `bgen', i(`group') j(`pgen')
	}
}

end
