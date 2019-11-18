testthat::context('keep')
rats <- readRDS('../files/rats.Rds')

testthat::describe('keep',{
  
  it('default',{
    x <- rats%>%stan_keep()
    testthat::expect_equal(chain_ids(x),1)
  })
  
  it('null',{
    x <- rats%>%stan_keep(chains = NULL)
    testthat::expect_equal(x,rats)
  })

  it('single',{
    x <- rats%>%stan_keep(chains = 3)
    testthat::expect_equal(sapply(x@stan_args, function(x) x$chain_id),3)
  })
  
  it('multiple',{
    x <- rats%>%stan_keep(chains = c(1,3))
    testthat::expect_equal(sapply(x@stan_args, function(x) x$chain_id),c(1,3))
  })
  
  it('all',{
    x <- rats%>%stan_keep(chains = c(2,1,3,4))
    testthat::expect_equal(sapply(x@stan_args, function(x) x$chain_id),c(1,2,3,4))
  })
  
  it('bad',{
    testthat::expect_error(rats%>%stan_keep(chains = c(5)),regexp = "Invalid chains")
  })

})
