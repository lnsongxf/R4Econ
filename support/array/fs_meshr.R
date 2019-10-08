#' ---
#' title: "Meshgrid Arrays in R"
#' output:
#'   html_document: default
#'   word_document: default
#'   pdf_document: default
#'   html_notebook: default
#' urlcolor: blue
#' always_allow_html: yes
#' ---
#' 
#' Back to **[Fan](https://fanwangecon.github.io/)**'s R4Econ Homepage **[Table of Content](https://fanwangecon.github.io/R4Econ/)**
#' 
#' # Searched Terms
#' 
#' - r expand.grid meshed array to matrix
#' - r meshgrid
#' - r array to matrix
#' - r reshape array to matrix
#' 
#' ## Set-up
#' 
## ---- results = 'hide'---------------------------------------------------
library(knitr)
library(kableExtra)
getwd()
# file name
st_file_name = 'fs_meshr'
# Generate R File
purl(paste0(st_file_name, ".Rmd"), output=paste0(st_file_name, ".R"), documentation = 2)
# Generate PDF and HTML
# rmarkdown::render("C:/Users/fan/R4Econ/support/array/fs_meshr.Rmd", "pdf_document")
# rmarkdown::render("C:/Users/fan/R4Econ/support/array/fs_meshr.Rmd", "html_document")

#' 
#' ## Define Two Arrays and Mesh Them
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
#' ## Two Identical Arrays, Mesh to Generate Square
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

#' 