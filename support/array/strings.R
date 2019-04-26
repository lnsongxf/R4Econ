# check if variable is in dataframe
if ("d" %in% colnames(dat)){}

# if string value is contained in variable
("bridex.B" %in% (df.reg.out.all$vars_var.y))

# Add Leading zero for integer values to allow for sorting when
# integers are combined into strings
mutate(it_z_n = sprintf("%02d", it_z_n),
       it_a_n = sprintf("%04d", it_a_n))

# String replacement
gsub(x = paste0(unique(df.slds.stats.perc$it.inner.counter), ':',
                unique(df.slds.stats.perc$z_n_a_n), collapse = ';'),
     pattern = "\n",
     replacement = "")
gsub(x = var,  pattern = "\n", replacement = "")