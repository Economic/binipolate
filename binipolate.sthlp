{smcl}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:binipolate} {hline 2} Bin data and linearly interpolate percentiles


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:binipolate }
{it:varname}
{ifin}
{weight}
{cmd:,}
{cmdab:b:insize(}{it:sizeofbin}{cmd:)}
[
{cmdab:p:ercentiles(}{it:numlist}{cmd:)}
{cmd:by(}{it:byvarlist}{cmd:)}
{opt collapsefun(collapsefunction)}
]

{pstd}where {it:collapsefunction} is a Stata collapse function with the same syntax
as the default {cmd:collapse} (like {cmd:gcollapse} or {cmd:fcollapse}).


{marker description}{...}
{title:Description}

{pstd}
{cmd:binipolate} bins {it:varname} into bins of length {it:sizeofbin} and
calculates linearly interpolated and classical (non-smoothed) percentiles
specified by {cmd:percentiles()}. Classical percentiles are calculated by
{cmd:collapse} or the function specified in {it:collapsefunction}.

{pstd}
{cmd:binipolate} replaces the original dataset in memory with a new dataset
containing the percentiles.

{pstd}
If {cmd:percentiles()} is empty, {cmd:binipolate}
returns the median.


{title:Examples}

    {hline}
{pstd}Calculate nominal wage percentiles by year and gender with the 2016-2017 EPI CPS ORG extracts{p_end}
{phang2}{cmd:. append_extracts, begin(2016m1) end(2017m12) sample(org)}{p_end}
{phang2}{cmd:. binipolate wage if wage > 0 & wage ~= . [pw=orgwgt], binsize(0.25) percentiles(10 50 90) by(year female)}{p_end}
