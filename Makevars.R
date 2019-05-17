# rstan makevars 

dotR <- file.path(Sys.getenv("HOME"), ".R")

if (!file.exists(dotR)) dir.create(dotR)

M <- file.path(dotR, ifelse(.Platform$OS.type == "windows", "Makevars.win", "Makevars"))

if (!file.exists(M)) file.create(M)

mrg_rstan_settings <- c(
  'CXX14 = g++ -std=c++1y -fPIC', 
  'CXXFLAGS=-O3 -std=c++1y -mtune=native -march=native -Wno-unused-variable -Wno-unused-function', 
  'CXX14FLAGS=-O3 -std=c++1y -mtune=native -march=native -Wno-unused-variable -Wno-unused-function'
)

cat(mrg_rstan_settings,file = M, sep = "\n", append = TRUE)  
