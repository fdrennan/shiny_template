library(shiny)
library(shiny.semantic)
library(semantic.dashboard)
library(plotly)
library(DT)

ui <- dashboardPage(
    dashboardHeader(dropdownMenuOutput("dropdown"),
                    dropdownMenu(type = "notifications",
                                 taskItem("Project progress...", 50.777, color = "red")),
                    dropdownMenu(icon = uiicon("red warning sign"),
                                 notificationItem("This is an important notification!", color = "red"))),
    dashboardSidebar(side = "left",
                     sidebarMenu(
                         menuItem(tabName = "plot_tab", text = "My plot", icon = icon("home")),
                         menuItem(tabName = "table_tab", text = "My table", icon = icon("smile")))),
    dashboardBody(
        tabItems(
            tabItem(tabName = "plot_tab",
                    fluidRow(
                        box(title = "Sample box", color = "blue", width = 11,
                            selectInput(inputId =  "variable1", choices = names(mtcars),
                                        label = "Select first variable", selected = "mpg"),
                            selectInput(inputId =  "variable2", choices = names(mtcars),
                                        label = "Select second variable", selected = "cyl"),
                            plotlyOutput("mtcars_plot")),
                        tabBox(title = "Sample box", color = "blue", width = 5,
                               collapsible = FALSE,
                               tabs = list(
                                   list(menu = "First Tab", content = "Some text..."),
                                   list(menu = "Second Tab", content = plotlyOutput("mtcars_plot2"))
                               )))),
            tabItem(tabName = "table_tab",
                    fluidRow(
                        box(title = "Classic box", color = "blue", ribbon = FALSE,
                            title_side = "top left", width = 14,
                            tags$div(
                                dataTableOutput("mtcars_table")
                                , style = paste0("color:", semantic_palette[["blue"]], ";"))
                        ))))
    ), theme = "slate"
)

server <- function(input, output) {
    
    output$mtcars_plot <- renderPlotly(plot_ly(mtcars, x = ~ mtcars[ , input$variable1],
                                               y = ~ mtcars[ , input$variable2],
                                               type = "scatter", mode = "markers")
    )
    output$mtcars_plot2 <- renderPlotly(plot_ly(mtcars, x = ~ mtcars[ , input$variable1],
                                                y = ~ mtcars[ , input$variable2],
                                                type = "scatter", mode = "markers"))
    
    output$mtcars_table <- renderDataTable(mtcars, options = list(dom = 't'))
    
    output$dropdown <- renderDropdownMenu({
        dropdownMenu(messageItem("User", "Test message", color = "teal", style = "min-width: 200px"),
                     messageItem("Users", "Test message", color = "teal", icon = "users"),
                     messageItem("See this", "Another test", icon = "warning", color = "red"))
    })
}

shinyApp(ui, server)