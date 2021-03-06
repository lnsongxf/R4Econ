# Generate logs of all variables satisfing some condition, new log variables end with _log suffix
df <- df %>% mutate_at(vars(matches('prot|cal'), -contains('p.A.')), funs(log = log(.)))

# NA if zero, so that log can proceed
mutate(!!(var.input) := na_if(!!sym(var.input), 0))

# Subtract from all variables some value, add suffix to name, then rename
mutate_at(vars(starts_with('hgtp.')), funs(hgtdiff = . - !!sym(var.hgt))) %>%
  rename_at(vars(ends_with("hgtdiff")), funs(gsub("hgtp.", "hgtpd.", gsub("_hgtdiff", "", .))))

# Cumulative Sum Replacing Zeros
options(warn=0)
var.id <- 'ID'
var.mth <- 'svymthRound'
var.input <- 'cal.imputed'
var.input.cumu <- 'cal.imputed.cumu'
df.reg <- df.reg %>%
        arrange(!!sym(var.id), !!sym(var.mth)) %>%
        group_by(!!sym(var.id)) %>%
        mutate(!!var.input.cumu := cumsum(replace_na(!!sym(var.input), 0)))
