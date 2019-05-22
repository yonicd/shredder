testthat::context('slice')
rats <- readRDS('../files/rats.Rds')
testthat::describe('slice',{
  
  it('empty',{
    x <- rats%>%stan_slice()
    testthat::expect_equal(x,rats)
  })
  
  it('single',{
    x <- rats%>%stan_slice(1)
    testthat::expect_equal(x@sim$n_save,rep(1001,4))
  })
  
  it('single no warmup',{
    x <- rats%>%stan_slice(1,inc_warmup = FALSE)
    testthat::expect_equal(x@sim$n_save,rep(1,4))
  })
  
  it('vector',{
    x <- rats%>%stan_slice(1:10)
    testthat::expect_equal(x@sim$n_save,rep(1010,4))
  })
  
  it('reset permut',{
    x <- rats%>%stan_slice(1:10)
    testthat::expect_equal(sapply(x@sim$permutation,length),rep(10,4))
  })
  
})
