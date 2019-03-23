### ADDITIONAL OPTIONS

#### Using GARLI in place of RAxML

RAxML is much faster than Garli and can use multiple processors, but GARLI has more available models. To use GARLI, you need to provide the option:

  `--usegarli`

  and

  `--garli_conf`

Example Garli configuration files are available (examples/garli.conf and examples/aa.garli.conf). For an in-depth explanation of all of the options, see the Garli manual available from: http://www.bio.utexas.edu/faculty/antisense/garli/garli.html

The nucleotide model specified in `examples/garli.conf` is GTR+GAMMA. The amino acid model specified in `examples/aa.garli.conf` is WAG+GAMMA. To adjust either of these the following parameters should be adjusted in garli.conf:

    `ratematrix`, `statefrequencies`, `ratehetmode`, `numratecats`, `invariantsites`

We highly recommend not adjusting other parameters in the garli conf files as this could cause `sowhat` to fail.


Parametric bootstrap tests rely heavily on the model used for data simulation. `sowhat` provides a number of options for exploring models and examining the results.

#### Using PhyloBayes CAT-GTR model

When using `sowhat` with RAxML, the user can specify that data be simulated using parameters estimated with the CAT-GTR model in a posterior probability framework in PhyloBayes. This model allows for more parameters free to vary. The likelihood scoring will still be performed using the RAxML model specified. The option is

  `--usepb`

#### Using the maximum parameters

Using both RAxML and GARLI, the user can specify that parameter estimation and data simulation be performed using the maximum number of free parameters. For example, in RAxML with nucleotide data, the model GTRGAMMAIX would be used for data simulation, which allows rates, frequencies, alpha value, and invariant sites to all be estimated using likelihood. This option is

 `--max`

#### Using a specified model

The user can additionally specify a model for data simulation. The format for this model is demonstrated in the files `examples/simulation...`. For nucleotide data, rates and frequencies must be specified. For aminoacid data, a matrix may be provided, or if the GTR model is speicified, a rate file can be provided which includes a symmetrical 20 by 20 matrix of aminoacid rates. Alpha and invariant site parameters may also be included. This option is

 `--usegenmodel`

### SOME RECIPES

#### The classic Goldman+Susko SOWH test

This test evaluates whether a null hypothesis can be rejected, given the data. Data is simulated using parameters estimated under the null hypothesis. The generating topology uses a polytomy for the conflicting clades of interest, as recommended by Susko et al 2014. No additional options need be specified.

#### Testing two trees

This test evaluates whether the data, assuming a specific topology, provides significant support to reject a second topology. Use the options `--constraint=... --treetwo=... --resolved`

#### Testing the SOWH test

There are a number of options for verifying the results of the SOWH test. Multiple simultaneous SOWH tests can be performed and the mean and the ratio of the means can be plotted and examined (files ending in .eps in the specified directory). Use the options `--runs=(number of tests) --plot`

#### Specifying an evolutionary hypothesis

The user can simulated data under very specific models, including specifying abnormal rate matrices and a specific generating topology. This test evaluates whether, assuming evolution under these conditions, can the null hypothesis be rejected. Use the options `--usegenmodel=... --usegentree=...`

#### Evaluating sensitivities

The most thorough approach to parametric bootstrapping is one in which the user changes the model options, evaluates the effects on the resulting p-value, and reports any indication that the null hypothesis cannot be rejected. To accomplish this, the user can perform a series of SOWH tests changing the model, using each of the following options:

 `--usepb` 

 which uses a model with a high number of free parameters to simulated the data

 `--rerun`

 which recalculates the test statistic and parameters each iteration, to marginalize over any effects resulting from the likelihood software failing to find the optimal topology

 `--nogaps`

 which simulates data without any gaps; more information will be present in simulated data than in empirical data, which can affect the null distribution