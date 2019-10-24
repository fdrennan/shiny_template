## app.R ##
library(shinydashboard)
library(ggplot2)

ui <- dashboardPage(
  theme = "flatly",
  header = dashboardHeader(title = "Basic dashboard"),
  sidebar = dashboardSidebar(
    size = 'wide',
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets"),
    sliderInput("slider", "Number of observations:", 1, 100, 50)
  ),
  body = dashboardBody(
    ### changing theme
    # shinyDashboardThemes(
    #   theme = "blue_gradient"
    # ),
    # Boxes need to be put in a row (or column)
    fluidRow(
      column(
          width = 4, plotOutput("plot1", height = 250)
      ),
      column(
        width = 4, plotOutput("plot2", height = 250)
      ),
      column(
        width = 4, plotOutput("plot3", height = 250)
      ),
      column(
        width = 4, plotOutput("plot4", height = 250)
      )
    ),
    fluidRow(
      column(
        width = 8, plotOutput("plot5", height = 250)
      ),
      column(
        width = 8, plotOutput("plot6", height = 250)
    ),
      column(
        width = 16, plotOutput("plot7", height = 250)
      )
  ),
  title = "Dashboard example"
)
)
server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  output$plot1 <- renderPlot({
    x <- seq(0.01, .99, length.out = 100)
    df <- data.frame(
      x = rep(x, 2),
      y = c(qlogis(x), 2 * qlogis(x)),
      group = rep(c("a","b"),
                  each = 100)
    )
    p <- ggplot(df, aes(x=x, y=y, group=group))
    # These work
    p + geom_line(linetype = 2)
  })
  output$plot2 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$plot3 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$plot4 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$plot5 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$plot6 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$plot7 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)