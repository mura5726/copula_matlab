MATLAB for R Users in Computational Finance
Demo 2 - Prototyping and Analysis

This example demonstrates creating a custom time-series model to simulate the returns for a correlated set of asset classes using a copula and fat-tailed marginals. The returns are used to compute the risk of a sample portfolio and as an input to a portfolio optimization to find optimal mean-CVaR portfolios.

The main script to run is copulaVaR

This example is based, in part, on the shipping demo in Econometrics toolbox titled "Using Extreme Value Theory and Copulas to Evaluate Market Risk"

Timing comparison:
An R script is provided that performs just the portfolio optimization component using fPortfolio in R. This can be used to compare the time it takes to compute optimal CVaR portfolios in MATLAB/Financial Toolbox and R/fPortfolio

Products Required:
MATLAB, Statistics Toolbox, Optimization Toolbox, Financial Toolbox

Optional products: 
Datafeed Toolbox

Copyright 2013 MathWorks, Inc.