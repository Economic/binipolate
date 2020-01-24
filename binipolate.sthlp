{smcl}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{p2colset 5 19 23 2}{...}
{p2col :{cmd:binipolate} {hline 2}}Bin
data and linearly interpolate percentiles.{p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{phang}
This command replaces the dataset in memory with a dataset containing linearly interpolated percentiles.

{p 8 17 2}
{cmd:binipolate }
{it:varname}
{ifin}
{weight}
{cmd:,}
{cmdab:b:insize(}{it:sizeofbin}{cmd:)}
[
{cmdab:p:ercentiles(}{it:numlist}{cmd:)}
{cmd:by(}{it:varlist}{cmd:)}
{opt collapsefun(function)}
{opt classical}
{opt bgen(newvar)}
{opt cgen(newvar)}
{opt pgen(newvar)}
]

{phang}
where {cmdab:b:insize(}{it:sizeofbin}{cmd:)} is the desired size of the bins.
{p_end}

{synoptset 25 tabbed}{...}
{marker table_options}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opth percentiles(numlist)}}list of percentiles as percentages; default is 50 (the median).
{p_end}
{synopt :{opth by(varlist)}}groups over percentiles are to be calculated.
{p_end}
{synopt :{opt classical}}also calculate classical (non-binned) percentiles.
{p_end}
{synopt :{opth bgen(newvar)}}new variable for values of binned percentiles; default is {it:varname_binned}.
{p_end}
{synopt :{opth cgen(newvar)}}new variable for values of classical percentiles; default is {it:varname_classical}.
{p_end}
{synopt :{opth pgen(newvar)}}new variable for values of binned percentiles; default is {it:varname_binned}.
{p_end}

{syntab:Extras}
{synopt :{opt collapsefun(function)}}Use a Stata collapse function with the same syntax as the default {cmd:collapse} (like {cmd:gcollapse} or {cmd:fcollapse}).
{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}

{pstd}
{cmd:binipolate} bins {it:varname} into bins of length {it:sizeofbin} and
calculates linearly interpolated percentiles specified by {cmd:percentiles()}.

{pstd}
{cmd:binipolate} replaces the original dataset in memory with a new dataset
containing the percentiles.

{pstd}
If {cmd:percentiles()} is empty, {cmd:binipolate}
returns the median.

{pstd}
{opt classical} will optionally calculate classical percentiles by
{cmd:collapse} or the function specified in {opt collapsefun()}. Computation speed is often much faster when using {cmd:gcollapse} from the gtools package: {opt collapsefun(gcollapse)}.

{title:Examples}

    {hline}
{pstd}Calculate nominal wage percentiles by year and gender with the 2016-2017 EPI CPS ORG extracts{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. binipolate price, binsize(500) by(foreign) classical}{p_end}

{title:Website}

{pstd}
{cmd:binipolate} is maintained at {browse "https://github.com/Economic/binipolate":github.com/Economic/binipolate}
{p_end}