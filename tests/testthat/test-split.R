testthat::context('split')
rats <- readRDS('../files/rats.Rds')
testthat::describe('names',{
  
  it('default',{
    x <- rats%>%stan_split()
    testthat::expect_equal(length(x),10)
  })
  
  it('specify cut',{
    x <- rats%>%stan_split(ncut=4)
    testthat::expect_equal(length(x),4)
  })
  
  it('no warmup',{
    x <- rats%>%stan_split(inc_warmup = FALSE)
    testthat::expect_equal(length(x),10)
    testthat::expect_equal(x[[1]]@sim$warmup,0)
  })
  
})
