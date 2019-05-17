testthat::context('names')

rats <- readRDS('../files/rats.Rds')

testthat::describe('names',{
  
  it('default',{
    x <- rats%>%stan_names()
    testthat::expect_equal(rats@sim$pars_oi,x)
  })
  
  it('expand',{
    x <- rats%>%stan_names(expand = TRUE)
    testthat::expect_equal(rats@sim$fnames_oi,x)
  })

})
