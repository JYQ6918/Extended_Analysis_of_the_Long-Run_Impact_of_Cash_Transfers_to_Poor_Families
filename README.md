# Extended Analysis of the Long-Run Impact of Cash Transfers to Poor Families

## Introduction of the Original Research by Aizer et al. (2016)
    To reduce the long-lasting negative effect of poverty on children, the United States government established welfare programs to help children born in poor families. The Mothers’ Pension (MP) program which was investigated by Aizer et al. (2016) was one of the welfare programs. The program gave cash transfers to poor mothers with dependent children. Aizer et al. (2016) used rejected mothers who were eligible to apply to the MP program as the control group and accepted mothers as the treatment group. They studied the average treatment effect (ATE) of cash flow on boys’ longevity and the mechanism behind it. 
    This design assumed that mothers and children in the control and treatment groups had similar observable characteristics (i.e. conditional independence). Researchers concluded that the cash transfers increased boys’ longevity by about 1 year, and the positive effect was larger on boys in poorer families. This conclusion resulted from the simple regression method which assumed the homogeneous treatment effect. 
## What My Research do
### 1. Found Evidence of Heterogeneous Effect (Table 1 in Result Folder)
    Replicating the same regression as the original paper but using only data from one state each time, evidence showed that the cash transfers had a heterogeneous instead of homogeneous treatment effect on the longevity of boys in different states.
### 2. Estimate This Heterogeneous Effect (Table 2)
    Regression adjustment (RA) and inverse probability weighting (IPW) approaches are used to allow the heterogeneous treatment effect on different people
### 3. Estimate A Different Parameter ATT (Table 3)
    Since there is evidence of heterogeneous effect, the average treatment effect (ATE) is highly possible to be different from the average treatment effect on treated (ATT). Therefore, ATT is estimated.
### 4. Sensitivty Analysis (Table 4-5)
    Investigated sensitivity analysis to check how stable the results that Aizer et al. (2016) obtained were. 
    In table 4, non-core variables that should not impact the original model are included as covariates (e.g length of children’s names)
    In table 5, non-core covariates are dropped from the original model: the indicating dummy of missing date of birth information, the indicating dummy of missing mother’s marriage status information, the length of children’s name, and the ratio of state manufacturing annual earnings to US manufacturing.
## Results
    Although Aizer et al. (2016) estimated a significant positive ATE of cash transfers on boys’ longevity, this result was not robust enough when the heterogeneous treatment effect was allowed. Generally, ATE and ATT of cash transfers were zero except for the ATE estimated by the model including the state and cohort dummies. It disagreed with the original paper’s conclusion. When the covariates in the regressions measuring the ATE changed, the positive ATE of cash transfers obtained by the original paper did not change much. This was the evidence showing that this positive ATE was stable and robust to the changes in specification.

### Specific statistical results can be found in the result folder



 ## Citation to the Original Paper   
Aizer, Anna, Shari Eli, Joseph Ferrie, and Adriana Lleras-Muney. 2016. "The Long-Run Impact of Cash Transfers to Poor Families." American Economic Review, 106 (4): 935-71.
[Original_Paper_Link](https://www.aeaweb.org/articles?id=10.1257/aer.20140529)
