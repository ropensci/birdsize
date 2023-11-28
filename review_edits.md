---
editor_options: 
  markdown: 
    wrap: 72
---

# R1

Review Comments (annotations mine :))

> This is a useful, well-documented package with a clear and well
> defined scope. The documentation and vignettes have plenty of examples
> that I think most users should easily be able to follow. In addition
> to suggestions I've made in an earlier comment, I have a few
> suggestions that I think would improve the package documentation and
> align the source code better with best practices.

> Working through the five vignettes, I did wonder if the vignette
> ordering and organization should be re-worked. For me, I found the
> population vignette to be the most useful for understanding what the
> package is actually doing under the hood. After working through this
> vignette, the community vignette made more sense to me. The species
> vignette covers an intermediate-level topic, so probably belongs next,
> followed by scaling since it's a more advanced topic that many users
> won't require knowledge of. Both the README and the "Getting Started"
> vignette contain essentially no code. This feels like missed
> opportunity to shown some of the most basic functionality, e.g.
> simulate a population of a single species and plot a histogram and/or
> simulate a community. Finally, there is fair amount of duplication in
> the vignettes, which makes me wonder if some of them could be combined
> together into one? All this may just be personal preference though,
> and other users may find the current organization better, but
> something to think about.

Thanks for the feedback! The vignettes have been re-organized. Most of the content from the "population" and "community" vignettes have been consolidated into the "Getting Started" vignette, with smaller examples shown in the README. The "species", "scaling", and "BBS Data" vignettes have remained as separate articles, because those are more in-depth dives into specific subtopics that may be of interest to subpopulations of users. 

> This package relies heavily on BBS data in all examples and package
> functionality. Given its prominence, I think there could more
> description of what the BBS is and the structure of the dataset. I
> initially assumed the bbs-data vignette would cover this, but it
> mostly duplicates what's already found in the community vignette
> without providing additional explanation of the BBS. I think at the
> very least a brief description of the route/stop structure, sampling
> design, and spatial/temporal coverage of the BBS is warranted. Also, I
> see the fields of demo_route_raw are described in the help for that
> dataset, but I think you should point users to that help file or
> directly include a description of the fields in the bbs-data vignette.
> I don't think you need to get into extensive detail since all of this
> is explained in other places, which you've referenced, but you should
> provide at least some explanation.


This is really helpful outside perspective! In this revision:

- There is additional context on the Breeding Bird Survey, including methods and its connection to this project, in the README. 
- There is a direct link from the BBS Data vignette to the help page for `demo_route_raw`, which includes (brief) explanations of the column names, and a link to the main BBS data page for further information.

> Defining species in function arguments could be clarified. In the
> arguments to pop_generate() and species_define(), species can be
> identified either by AOU code or scientific name. Given that both
> genus and species are required, it feels more intuitive to me to use a
> single argument (e.g. scientific_name). The documentation also doesn't
> make it clear that species is the species' epithet and not the
> scientific or common name. As it stands, it feels like you should be
> able to call pop_generate(100, species = "Selasphorus calliope") or
> even pop_generate(100, species = "Calliope Hummingbird").

In this version, the `genus` + `species` designation has been replaced by a single argument, `scientific_name`. 

In this revision, I did _not_ try to implement name matching based on the common name. My reasoning here was that the common name would be more prone to variations in spelling, etc, and so matching common names would be another layer of computational infrastructure. This does seem like a good feature to add in later iterations, or one that I could put more thought into if it seems like it would be very widely used! 

> I wonder if the \_summarize() functions are necessary since they're
> essentially just calling group_by() %\>% summarize(). Personally I'd
> prefer to do this directly myself with dplyr so I know exactly what's
> going on and the vignettes could demonstrate exactly how users should
> do it. However, I can imagine that some users aren't as comfortable
> with dplyr so these convenience functions could be useful.

I agree. In this version, the `*summarize` functions are removed. I added a short demo of computing summary values using `dplyr` in the Getting Started vignette. (This also made it easier to remove tidyverse dependencies, see later comments!)

> The internal function ind_draw() seems dangerous to me since it has a
> while loop to get rid of negative sizes with potential to run for a
> very long time. This is especially true because there appears to be no
> checks to ensure the mean size is positive. For example the following
> will run indefinitely:

> pop_generate(1000, mean_size = -1000, sd_size = 0.001)

> At the very least, please add a check to ensure mean_size and sd_size
> are positive and some method to ensure the while loop won't run
> forever, e.g. after a certain number of iterations maybe it should
> stop and raise an error. Even better would be re-writing this function
> to use a less brute force method to ensure the sizes generated aren't
> negative. It's not immediately clear what that would look like, since
> simple solutions like take the absolute value, won't preserve the
> desired normal distribution.

Wow, thank you for recognizing this! This completely did not occur to me, but is of course a significant potential bug! 

In this version, I've taken the suggestion to use `truncnorm::rtruncnorm` to draw from a normal distribution truncated with a lower bound of 1 (i.e. 1 gram of bird). Additionally, `pop_generate` now issues a message if the combined mean and standard deviations provided are likely to produce negative values.

> Some additional, specific comments about the code:

> ```         
> I believe the standard for documenting package datasets is to document them all in R/data.R rather than individual R files. Not a huge issue, but I think this would help anyone interested find the source for the documentation more easily. See https://r-pkgs.org/data.html#sec-documenting-data.
> ```

Ah, ok! The dataset documentation is now all in R/data.R.

> ```         
> Related to the previous point, you might consider renaming or re-grouping some of the other source files. For example, the only exported function in R/simulate_populations.R is pop_generate(), so why not call that file R/pop_generate.R so it's more obvious what's in the file?
> ```

I've rearranged the functions and tried to create a closer match between the functions in a file and the file name. I've kept some single-function scripts (ind_draw.R, pop_generate.R) and grouped others thematically. I hope this is easier to navigate?

> dplyr has deprecated or superseded a lot of the "scoped" verbs, e.g.
> group_by_at(). Please replace these as appropriate to future proof
> your package. See <https://dplyr.tidyverse.org/reference/scoped.html>

Yikes, and this is good to keep in mind. I've removed all `dplyr` verbs except for those in the vignette. 

> I see some inconsistency in code styling. For example, in some places
> you use if() and in other places if (). I recommend picking one method
> of formatting your code and sticking with it. See
> <https://style.tidyverse.org/>.

I've reformatted the code using `styler`. 

> In a few places I see you're using as.numeric(NA) or is.character(NA)
> (e.g.
> <https://github.com/diazrenata/birdsize/blob/main/R/species_define.R#L56>).
> Note that there are NAs specifically for different data types, i.e.
> NA_real\_ and NA_character\_. It seems cleaner to use these rather
> than casting NA to different data types.

I've replaced nonspecific NAs with data-type-specific NAs.  

> There are a handful of unnecessarily nested if statements (e.g.
> <https://github.com/diazrenata/birdsize/blob/main/R/species_define.R#L54>).
> Anywhere you have if (A) {if (B) {...}} I think it's cleaner to use if
> (A && B) {...}, but that may just be personal preference.

I've kept these mostly as written, perhaps because it's just much easier for me to parse. 
I'm happy to revisit this!

# R2

> I think the purpose of the package is well-defined. It does a few
> well-defined and related tasks, and does them well. It also has
> demonstrated use cases, which is nice. The vignettes were
> well-organized and do a good job of providing examples of all the
> functions. I've divided my comments into three categories: code style,
> documentation, and "science stuff."

> Code style review

> The DESCRIPTION file states that the package depends on R \>=2.10 but
> the tidyverse dependencies require R \>= 3.3.

With the removal of tidyverse dependencies, I _believe_ R >= 2.10 will be sufficient. 

> I agree with Matt that the documentation of the package datasets
> should be in one data.R file which is a little easier to navigate
> (though this is not too relevant to users as they won't ever see that,
> but it would be helpful for contributors)

Absolutely! The dataset documentation is now consolidated in data.R. 

> This is a tough one, but I generally try to shy away from having
> tidyverse dependencies in packages. For example the lines with
> dplyr::mutate() could be rewritten from

> community \<- community %\>% dplyr::mutate( richnessSpecies =
> .data\$aou, species_designator = "aou" )
>
> to
>
> community[['richnessSpecies']] \<- community[['aou']]
> community[['species_designator']] \<- "aou"

> I understand this would be a lot of work to implement because
> tidyverse is used in most of your functions. If you do not want to
> fully remove the tidyverse dependencies, the most urgent one to
> address would be to replace dplyr::group_by_at() with
> dplyr::group_by(dplyr::across()). group_by_at() has been deprecated
> and will likely be removed from future versions of dplyr. (I'm in
> agreement with Matt's advice on that point).

> ```         
> Also, having tidyverse dependencies greatly increases the number of downstream dependencies for the package which might not be desirable.
> ```

These comments (and conversations outside this) encourage me to move
away from tidyverse dependencies. In this revision, the tidyverse packages are removed, except for examples shown in the vignettes. 

> I also agree with Matt that it would be good to at least rewrite the
> code not to use the magrittr pipes %\>% for the reasons he cited.

This revision has removed the magrittr pipe. The examples use the new base R pipe (`|>`).

> ```         
> In filter_bbs_survey(), package data are loaded with unidentified_species <- unidentified_species. I am not sure that is the recommended way to internally use package data. I noticed Matt also brought this up so I would follow his advice there.
> ```

I've removed these calls loading internal data. This has introduced the NOTES of "no visible binding for global variable". [RMD - Check that this is still the case when next connected to wifi]

> In simulate_populations(), the error checking routines that cause
> failure if things like mean and standard deviation aren't provided is
> one level down in the ind_draw() function. To me it would make more
> sense if the input is checked for errors right away instead of further
> down.

This version has the error checking occurring at both levels. This makes it slightly easier to trace if a user is running `pop_generate` (new name for `simulate_populations`), and keeps the guardrails on within `ind_draw` as well. 

> Line 33 of species_data_functions.R: the argument data to lm() should
> be named.

Done! (Now at line 24).

> Documentation review

> ```         
> I thought the vignettes were well-organized and do a good job of providing examples of all the functions. One suggestion is that the vignettes could have more informative titles. Just the word community does not make it clear exactly what can be learned from going through the vignette.
> ```

I hope this is addressed by re-organizing the vignettes so most of the general-purpose information is in "Getting Started", and the remaining vignettes have clear, specific content (BBS data, scaling relationship, species definitions). 

> I also liked the Taylor Swift example but shouldn't the species be
> Taylor and the genus Swift? :-D

Noted, and updated. :D 

> A user copying and pasting code from the vignettes will not be able to
> run the code containing tidyverse functions including select() and
> pmap_df() because those packages are not explicitly loaded in the
> vignette.

The package calls have been made visible in the vignettes. 

> The term "AOU" should be defined somewhere - it is known to North
> Americans but not otherwise. I understand this package is most
> intended for use with BBS so users will be familiar but it can't hurt
> to define so that other people can understand what it is (maybe not
> necessarily the user but someone looking over the code). A related
> minor point: in some of the functions where AOU is an argument, it is
> in lowercase aou but I think it would be more consistent to make it
> capitalized AOU.

I've expanded references to the AOU in the vignettes and code documentation to the "AOU numeric code" and added links to the BBS page. I've also capitalized user-facing instances of "AOU".

Interestingly, in doing this I found that the BBS AOUs appear to differ from the (more recent) codes put out by the American Ornithological Union. It looks to me like the AOU itself has switched to four-letter alpha character codes, but the BBS has kept with the (original, I believe) numeric codes. So the only lookup table for the AOU numbers to species is the BBS list, which I have linked to. 

> The bar plot with total biomass by AOU in the community vignette, as
> Matt mentioned, would be more informative with species names instead
> of AOU codes. Also, because the fill color legend is redundant with
> the axis labels, it would be cleaner to just label the x axis with the
> species names and suppress the legend of fill colors.

This plot has been removed with the vignette rearrangement, but I've updated the other plot legends to use scientific names instead of AOUs. 

> Comments on science stuff

> I would feel better about it if you explicitly incorporated
> uncertainty in the scaling relationships. The parameters for the
> relationship between body mass mean and standard deviation are average
> expectations, so you would end up underestimating the variation in
> body mass if you only use that mean expectation to impute missing
> standard deviations. Is there any way of incorporating uncertainty in
> those scaling parameters?

This is a tough question. Generally when _I_ work with this method,
I take the estimated mass and sd as the limit of the precision of this
approach. The uncertainty is also variable among species - for some we
have estimates and some measurements; for some species many measurements
and some just one; and from different locations and times and
investigators. For these reasons, I handle these estimates as
"best-guesses suitable for broad-scale questions, but with some
significant limitations as things get precise". I've added language to this effect in the vignettes and README. 

> It would be nice to allow filter_bbs_survey() to take arguments so
> that the user could customize removing specific species groups. For
> instance it would be interesting if the user could remove only
> waterbirds and keep nocturnal birds, if they were so inclined.

This is an interesting suggestion. To implement it I would need to expand the database of masses included in the package, which would mean going back to Dunning (2008) - which invites expanding the data further than (necessarily) just the Breeding Bird Survey species. I think this becomes a wider conversation about the scope of data reproduction in the package vs. shifting that onto a user. I haven't implemented it in this revision, but if it seems like a necessary value-add it would be possible.

> The real heart of the body mass distribution simulation is in the file
> simulate_populations.R in ind_draw() at line 34:

> population \<- rnorm(n = species_abundance, mean = species_mean, sd =
> species_sd)
>
> while (any(population \< 0)) { population[which(population \< 0)] \<-
> rnorm(n = sum(population \< 0), mean = species_mean, sd = species_sd)
> }

> This looks like you are doing rejection sampling to generate samples
> from a truncated normal distribution with lower truncation bound of 0.
> I think that is fine, but it should be made clear in the documentation
> that you are doing this. I might even recommend allowing the user to
> input a lower truncation bound instead of hard-coding it at 0 (the
> default could be 0 but you could allow the user to modify this). For
> example the user might want to ensure that all masses are greater than
> 2 grams (that is roughly the lowest value I got when I generated the
> body masses for a_hundred_hummingbirds). Not too many birds weigh less
> than the Calliope Hummingbird! :-) Actually, in general I don't think
> it is clear in your documentation that samples are drawn from a normal
> distribution. Yes, it is implied by the fact that the parameters are
> mean and standard deviation but I think it would be good to be
> explicit about it. I also wanted to address Matt's point that the
> while loop in the rejection sampling may run infinitely or nearly so
> if invalid input is provided such as negative body mass. It would be
> good for you to expand the error checking code to cause failure on
> body mass means that are not positive, avoiding the potential of an
> infinite (or almost infinite loop).

> ```         
> To further address the point about the rejection sampling method, Matt mentioned in his review that it would be good to use a "less brute force" method to ensure the values are >0. Actually, the method of rejection sampling that you are currently using is a well-accepted method. It is used by the R package truncnorm. For almost any realistic values of body mass mean and sd, you will get very few negative values on the initial sample, so the while loop would hardly ever even be necessary. However, if you are interested in a more direct method of sampling from a truncated normal without the while loop, I would check out [this Stackoverflow thread](https://stats.stackexchange.com/questions/56747/simulate-constrained-normal-on-lower-or-upper-bound-in-r) especially [this answer](https://stats.stackexchange.com/a/510821/54923). There are also the existing functions msm::tnorm() and truncnorm::truncnorm() but you may not want to add a dependency to your package.
> ```

This is a really good and important observation (see the earlier response to Matt's comment)! I went ahead and switched over to `truncnorm::rtruncnorm` to avoid the negative-values problem. 

I've also added sections right at the beginning of both the README and Getting Started vignette clarifying the assumption of the normal distribution. 

# Others

-   Regarding @ maelle's comment regarding test files and source file names: I have renamed the test files to correspond more closely to the file names.
-   tests fail due to an issue with unzip on windows. 👀
-   I've reached out to Dr. Dunning and he agreed to be listed as a Data Contributor. I've added him with this revision. 
-   I reviewed the Small Fixes PR from @ mstrimas. Because of the scope of revisions, I ended up not merging that pull request and instead implementing the same changes on the revised codebase. Specifically, I tidied up the DESCRIPTION using desc::desc_normalize(), removed `remotes::install_github` from the README, switched T/F to TRUE/FALSE, and switched 1:nrow() to seq_len(nrow()). = was changed to <- via the lintr cleanup, and use of .data$ was removed with the removal of tidyverse functions.

# From editor:

* I'd recommend running desc::desc_normalize(): it will order DESCRIPTION fields in a standard way and order dependencies alphabetically. 
    * *Response*: Done!
*   You can remove the {remotes} installation instructions and keep the {devtools} ones only as {devtools} calls {remotes} (might call {pak} in the future?) and is the interface for users. 
    * *Response*: Done!
* It'd be nice to add grouping to the reference index https://pkgdown.r-lib.org/reference/build_reference.html#reference-index Given your package's naming scheme, you might want to use the starts_with() helper. 
    * *Response*: I haven't done this because there are so few functions, it seems to me like it verges on redundant. I'm happy to revisit this!
*    In the test filenames, why use numbers? If the R files and test files have the same basename, it's easier to navigate between the two in RStudio IDE. https://r-pkgs.org/testing-basics.html#test-organisation
    * *Response*: Ah, I learned to use the numbers so that tests fail informatively in order. The tests also don't - all - correspond directly to RScripts. Is this a major barrier? If so, I'm happy to revisit!
*   In your test files and scripts I see a lot of vertical space, more than one empty lines between some elements. I'd recommend using one empty line only as it increases the amount of code one can see at a time on the screen. It's still nice to organize the code in paragraphs, I am not suggesting to remove all empty lines. 😁 
    * *Response*: I  think this has been largely addressed via the re-styling I've done, but please let me know if the issue persists!
*   In the README instead of "Package summary" as a header you could use the same text as this issue "birdsize: Estimate avian body size distributions" which is more informative. 
    * *Response*: Done!
*   Regarding data yes it might make sense to contact the author of the included dataset? 
    * *Response:* Done! I've reached out and Dr. Dunning agreed to be listed as a contributor. I've sent a more recent-follow up with the revisions and giving him the opportunity to confirm. I'm still waiting to hear back there, and will let you know. 
*   For comments such as https://github.com/diazrenata/birdsize/blob/7469df457989a9016ecc3761b0dd125497a3be51/R/simulate_community.R#L51 if you add 4 hyphens afterwards ----, the comment will appear in the script outline on the right in RStudio IDE (if you use that IDE), helping code navigation. https://blog.r-hub.io/2023/01/26/code-comments-self-explaining-code/#use-comments-for-the-scripts-outline 
    * *Response*: I've added these to the long community_generate script.
*   why have this "trivial" test file? https://github.com/diazrenata/birdsize/blob/main/tests/testthat/test-01_trivial.R 
    * *Response*: I use this to test that CI is working, but it's not needed now the package is built. Deleted!
*   in test code you don't need to write birdsize::: as testthat loads your package code. Example https://github.com/diazrenata/birdsize/blob/7469df457989a9016ecc3761b0dd125497a3be51/tests/testthat/test-02_included_data.R#L13 
    * *Response*: These are removed!
*   why are some expectations commented out? https://github.com/diazrenata/birdsize/blob/7469df457989a9016ecc3761b0dd125497a3be51/tests/testthat/test-07_simulate_community.R#L34 
    * *Response*: These were vestigial, removed!

