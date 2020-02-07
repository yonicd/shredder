shinyServer(function(input, output, session) {
    
  shiny::observeEvent(c(input$params),{
    this <- fit()
    
    output$diagplot <- shiny::renderPlot({
      rhs <- list(rstan::stan_rhat(this(),pars=input$params),
           rstan::stan_mcse(this(),pars=input$params),
           rstan::stan_ess(this(),pars=input$params))%>%
        purrr::reduce(`/`)
      
      lhs <- rstan::traceplot(this(),pars=input$params)
      
      lhs | rhs
      
    })

  })
    
  shiny::observeEvent(c(input$par),{
    output$parplot <- shiny::renderPlot({
      this <- fit()
      rstan::stan_par(this(),par=input$par)
    })
  })
  
  fit <- shiny::eventReactive(input$path,{
    shiny::reactivePoll(
      1000, session,
      # This function returns the time that log_file was last modified
      checkFunc = function() {
        f <- list.files(file.path(input$path),full.names = TRUE)
        if (length(f)>0)
          max(sapply(f,function(x) file.info(x)[['mtime']]))
        else
          ""
      },
      # This function returns the content of log_file
      valueFunc = function() {
        fit <- rstan::read_stan_csv(list.files('../test',full.names = TRUE,pattern = 'csv$'))
        
        fit@sim$samples <- purrr::map(fit@sim$samples,function(x,y){
          names(x) <- y 
          x
        },y = fit@sim$fnames_oi)
        
        fit@stan_args <- purrr::map(fit@stan_args,function(x){
          x$method <- 'sampling'
          x
        })
        
        fit
        
      }
    )
  })
    
  observeEvent(input$path,{
    this <- fit()
    params <- shredder::stan_names(this(),expand = TRUE)  
    output$params <- renderUI({
      shiny::selectInput(
        inputId = 'params',
        label = 'Select Parameter',
        choices = params,
        selected = 'lp__',multiple = TRUE,selectize = TRUE
      )
    })
    
    output$par <-  renderUI({
      shiny::selectInput(
        inputId = 'par',
        label = 'Select Par Parameter',
        choices = params[-length(params)],
        selected = params[1],multiple = FALSE,selectize = TRUE
      )
    })
      
  })
  
    shiny::observeEvent(input$qt, {
      shiny::stopApp()
    })
    
})
  