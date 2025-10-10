# Shiny Reproduction Example Application

<!-- badges: start -->
[![R-CMD-check](https://github.com/AscentSoftware/shinyreproapp/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AscentSoftware/shinyreproapp/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

This Shiny application is a demonstration of how the [shinyrepro](https://github.com/AscentSoftware/shinyrepro) package
can work within an application.

This Shiny application provides a modular, tab-based interface for exploring data outputs alongside the code 
used to generate them. It is designed to support reproducibility and transparency by showing both user-facing 
results and the underlying module code.

## Installation

### R Package

To get the latest version of the application, run the below code:

```r
install.packages("remotes")
remotes::install_github("AscentSoftware/shinyreproapp")
```

To run the app locally:

```r
library(shinyreproapp)
run_app()
```

### Docker

You can run this Shiny app using Docker for a consistent, dependency-free environment.

```shell
docker build -t shinyreproapp .
docker run -p 3838:3838 shinyreproapp
```

Then open your browser and go to: http://localhost:3838
