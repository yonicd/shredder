testthat::context('slicing')

rats <- readRDS('../files/rats.Rds')

testthat::describe('slice',{
  
  it('default',{
    rstan::summary(rats)
    x <- rats%>%shredder::stan_slice(1:10)
    testthat::expect_equal(length(x@sim$samples[[1]][[1]]),1010)
  })
  
  it('no warmup',{
    x <- rats%>%shredder::stan_slice(1:10,inc_warmup = FALSE)
    testthat::expect_equal(length(x@sim$samples[[1]][[1]]),10)
  })
  
  
  it('bad indexs',{
    suppressWarnings(x <- rats%>%shredder::stan_slice(900:1200,inc_warmup = FALSE))
    testthat::expect_equal(length(x@sim$samples[[1]][[1]]),101)
    testthat::expect_warning(rats%>%shredder::stan_slice(900:1200),regexp = 'truncating the intersection')
  })

})


testthat::describe('sample',{
  
  it('sample_n',{
    x <- rats%>%shredder::stan_sample_n(size = 500)
    testthat::expect_equal(length(x@sim$samples[[1]][[1]]),1500)
  })
  
  it('sample_frac',{
    x <- rats%>%shredder::stan_sample_frac(size = 0.25)
    testthat::expect_equal(length(x@sim$samples[[1]][[1]]),1250)
  })
  
  it('no warmup',{
    x <- rats%>%shredder::stan_sample_n(size = 500,inc_warmup = FALSE)
    testthat::expect_equal(length(x@sim$samples[[1]][[1]]),500)
  })
  
})
