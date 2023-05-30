---
editor_options: 
  markdown: 
    wrap: 72
---

## Documentation

- [ ] reorganize vignettes vs. README. 
- [ ] Make sure vignettes call dependencies properly
- [ ] ts
- [ ] make sure AOU is defined
- [ ] Clean up plots in vignettes
- [ ] Discuss/deal with uncertainty in estimates
- [ ] Make sure normal assumption is stated clearly


## Code

- [ ] combine genus and species as scientific_name
- [ ] consider moving the summarize functions to a vignette
- [ ] create brakes around negative body sizes
    - [ ] draw from a truncated normal
    - [ ] return a message (not an error) if the parameters supplied would make for a very tiny bird
- [ ] move all data documentation to data.R
- [ ] rename/rearrange source files
- [ ] remove scoped verbs (completed as part of removing tidyverse dependencies)
- [ ] use NA_character/NA-real
- [ ] think about reorganizing nested if statements
- [ ] get the R version correct in the DESCRIPTION. Tidyverse depends on R>3.3.
- [ ] Remove tidyverse dependencies
- [ ] Remove pipes
- [ ] Call package data correctly (not using the assignment operator)
- [ ] Move error checking from `ind_draw` to `simulate_populations`
- [ ] switch AOU to uppercase
- [ ] Match test file and source file names
- [ ] Debug unzip issue that is causing a test failure


## Other

- [ ] Consider adding waterbirds and nightbirds
- [ ] Message Dunning
