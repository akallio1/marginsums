Project marginsums
==================

Statistical tools for margin sum based matrix null models from manuscript "Properties of fixed-fixed models and alternatives in presence-absence data analysis".

Initialization
--------------

Build the system:

```
cd code
./build.sh
```
Because of copyright reasons the Vanuatu dataset needs to be obtained from Diamond & Marshall (1976). Write down the presence-absence data table into a binary matrix and save it as `data/vanuatu.mat`. The matrix should have 56 rows and 28 columns with fill ratio of 0.564 (ratio of ones among all cells).

Initialize randomized datasets:

```
matlab
experiment_datasets_init.m
```
In the end you should have `data/datasets.mat` generated.

Experiments
-----------

Run the experiments:

```
matlab
experiment_convergence.m
experiment_datasets_run.m
experiment_datasets_print.m
```
