#' ---
#' title: "Meshgrid Arrays in R"
#' output:
#'   pdf_document: default
#'   word_document: default
#'   html_document: default
#'   html_notebook: default
#' urlcolor: blue
#' always_allow_html: yes
#' ---
#' 
#' Go back to [fan](http://fanwangecon.github.io/CodeDynaAsset/)'s [R4Econ](https://fanwangecon.github.io/R4Econ/) Repository or [Intro Stats with R](https://fanwangecon.github.io/Stat4Econ/) Repository.
#' 
#' - r expand.grid meshed array to matrix
#' - r meshgrid
#' - r array to matrix
#' - r reshape array to matrix
#' - dplyr permuations rows of matrix and element of array
#' - tidyr expand_grid mesh matrix and vector
#' 
## ----GlobalOptions, echo = T, results = 'hide', message=F, warning=F-----
options(knitr.duplicate.label = 'allow')

## ----loadlib, echo = T, results = 'hide', message=F, warning=F-----------
library(tidyverse)
library(tidyr)
library(knitr)
library(kableExtra)
# file name
st_file_name = 'fs_meshr'
# Generate R File
purl(paste0(st_file_name, ".Rmd"), output=paste0(st_file_name, ".R"), documentation = 2)
# Generate PDF and HTML
# rmarkdown::render("C:/Users/fan/R4Econ/support/array/fs_meshr.Rmd", "pdf_document")
# rmarkdown::render("C:/Users/fan/R4Econ/support/array/fs_meshr.Rmd", "html_document")

#' 
#' # Mesh Matrix and Vector using dplyr expand_grid
#' 
#' In the example below, we have a matrix that is 5 by 2, and a vector that is 1 by 3. We want to generate a tibble dataset that meshes the matrix and the vector, so that all combinations show up.
#' 
#' Note *expand_grid* is a from tidyr 1.0.0.
#' 
## ------------------------------------------------------------------------
# it_child_count = N, the number of children
it_N_child_cnt = 5
# P fixed parameters, nN is N dimensional, nP is P dimensional
ar_nN_A = seq(-2, 2, length.out = it_N_child_cnt)
ar_nN_alpha = seq(0.1, 0.9, length.out = it_N_child_cnt)
mt_nP_A_alpha = cbind(ar_nN_A, ar_nN_alpha)

# Choice Grid
it_N_choice_cnt = 3
fl_max = 10
fl_min = 0
ar_nN_alpha = seq(fl_min, fl_max, length.out = it_N_choice_cnt)

# expand grid with dplyr
library(tidyr)
expand_grid(x = 1:3, y = 1:2)

tb_expanded <- as_tibble(mt_nP_A_alpha) %>% expand_grid(choices = ar_nN_alpha)

# display
kable(tb_expanded) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

#' 
#' # Mesh Matrix (meshgrid) for R  using expand.grid
#' 
#' ## Define Two Arrays and Mesh Them using expand.grid
#' 
#' Given two arrays, mesh the two arrays together.
#' 
## ------------------------------------------------------------------------

# use expand.grid to generate all combinations of two arrays

it_ar_A = 5
it_ar_alpha = 10

ar_A = seq(-2, 2, length.out=it_ar_A)
ar_alpha = seq(0.1, 0.9, length.out=it_ar_alpha)

mt_A_alpha = expand.grid(A = ar_A, alpha = ar_alpha)

mt_A_meshed = mt_A_alpha[,1]
dim(mt_A_meshed) = c(it_ar_A, it_ar_alpha)

mt_alpha_meshed = mt_A_alpha[,2]
dim(mt_alpha_meshed) = c(it_ar_A, it_ar_alpha)

# display
kable(mt_A_meshed) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
kable(mt_alpha_meshed) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

#' 
#' ## Two Identical Arrays, Mesh to Generate Square using expand.grid
#' 
#' Two Identical Arrays, individual attributes, each column is an individual for a matrix, and each row is also an individual
#' 
## ------------------------------------------------------------------------
# use expand.grid to generate all combinations of two arrays

it_ar_A = 5

ar_A = seq(-2, 2, length.out=it_ar_A)
mt_A_A = expand.grid(Arow = ar_A, Arow = ar_A)
mt_Arow = mt_A_A[,1]
dim(mt_Arow) = c(it_ar_A, it_ar_A)
mt_Acol = mt_A_A[,2]
dim(mt_Acol) = c(it_ar_A, it_ar_A)

# display
kable(mt_Arow) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
kable(mt_Acol) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

