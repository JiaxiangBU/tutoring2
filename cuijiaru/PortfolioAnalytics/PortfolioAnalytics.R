install.packages("PortfolioAnalytics")
library(PortfolioAnalytics)
help(package='PortfolioAnalytics')
install.packages("DEoptim")
library(DEoptim)
library( PerformanceAnalytics )
install.packages("ROI")
library(ROI)
data(edhec)
head(edhec)
R <- edhec[, 1:4]
colnames(R) <- c("CA", "CTAG", "DS", "EM")
head(R, 5)
funds <- colnames(R)
funds
init.portf <- portfolio.spec(assets=funds)
init.portf <- add.constraint(portfolio=init.portf, type="full_investment")
init.portf <- add.constraint(portfolio=init.portf, type="long_only")
SD.portf <- add.objective(portfolio=init.portf, type="risk", name="StdDev")
# Portfolio with expected shortfall as an objective
ES.portf <- add.objective(portfolio=init.portf, type="risk", name="ES")
sd.moments <- set.portfolio.moments(R, SD.portf)
names(sd.moments)
es.moments <- set.portfolio.moments(R, ES.portf)
names(es.moments)
sigma.robust <- function(R){
  require(MASS)
  out <- list()
  set.seed(1234)
  out$sigma <- cov.rob(R, method="mcd")$cov
  return(out)
}
opt.sd <- optimize.portfolio(R, SD.portf, 
                             optimize_method="ROI", 
                             momentFUN="sigma.robust")
opt.sd
