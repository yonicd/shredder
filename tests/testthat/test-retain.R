testthat::context('retain')
rats <- readRDS('../files/rats.Rds')

testthat::describe('retain',{
  
  it('default',{
    x <- rats%>%stan_retain()
    testthat::expect_equal(chain_ids(x),1)
  })
  
  it('null',{
    x <- rats%>%stan_retain(chains = NULL)
    testthat::expect_equal(x,rats)
  })

  it('single',{
    x <- rats%>%stan_retain(chains = 3)
    testthat::expect_equal(sapply(x@stan_args, function(x) x$chain_id),3)
  })
  
  it('multiple',{
    x <- rats%>%stan_retain(chains = c(1,3))
    testthat::expect_equal(sapply(x@stan_args, function(x) x$chain_id),c(1,3))
  })
  
  it('all',{
    x <- rats%>%stan_retain(chains = c(2,1,3,4))
    testthat::expect_equal(sapply(x@stan_args, function(x) x$chain_id),c(1,2,3,4))
  })
  
  it('bad',{
    testthat::expect_error(rats%>%stan_retain(chains = c(5)),regexp = "Invalid chains")
  })

})
