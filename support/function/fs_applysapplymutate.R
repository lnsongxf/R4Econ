#' ---
#' title: "R use Apply, Sapply and dplyr Mutate to Evaluate one Function Across Rows of a Matrix"
#' output:
#'   html_document: default
#'   word_document: default
#'   pdf_document: default
#'   html_notebook: default
#' urlcolor: blue
#' always_allow_html: yes
#' ---
#' 
#' Go back to [fan](http://fanwangecon.github.io/CodeDynaAsset/)'s [R4Econ](https://fanwangecon.github.io/R4Econ/) Repository or [Intro Stats with R](https://fanwangecon.github.io/Stat4Econ/) Repository.
#' 
#' ## Issue and Goal
#' 
#' - r apply matrix to function row by row
#' - r evaluate function on grid
#' - [Apply a function to every row of a matrix or a data frame](https://stackoverflow.com/questions/4236368/apply-a-function-to-every-row-of-a-matrix-or-a-data-frame)
#' - r apply
#' - r sapply
#' - sapply over matrix row by row
#' - apply dplyr vectorize
#' 
#' We want evaluate linear function f(x_i, y_i, ar_x, ar_y, c, d), where c and d are constants, and ar_x and ar_y are arrays, both fixed. x_i and y_i vary over each row of matrix. More specifically, we have a functions, this function takes inputs that are individual specific. We would like to evaluate this function concurrently across $N$ individuals.
#' 
#' The function is such that across the $N$ individuals, some of the function parameter inputs are the same, but others are different. If we are looking at demand for a particular product, the prices of all products enter the demand equation for each product, but the product's own price enters also in a different way.
#' 
#' The objective is either to just evaluate this function across $N$ individuals, or this is a part of a nonlinear solution system.
#' 
#' ## Set Up
#' 
## ----GlobalOptions, echo = T, results = 'hide', message=F, warning=F-----
rm(list = ls(all.names = TRUE))
options(knitr.duplicate.label = 'allow')

## ----loadlib, echo = T, results = 'hide', message=F, warning=F-----------
library(tidyverse)
library(knitr)
library(kableExtra)
# file name
st_file_name = 'fs_applysapplymutate'
# Generate R File
purl(paste0(st_file_name, ".Rmd"), output=paste0(st_file_name, ".R"), documentation = 2)
# Generate PDF and HTML
# rmarkdown::render("C:/Users/fan/R4Econ/support/function/fs_funceval.Rmd", "pdf_document")
# rmarkdown::render("C:/Users/fan/R4Econ/support/function/fs_funceval.Rmd", "html_document")

#' 
#' ## Set up Input Arrays
#' 
#' There is a function that takes $M=Q+P$ inputs, we want to evaluate this function $N$ times. Each time, there are $M$ inputs, where all but $Q$ of the $M$ inputs, meaning $P$ of the $M$ inputs, are the same. In particular, $P=Q*N$.
#' 
#' $$M = Q+P = Q + Q*N$$
#' 
## ----setup---------------------------------------------------------------
# it_child_count = N, the number of children
it_N_child_cnt = 5
# it_heter_param = Q, number of parameters that are heterogeneous across children
it_Q_hetpa_cnt = 2

# P fixed parameters, nN is N dimensional, nP is P dimensional
ar_nN_A = seq(-2, 2, length.out = it_N_child_cnt)
ar_nN_alpha = seq(0.1, 0.9, length.out = it_N_child_cnt)
ar_nP_A_alpha = c(ar_nN_A, ar_nN_alpha)

# N by Q varying parameters
mt_nN_by_nQ_A_alpha = cbind(ar_nN_A, ar_nN_alpha)

# display
kable(mt_nN_by_nQ_A_alpha) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "responsive"))

#' 
#' ## Using apply
#' 
#' First we use the apply function, we have to hard-code the arrays that are fixed for each of the $N$ individuals. Then apply allows us to loop over the matrix that is $N$ by $Q$, each row one at a time, from $1$ to $N$.
#' 
## ----linear_apply--------------------------------------------------------

# Define Implicit Function
ffi_linear_hardcode <- function(ar_A_alpha){
  # ar_A_alpha[1] is A
  # ar_A_alpha[2] is alpha

  fl_out = sum(ar_A_alpha[1]*ar_nN_A + 1/(ar_A_alpha[2] + 1/ar_nN_alpha))

  return(fl_out)
}

# Evaluate function row by row
ar_func_apply = apply(mt_nN_by_nQ_A_alpha, 1, ffi_linear_hardcode)

#' 
#' ## Using sapply
#' 
#' - r convert matrix to list
#' - Convert a matrix to a list of vectors in R
#' 
#' Sapply allows us to not have tohard code in the A and alpha arrays. But Sapply works over List or Vector, not Matrix. So we have to convert the $N$ by $Q$ matrix to a N element list
#' Now update the function with sapply.
#' 
## ----linear_sapply-------------------------------------------------------

ls_ar_nN_by_nQ_A_alpha = as.list(data.frame(t(mt_nN_by_nQ_A_alpha)))

# Define Implicit Function
ffi_linear_sapply <- function(ar_A_alpha, ar_A, ar_alpha){
  # ar_A_alpha[1] is A
  # ar_A_alpha[2] is alpha

  fl_out = sum(ar_A_alpha[1]*ar_nN_A + 1/(ar_A_alpha[2] + 1/ar_nN_alpha))

  return(fl_out)
}

# Evaluate function row by row
ar_func_sapply = sapply(ls_ar_nN_by_nQ_A_alpha, ffi_linear_sapply,
                        ar_A=ar_nN_A, ar_alpha=ar_nN_alpha)

#' 
#' ## Using dplyr mutate
#' 
#' - dplyr mutate own function
#' - dplyr all row function
#' - dplyr do function
#' - apply function each row dplyr
#' - applying a function to every row of a table using dplyr
#' - dplyr rowwise
#' 
## ----linear_dplyr--------------------------------------------------------
# Convert Matrix to Tibble
ar_st_col_names = c('fl_A', 'fl_alpha')
tb_nN_by_nQ_A_alpha <- as_tibble(mt_nN_by_nQ_A_alpha) %>% rename_all(~c(ar_st_col_names))
# Show
kable(tb_nN_by_nQ_A_alpha) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "responsive"))

# Define Implicit Function
ffi_linear_dplyrdo <- function(fl_A, fl_alpha, ar_nN_A, ar_nN_alpha){
  # ar_A_alpha[1] is A
  # ar_A_alpha[2] is alpha
  
  print(paste0('cur row, fl_A=', fl_A, ', fl_alpha=', fl_alpha))
  fl_out = sum(fl_A*ar_nN_A + 1/(fl_alpha + 1/ar_nN_alpha))

  return(fl_out)
}

# Evaluate function row by row of tibble
# fl_A, fl_alpha are from columns of tb_nN_by_nQ_A_alpha
tb_nN_by_nQ_A_alpha = tb_nN_by_nQ_A_alpha %>% rowwise() %>%
                    mutate(dplyr_eval = ffi_linear_dplyrdo(fl_A, fl_alpha, ar_nN_A, ar_nN_alpha))
# Show
kable(tb_nN_by_nQ_A_alpha) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "responsive"))

#' 
#' ## Compare Results
#' 
## ----linear_combine------------------------------------------------------
# Show overall Results
mt_results <- cbind(ar_func_apply, ar_func_sapply, 
                    tb_nN_by_nQ_A_alpha['dplyr_eval'], mt_nN_by_nQ_A_alpha)
colnames(mt_results) <- c('eval_lin_apply', 'eval_lin_sapply',
                          'eval_dplyr_mutate', 'A_child', 'alpha_child')
kable(mt_results) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "responsive"))
