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

### Example Modules


| Module ID              | Description |
|------------------------|-------------|
| `bindTabUI`            | Demonstrates the use of `bindEvent()` and `bindCache()` within a reactive expression to control execution and caching behavior. |
| `ifelseTabUI`          | Shows how an `if/else` statement can be used inside a reactive to conditionally generate code and output, ensuring only relevant code is shown in the reproducible section. |
| `inputTabUI`           | Illustrates how a Shiny input (e.g., `input$var`) can be used directly within a reactive expression. |
| `multiLevelModuleUI`   | Demonstrates passing reactive expressions to a sub-module, where the actual rendering occurs in the parent module. |
| `passedReactiveTabUI`  | Highlights how a reactive object defined in one module can be passed and used in another module. |
| `reactiveTabUI`        | Shows how one reactive expression can be used as an input to another reactive, forming a reactive chain. |
| `reactiveValTabUI`     | Demonstrates the use of a `reactiveVal()` inside a reactive expression. |
| `reactiveValuesTabUI`  | Uses an element from a `reactiveValues()` object within a reactive expression, showing how to manage shared state. |

Each module includes:
- A brief description of the pattern being demonstrated.
- Select inputs (if applicable) to modify the output.
- A foldable code section showing the exact R code used.
- A sidebar displaying the module’s implementation for reproducibility.

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

You can run this Shiny app using Docker for a consistent, dependency-free environment. A GitHub PAT is required
to access the internal {shinyrepro} repository.

```shell
docker build --build-arg GITHUB_PAT=<YOUR_GITHUB_TOKEN> -t shinyreproapp .
docker run -p 3838:3838 shinyreproapp
```

Then open your browser and go to: http://localhost:3838
