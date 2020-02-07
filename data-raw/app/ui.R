miniUI::miniPage(
  miniUI::gadgetTitleBar(
    title = 'Stan Tracker',
    left = miniUI::miniTitleBarButton("qt", "Quit")
  ),
  miniUI::miniContentPanel(
    shiny::sidebarLayout(
      sidebarPanel = shiny::sidebarPanel(
        shiny::textInput('path','Project Path',value = '../test',placeholder = 'Enter Path'),
        shiny::textInput('root','CSV root','samp',placeholder = 'Enter csv root'),
        shiny::checkboxInput('diag_check','Show Diagnostics',value = TRUE),
        shiny::uiOutput('params'),
        shiny::checkboxInput('par_check','Show Par Plot',value = FALSE),
        shiny::conditionalPanel('input.par_check',{
          shiny::uiOutput('par')
        }),
        width = 3
      ),
      mainPanel = shiny::mainPanel(
        shiny::conditionalPanel('input.diag_check',{
          shiny::plotOutput('diagplot',height = 400)
        }),
        shiny::conditionalPanel('input.par_check',{
          shiny::plotOutput('parplot',height = 400)
        }),
        width = 9
      )
    )
  )
)