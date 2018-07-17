## cat("\014") # clean console
install.packages("gtools")
library(gtools)

cat("\014") # clean console
#***---***---***---***
#*** TOP 20    SP -***
#***---***---***---***
top20_sp <- read.csv(file='top20_sp.csv',sep=',',header=T)
matrixNames <-names (top20_sp)
attach(top20_sp)

data_top20_sp = matrix(, ncol(top20_sp), ncol(top20_sp))
colnames(data_top20_sp) <- matrixNames
rownames(data_top20_sp) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_top20_sp[indexPrim,indexComp]<-0
    }else{
      data_top20_sp[indexPrim,indexComp]<-wilcox.test(top20_sp[,indexPrim], top20_sp[,indexComp], data = top20_sp, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_top20_sp
stars.pval(data_top20_sp)

#***---***---***---***
#*** OVER 1000 SP -***
#***---***---***---***
over1000_sp <- read.csv(file='over1000_sp.csv',sep=',',header=T)
matrixNames <-names (over1000_sp)

data_over1000_sp = matrix(, ncol(over1000_sp), ncol(over1000_sp))
colnames(data_over1000_sp) <- matrixNames
rownames(data_over1000_sp) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_over1000_sp[indexPrim,indexComp]<-0
    }else{
      data_over1000_sp[indexPrim,indexComp]<-wilcox.test(over1000_sp[,indexPrim], over1000_sp[,indexComp], data = over1000_sp, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_over1000_sp
stars.pval(data_over1000_sp)

#***---***---***---***
#*** OVER 92 SP ---***
#***---***---***---***
over92_sp <- read.csv(file='over92_sp.csv',sep=',',header=T)
matrixNames <-names (over92_sp)

data_over92_sp = matrix(, ncol(over92_sp), ncol(over92_sp))
colnames(data_over92_sp) <- matrixNames
rownames(data_over92_sp) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_over92_sp[indexPrim,indexComp]<-0
    }else{
      data_over92_sp[indexPrim,indexComp]<-wilcox.test(over92_sp[,indexPrim], over92_sp[,indexComp], data = over92_sp, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_over92_sp
stars.pval(data_over92_sp)

cat("\014") # clean console
#***---***---***---***
#*** TOP 20    TC -***
#***---***---***---***
top20_tc <- read.csv(file='top20_tc.csv',sep=',',header=T)
matrixNames <-names (top20_tc)

data_top20_tc = matrix(, ncol(top20_tc), ncol(top20_tc))
colnames(data_top20_tc) <- matrixNames
rownames(data_top20_tc) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_top20_tc[indexPrim,indexComp]<-0
    }else{
      data_top20_tc[indexPrim,indexComp]<-wilcox.test(top20_tc[,indexPrim], top20_tc[,indexComp], data = top20_tc, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_top20_tc
stars.pval(data_top20_tc)

#***---***---***---***
#*** OVER 1000 TC -***
#***---***---***---***
over1000_tc <- read.csv(file='over1000_tc.csv',sep=',',header=T)
matrixNames <-names (over1000_tc)

data_over1000_tc = matrix(, ncol(over1000_tc), ncol(over1000_tc))
colnames(data_over1000_tc) <- matrixNames
rownames(data_over1000_tc) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_over1000_tc[indexPrim,indexComp]<-0
    }else{
      data_over1000_tc[indexPrim,indexComp]<-wilcox.test(over1000_tc[,indexPrim], over1000_tc[,indexComp], data = over1000_tc, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_over1000_tc
stars.pval(data_over1000_tc)

#***---***---***---***
#*** OVER 92 TC ---***
#***---***---***---***
over92_tc <- read.csv(file='over92_tc.csv',sep=',',header=T)
matrixNames <-names (over92_tc)

data_over92_tc = matrix(, ncol(over92_tc), ncol(over92_tc))
colnames(data_over92_tc) <- matrixNames
rownames(data_over92_tc) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_over92_tc[indexPrim,indexComp]<-0
    }else{
      data_over92_tc[indexPrim,indexComp]<-wilcox.test(over92_tc[,indexPrim], over92_tc[,indexComp], data = over92_tc, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_over92_tc
stars.pval(data_over92_tc)

cat("\014") # clean console
#***---***---***---***
#*** TOP 20    COL -***
#***---***---***---***
top20_col <- read.csv(file='top20_col.csv',sep=',',header=T)
matrixNames <-names (top20_col)

data_top20_col = matrix(, ncol(top20_col), ncol(top20_col))
colnames(data_top20_col) <- matrixNames
rownames(data_top20_col) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_top20_col[indexPrim,indexComp]<-0
    }else{
      data_top20_col[indexPrim,indexComp]<-wilcox.test(top20_col[,indexPrim], top20_col[,indexComp], data = top20_col, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_top20_col
stars.pval(data_top20_col)

#***---***---***---***
#*** OVER 1000 COL -***
#***---***---***---***
over1000_col <- read.csv(file='over1000_col.csv',sep=',',header=T)
matrixNames <-names (over1000_col)

data_over1000_col = matrix(, ncol(over1000_col), ncol(over1000_col))
colnames(data_over1000_col) <- matrixNames
rownames(data_over1000_col) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_over1000_col[indexPrim,indexComp]<-0
    }else{
      data_over1000_col[indexPrim,indexComp]<-wilcox.test(over1000_col[,indexPrim], over1000_col[,indexComp], data = over1000_col, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_over1000_col
stars.pval(data_over1000_col)

#***---***---***---***
#*** OVER 92 COL ---***
#***---***---***---***
over92_col <- read.csv(file='over92_col.csv',sep=',',header=T)
matrixNames <-names (over92_col)

data_over92_col = matrix(, ncol(over92_col), ncol(over92_col))
colnames(data_over92_col) <- matrixNames
rownames(data_over92_col) <- matrixNames

for (methodPrimary in matrixNames){
  indexPrim=match(methodPrimary,matrixNames)
  for (methodCompare in matrixNames){
    indexComp=match(methodCompare,matrixNames)
    if(methodPrimary==methodCompare){
      data_over92_col[indexPrim,indexComp]<-0
    }else{
      data_over92_col[indexPrim,indexComp]<-wilcox.test(over92_col[,indexPrim], over92_col[,indexComp], data = over92_col, mu=0, alt="two.sided",paired=TRUE, exact = FALSE, correct=FALSE)$p.value
    }
  }
}
data_over92_col
stars.pval(data_over92_col)