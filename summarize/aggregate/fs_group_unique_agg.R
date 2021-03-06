#' ---
#' title: "R DPLYR Unique Groups and Count"
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
## ----GlobalOptions, echo = T, results = 'hide', message=F, warning=F----------
rm(list = ls(all.names = TRUE))
options(knitr.duplicate.label = 'allow')

#' 
## ----loadlib, echo = T, results = 'hide', message=F, warning=F----------------
library(tidyverse)
library(knitr)
library(kableExtra)
library(REconTools)
# file name
st_file_name = 'fs_group_unique_agg'
# Generate R File
purl(paste0(st_file_name, ".Rmd"), output=paste0(st_file_name, ".R"), documentation = 2)
# Generate PDF and HTML
# rmarkdown::render("C:/Users/fan/R4Econ/summarize/aggregate/fs_group_unique_agg.Rmd", "pdf_document")
# rmarkdown::render("C:/Users/fan/R4Econ/summarize/aggregate/fs_group_unique_agg.Rmd", "html_document")

#' 
#' # Aggregate Table with Groups
#' 
#' ## Aggrgate Groups only Unique Group and Count
#' 
#' There are two variables that are numeric, we want to find all the unique groups of these two variables in a dataset and count how many times each unique group occurs
#' 
#' - r unique occurrence of numeric groups
#' - How to add count of unique values by group to R data.frame
#' 
## -----------------------------------------------------------------------------
# Numeric value combinations unique Groups
vars.group <- c('hgt0', 'wgt0')

# dataset subsetting
df_use <- df_hgt_wgt %>% select(!!!syms(c(vars.group))) %>% 
            mutate(hgt0 = round(hgt0/5)*5, wgt0 = round(wgt0/2000)*2000) %>% 
            drop_na()

# Group, count and generate means for each numeric variables
# mutate_at(vars.group, funs(as.factor(.))) %>%
df.group.count <- df_use %>% group_by(!!!syms(vars.group)) %>%
                    arrange(!!!syms(vars.group)) %>%
                    summarise(n_obs_group=n())

# Show results Head 10
df.group.count %>%
  kable() %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

#' 
#' ## Aggrgate Groups only Unique Group Show up With Means
#' 
#' Several variables that are grouping identifiers. Several variables that are values which mean be unique for each group members. For example, a Panel of income for N households over T years with also household education information that is invariant over time. Want to generate a dataset where the unit of observation are households, rather than household years. Take average of all numeric variables that are household and year specific.
#' 
#' A complicating factor potentially is that the number of observations differ within group, for example, income might be observed for all years for some households but not for other households. 
#' 
#' - r dplyr aggregate group average
#' - Aggregating and analyzing data with dplyr
#' - column can't be modified because it is a grouping variable
#' - see also: [Aggregating and analyzing data with dplyr](https://datacarpentry.org/dc_zurich/R-ecology/04-dplyr.html)
#' 
## -----------------------------------------------------------------------------
# In the df_hgt_wgt from R4Econ, there is a country id, village id, 
# and individual id, and various other statistics
vars.group <- c('S.country', 'vil.id', 'indi.id')
vars.values <- c('hgt', 'momEdu')

# dataset subsetting
df_use <- df_hgt_wgt %>% select(!!!syms(c(vars.group, vars.values)))

# Group, count and generate means for each numeric variables
df.group <- df_use %>% group_by(!!!syms(vars.group)) %>%
            arrange(!!!syms(vars.group)) %>%
            summarise_if(is.numeric, 
                         funs(mean = mean(., na.rm = TRUE),
                              sd = sd(., na.rm = TRUE),
                              n = sum(is.na(.)==0)))

# Show results Head 10
df.group %>% head(10) %>%
  kable() %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
# Show results Head 10
df.group %>% tail(10) %>%
  kable() %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

#' 
