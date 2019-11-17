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
    testthat::expect_warning(rats%>%stan_filter(`alpha[1]` < 6),regexp = 'no samples')
  })
  
  it('invalid pars',{
    testthat::expect_error(rats%>%stan_filter(bad < 6),regexp = 'Invalid parameter names')
  })
  
  it('invalid chain',{
    testthat::expect_error(rats%>%stan_filter(mu_beta < 6,chain=6),regexp = 'Invalid chain number')
  })
  
})
