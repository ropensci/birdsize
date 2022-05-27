I'm having trouble identifying where to start with this because I'm having trouble wrapping my head around where it *is* and what needs to happen next. Ok.

Overall the core intended funcationality of this package is to simulate size measurements for birds based on either a species ID (following BBS AOU) or a mean body size (if you want to do simulations).

Body masses are simulated as draws from a normal distribution with mean and standard deviation.

If you supply a species code, look up these parameters from the lookup table (`sd_table`).

If you supply a species' mean, simulate the sd according to the scaling relationship (use `estimate_sd`).

-----

Other wider and further afield questions include...

- species name lookup fxn (make AOU table user-visible, possibly include string search fxns)
- supplying a species x abundance table (apply core sim fxn over multiple species)
- supply a bbs route and year(s) ---> x this would require including bbs data *in the package* which is a whole attributions and data management and data updating situation that I think actually hampers broader utility more than it necessarily helps
- 0 standard deviation (use species' means only)
- estimating individual level bmr
- returning community-wide summary statistics (total biomass, total energy use, mean individual size, mean individual bmr)


-----

Vignettes for different use cases

Vignettes or add-on fxns for plotting and analyzing ISDs? again may be drifting more specialized

-----

am I then going to refactor bbs-size-shifts to use this package? yep, probably. should not be too hard

-----

s e e d s. this is a rabbit hole but I'm unsure whether to muck about with seeds in this package at *all*, or if you can set.seed() and then call a function from this package (that runs rnorm()) and have the seed stay consistent. i.e. leave seed management up to the user. or if you have to set the seed *within a function*. on reflection it seems pretty sus to build an r package that messes around with your seeds, but scope. idk.
