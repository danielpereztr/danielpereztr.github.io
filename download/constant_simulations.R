f <- id #estimation id number
iterations <- I #no. of iterations
resp <- as.numeric(N) #respondents per iteration
lev <- c(2,2,3) #attributes and levels
cod <- c("E","E","E") #effects coding
sets <- S #no. of choice sets
library(idefix) 
priors <- c(0, 0, 0, 0, 0) #first priors set to zero
dataset.f <- c() #creation of the final dataset 
i <- 0 #iterations counter
montecarlo <- 0 #Monte Carlo iterations counter
results <- c() #storage of coefficients
library(survival) #storage of coefficients
out.fin <- list() #storage of coefficients
x11.fin <- list() #storage of coefficients
x21.fin <- list() #storage of coefficients
x31.fin <- list() #storage of coefficients
x32.fin <- list() #storage of coefficients

while (montecarlo<100){ #Monte Carlo loop
  
  while (i<iterations) { #Bliemer and Rose loop
    I <- diag(length(priors))
    sim <- MASS::mvrnorm(n=100, mu=priors, Sigma=I)
    sim <- list(sim[,1:1], sim[, 2:(length(priors))])
    con <- c(0,0,1)
    d <- CEA(lvls=lev, coding=cod, n.alts=3, n.sets=sets, alt.cte=con, par.draws=sim,    
             no.choice=TRUE, best=TRUE)
    des <- d$design
    truePREF <- c(0, -2, -1, 1, 2)
    desm <- do.call(rbind, replicate(resp, des, simplify=FALSE))
    choice <- RespondMNL(par = truePREF, des=desm, n.alts=3)
    x <- nrow(desm)
    cs <- rep((i*240):(x/3), each= 3, length.out=240)
    dataset.t <- cbind(cs, desm, choice)
    dataset.t <- as.data.frame(dataset.t)
    dataset.f <- rbind(dataset.f,dataset.t)
    res <- clogit(choice ~ alt3.cte + Var11 + Var21 + Var31 + Var32 + strata(cs),   
                  data = dataset.f,  method="efron")
    truco <- (summary(res)$coefficients[,1])
    truco <- as.data.frame((cbind(truco, summary(res)$coefficients[,4])))
    truco <- cbind(truco,ifelse(abs(truco[,2]) >= 1.96,1,0))
    truco <- cbind(truco, truco[,1]*truco[,3])
    priors <- truco[,4]
    #fin
    i <- i+1
    results <- rbind(results, priors)
    n.it <- "iteration"
    print(paste(n.it, i))
  } #end of Bliemer and Rose loop
  
  i <- 0
  x11.fin <- as.data.frame(cbind(x11.fin, results[,2])) #storage of coefficients
  x21.fin <- as.data.frame (cbind(x21.fin, results[,3])) #storage of coefficients
  x31.fin <- as.data.frame(cbind(x31.fin, results[,4])) #storage of coefficients
  x32.fin <- as.data.frame(cbind(x32.fin, results[,5])) #storage of coefficients
  dataset.f <- c() #clear dataset
  results <- c() #clear results array
  monti <- "Iteration MONTECARLO" # Monte Carlo iteration counter
  print(paste(monti, montecarlo)) # Monte Carlo iteration counter
  montecarlo<-montecarlo+1 # Monte Carlo iteration counter
}

library(writexl) #print 4 excel files
write_xlsx(x11.fin, sprintf("sim%fx11.xlsx",f))
write_xlsx(x21.fin, sprintf("sim%fx21.xlsx",f))
write_xlsx(x31.fin, sprintf("sim%fx31.xlsx",f))
write_xlsx(x32.fin, sprintf("sim%fx32.xlsx",f))
