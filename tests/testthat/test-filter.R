testthat::context('filter')

rats <- readRDS('../files/rats.Rds')

testthat::describe('filters',{

  it('default',{
    x <- rats%>%stan_filter(mu_beta < 6)
    testthat::expect_equal(length(x@sim$samples[[1]]$mu_beta),1032)
  })
    
  it('not permuted',{
    x <- rats%>%stan_filter(mu_beta < 6,permuted = FALSE)
    testthat::expect_equal(length(x@sim$samples[[1]]$mu_beta),1047)
  })
  
  it('not permuted',{
  testthat::expect_warning(rats%>%stan_filter(mu_beta < 5.85),regexp = 'no samples for chains: 1, 2')
  })

  it('indexed name',{
    x <- rats%>%stan_filter(`alpha[1]` < 240)
    testthat::expect_equal(length(x@sim$samples[[1]]$mu_beta),1492)
  })
  
  it('no samples',{
    testthat::expect_warning(rats%>%stan_filter(`alpha[1]` < 6),regexp = 'no samples')
  })
  
  it('invalid pars',{
    testthat::expect_error(rats%>%stan_filter(bad < 6),regexp = 'Invalid parameter names')
  })

  
})
