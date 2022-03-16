# /usr/bin/env Rscript
# To run it
###Rscript --vanilla z_estimates.R $gwas_summary

# test if there is at least one argument: if not, return an error
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("Please check your input file", call.=FALSE)
}

##### https://huwenboshi.github.io/data%20management/2017/11/23/tips-for-formatting-gwas-summary-stats.html
#Two ways to calculate z Score
## Case 1: If effect size (beta) and standard error (se) are included
#### Z = (beta)/se
#
#
## Case 2: If p-value and effect size (beta) are available:
#### Z= sign(Effect Size) * abs(qnorm(p-value/2))
### qnorm is the inverse cumulative distribution function of the normal distribution.


df = read.table(args[1], header=TRUE,sep="")
outputdir=args[2]
gwas_basename=args[3]
output=paste0(outputdir,'/',gwas_basename)
head(df)
header=colnames(df)

pvalue="^p$|^P-value$|^P.value$|^PVALUE$|^normal.score.p$|^pvalue$"
pvalue_index <- grep(pvalue, header,ignore.case = TRUE)
se="^se$|^normal.score.se$"
se_index <- grep(se, header,ignore.case = TRUE)
beta <- "^b$|^beta$|^ALT_EFFSIZE$|^normal.score.beta$"
beta_index <- grep(beta, header,ignore.case = TRUE)

# if( "beta" %in% colnames(df)  &  "se" %in% colnames(df)){
#   z= df$beta/df$se
# } else if( "beta" %in% colnames(df)  &  "pvalue" %in% colnames(df)){
#   z= sign(df$beta)*abs(df$pvalue/2)
# } else{
#   stop("Can't estimate  zscore", call.=FALSE)
# }

if( length(beta_index)>0  &  length(se_index)>0){
  z= df[,beta_index[1]]/ df[,se_index[1]]
} else if( length(beta_index)>0  &  length(pvalue_index)>0){
  z= sign(df[,beta_index[1]])*abs(df[,pvalue_index[1]]/2)
} else{
  stop("Can't estimate  zscore", call.=FALSE)
}

## Test length the vector z is equal to df
if(length(z) == dim(df)[1]){
  df= cbind(df,z)
  write.table(df,file=output,row.names=FALSE,col.names=TRUE, quote = FALSE,sep="\t")
}else{ sytem("touch output")}
