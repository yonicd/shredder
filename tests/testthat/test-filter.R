testthat::context('filter')

rats <- readRDS('../files/rats.Rds')

testthat::describe('filters',{
  
  it('default',{
    x <- rats%>%stan_filter(mu_beta < 6)
    testthat::expect_equal(length(x@sim$samples[[1]]$mu_beta),1047)
  })
  
  it('different chain',{
    x <- rats%>%stan_filter(mu_beta < 6,chain=2)
    testthat::expect_equal(length(x@sim$samples[[1]]$mu_beta),1032)
  })

  it('indexed name',{
    x <- rats%>%stan_filter(`alpha[1]` < 240)
    testthat::expect_equal(length(x@sim$samples[[1]]$mu_beta),1502)
  })
  
  it('no samples',{
    testthat::expect_message(rats%>%stan_filter(`alpha[1]` < 6),regexp = 'no samples')
  })
  
  it('no pars',{
    testthat::expect_message(rats%>%stan_filter(bad < 6),regexp = 'no pars')
  })
  
})