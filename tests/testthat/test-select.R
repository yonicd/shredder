testthat::context('select')
rats <- readRDS('../files/rats.Rds')
testthat::describe('names',{
  
  it('single name',{
    x <- rats%>%stan_select(mu_alpha)
    testthat::expect_equal(x@model_pars,'mu_alpha')
  })
  
  it('multiple names',{
    x <- rats%>%stan_select(mu_alpha,mu_beta)
    testthat::expect_equal(x@model_pars,c('mu_alpha','mu_beta'))
  })
  
  it('character names',{
    x <- rats%>%stan_select(!!! rlang::syms(c('mu_alpha','mu_beta')))
    testthat::expect_equal(x@model_pars,c('mu_alpha','mu_beta'))
  })

  it('remove summary',{
    rstan::summary(rats)
    x <- rats%>%stan_select(mu_alpha)
    testthat::expect_equal(x@model_pars,'mu_alpha')
  })
  
})

testthat::describe('partials',{
  
  it('no pars',{
    testthat::expect_message(rats%>%stan_select(stan_starts_with('mum')),regexp = 'no pars selected')
  })
  
  it('starts_with',{
    x <- rats%>%stan_select(stan_starts_with('mu'))
    testthat::expect_equal(x@model_pars,c('mu_alpha','mu_beta'))
  })

  it('ends_with',{
    x <- rats%>%stan_select(stan_ends_with('0'))
    testthat::expect_equal(x@model_pars,c('alpha0'))
  })
  
  it('starts_contains',{
    x <- rats%>%stan_select(stan_contains('alpha'))
    testthat::expect_equal(x@model_pars,c('alpha','mu_alpha','sigmasq_alpha','sigma_alpha','alpha0'))
  })
  
  it('mixed',{
    x <- rats%>%stan_select(alpha,stan_starts_with('mu'))
    testthat::expect_equal(x@model_pars,c('alpha','mu_alpha','mu_beta'))
  })
  
})