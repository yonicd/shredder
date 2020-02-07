testthat::context("axe")

test_path <- '../files/rats.Rds'

rats_test <- readRDS(test_path)

testthat::describe("axe elements", {
  
  it('no fit_instance',{
    axe_fit_instance <- rats_test%>%stan_axe('fit_instance')
    testthat::expect_length(ls(envir = axe_fit_instance@.MISC),0L)  
  })
  
  it('no stanmodel',{
    axe_stanmodel <- rats_test%>%stan_axe('stanmodel')
    testthat::expect_false('stanmodel'%in%names(attributes(axe_stanmodel)))
  })
  
})
