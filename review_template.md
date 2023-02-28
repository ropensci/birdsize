<!---
Below, please enter values for (1) submitting author GitHub handle (replacing "@github_handle@); and (2) Repository URL (replacing "https://repourl"). Values for additional package authors may also be specified, replacing "@github_handle1", "@github_handle2" - delete these if not needed. DO NOT DELETE HTML SYMBOLS (everything between "<!" and ">"). Replace only "@github_handle" and "https://repourl". This comment may be deleted once it has been read and understood.
--->

Submitting Author Name: Renata Diaz
Submitting Author Github Handle: <!--author1-->@diazrenata<!--end-author1-->
Repository:  <!--repourl-->https://github.com/diazrenata/birdsize<!--end-repourl-->
Version submitted:0.0.0.9000
Submission type: <!--submission-type-->Standard<!--end-submission-type-->
Editor: <!--editor--> TBD <!--end-editor-->
Reviewers: <!--reviewers-list--> TBD <!--end-reviewers-list-->
<!--due-dates-list--><!--end-due-dates-list-->
Archive: TBD
Version accepted: TBD
Language: <!--language-->en<!--end-language-->
---



-   Paste the full DESCRIPTION file inside a code block below:

```
Package: birdsize
Title: Estimate Avian Body Size Distributions
Version: 0.0.0.9000
Authors@R: 
    person("Renata", "Diaz", , "renata.diaz@weecology.org", role = c("aut", "cre"),
           comment = c(ORCID = "0000-0003-0803-4734"))
Description: Generate estimated body size distributions for populations or communities of birds, given either species ID or species' mean body size. Designed to work naturally with the North American Breeding Bird Survey, or with any dataset of bird species, abundance, and/or mean size data.   
License: MIT + file LICENSE
URL: https://github.com/diazrenata/birdsize
BugReports: https://github.com/diazrenata/birdsize/issues
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.2.1
Suggests: 
    covr,
    ggplot2,
    knitr,
    rmarkdown,
    testthat (>= 3.0.0)
Config/testthat/edition: 3
Depends: 
    R (>= 2.10)
Imports: 
    rlang,
    dplyr,
    magrittr,
    purrr,
    stats
VignetteBuilder: knitr

```


## Scope

- Please indicate which category or categories from our [package fit policies](https://ropensci.github.io/dev_guide/policies.html#package-categories) this package falls under: (Please check an appropriate box below. If you are unsure, we suggest you make a pre-submission inquiry.):

	- [ ] data retrieval
	- [ ] data extraction
	- [ ] data munging
	- [ ] data deposition
    - [ ] data validation and testing
	- [ ] workflow automation
	- [ ] version control
	- [ ] citation management and bibliometrics
	- [ ] scientific software wrappers
	- [x] field and lab reproducibility tools
	- [ ] database software bindings
	- [ ] geospatial data
	- [ ] text analysis

- Explain how and why the package falls under these categories (briefly, 1-2 sentences):


This package automates a workflow (seen in the wild e.g. [here](https://doi.org/10.1111/j.1466-8238.2010.00576.x) and [here](https://doi.org/10.1101/2022.11.08.515659)) of generating estimates of body size and basal metabolic rate, from the individual to ecosystem level, for birds. In my presubmission inquiry (#561, https://github.com/ropensci/software-review/issues/561), the editors determined this was best described as "field and lab reproducibility tools" because it's automating a workflow used by empirical ecologists to work with field data. 

-   Who is the target audience and what are scientific applications of this package?

The target audience is ecologists/biodiversity scientists interested in studying the structure, function, and dynamics of bird populations and communities - specifically linking between abundances/population size and other dimensions of community function, like total biomass. Studying size-based and abundance-based properties of bird communities is key to understanding biodiversity and global change, but it is challenging for most ecologists because most survey methods do not collect size-related data. This package standardizes a computationally-intensive workaround for this challenge and makes it accessible to ecologists with relatively little computational training.

-   Are there other R packages that accomplish the same thing? If so, how does yours differ or meet [our criteria for best-in-category](https://ropensci.github.io/dev_guide/policies.html#overlap)?

I have not encountered another package that accomplishes this.

-   (If applicable) Does your package comply with our [guidance around _Ethics, Data Privacy and Human Subjects Research_](https://devguide.ropensci.org/policies.html#ethics-data-privacy-and-human-subjects-research)?

N/A

-   If you made a pre-submission inquiry, please paste the link to the corresponding issue, forum post, or other discussion, or @tag the editor you contacted.

https://github.com/ropensci/software-review/issues/561

The editor who responded to me was @annakrystalli.

As part of that conversation, the question was raised of adding the authors of some of the datasets that this package draws on as "data contributors". I want to make sure that this is done in the way that best describes the way the data are used.

This package uses two sources of "external" data:

- First, the `sd_table` dataset included in the package includes (cleaned and selected) data values hand-entered from the CRC Handbook of Avian Body Masses (Dunning 2008; https://doi.org/10.1201/9781420064452). Neither Dunning, nor the authors of the studies cited in the CRC Handbook, were involved in this project. In the current iteration, I've followed the approach I would use for a paper - that is, the package and package documentation cite Dunning liberally, but I have not listed any additional authors as "data contributors"  because I generally wouldn't list folks as co-authors without their knowledge and consent. In this context, would you encourage listing Dunning as a contributor, and/or reaching out to open that conversation?

- Second, this package is designed to _interface_ with the North American Breeding Bird Survey data (https://www.sciencebase.gov/catalog/item/5d65256ae4b09b198a26c1d7, doi:10.5066/P9HE8XYJ), but I have taken care not to redistribute any actual data from the Breeding Bird Survey in the package itself. The `demo_route_raw` and `demo_route_clean` data tables in `birdsize` are synthetic datasets that mimic data from the Breeding Bird Survey. That is, they have the same column names as BBS data, and valid AOU (species identifying codes) values, but the actual data values are simulated. The `bbs-data` vignette directs users to instructions for accessing the BBS data, and demonstrates using the functions in `birdsize` on BBS-*like* data using the demo routes. Again, the package cites the Breeding Bird Survey liberally, but stops short of redistributing data so as to encourage users to access and cite the creators directly.

For both of these, again, I'm happy to explore whatever approaches to citing/crediting the original data creators seems most appropriate! I'd appreciate any thoughts or guidance in this area. 


-   Explain reasons for any [`pkgcheck` items](https://docs.ropensci.org/pkgcheck/) which your package is unable to pass.

N/A

## Technical checks

Confirm each of the following by checking the box.

- [x] I have read the [rOpenSci packaging guide](https://devguide.ropensci.org/building.html).
- [x] I have read the [author guide](https://devdevguide.netlify.app/authors-guide.html) and I expect to maintain this package for at least 2 years or to find a replacement.

This package:

- [x] does not violate the Terms of Service of any service it interacts with.
- [x] has a CRAN and OSI accepted license.
- [x] contains a [README with instructions for installing the development version](https://ropensci.github.io/dev_guide/building.html#readme).
- [x] includes [documentation with examples for all functions, created with roxygen2](https://ropensci.github.io/dev_guide/building.html#documentation).
- [x] contains a vignette with examples of its essential functions and uses.
- [x] has a [test suite](https://ropensci.github.io/dev_guide/building.html#testing).
- [x] has [continuous integration](https://ropensci.github.io/dev_guide/ci.html), including reporting of test coverage.

## Publication options

- [ ] Do you intend for this package to go on CRAN? *tbd*
- [ ] Do you intend for this package to go on Bioconductor?

- [X] Do you wish to submit an Applications Article about your package to [Methods in Ecology and Evolution](http://besjournals.onlinelibrary.wiley.com/hub/journal/10.1111/(ISSN)2041-210X/)? If so:

<details>
<summary>MEE Options</summary>

- [x] The package is novel and will be of interest to the broad readership of the journal.
- [x] The manuscript describing the package is no longer than 3000 words.
- [x] You intend to archive the code for the package in a long-term repository which meets the requirements of the journal (see [MEE's Policy on Publishing Code](http://besjournals.onlinelibrary.wiley.com/hub/journal/10.1111/(ISSN)2041-210X/journal-resources/policy-on-publishing-code.html))
- (*Scope: Do consider MEE's [Aims and Scope](http://besjournals.onlinelibrary.wiley.com/hub/journal/10.1111/(ISSN)2041-210X/aims-and-scope/read-full-aims-and-scope.html) for your manuscript. We make no guarantee that your manuscript will be within MEE scope.*)
- (*Although not required, we strongly recommend having a full manuscript prepared when you submit here.*)
- (*Please do not submit your package separately to Methods in Ecology and Evolution*)

</details>

## Code of conduct

- [x] I agree to abide by [rOpenSci's Code of Conduct](https://ropensci.org/code-of-conduct/) during the review process and in maintaining my package should it be accepted.
