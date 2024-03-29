library(shiny)
library(shinydashboard)

##########
#
# useful functions
#
##########
validateColor <- function(color) {
    if (color %in% validColors) {
        return(TRUE)
    }
    
    stop("Invalid color: ", color, ". Valid colors are: ",
         paste(validColors, collapse = ", "), ".")
}

validStatuses <- c("primary", "success", "info", "warning", "danger")

validateStatus <- function(status) {
    
    if (status %in% validStatuses) {
        return(TRUE)
    }
    
    stop("Invalid status: ", status, ". Valid statuses are: ",
         paste(validStatuses, collapse = ", "), ".")
}

"%OR%" <- function(a, b) if (!is.null(a)) a else b


# we first quickly create the label function
dashboardLabel <- function(..., status = "primary") {
    stopifnot(!is.null(status))
    validateStatus(status)
    tags$span(
        class = paste0("label", " label-", status),
        ...
    )
}


##########
#
# box code
#
##########
box <- function (..., title = NULL, footer = NULL, status = NULL, solidHeader = FALSE, 
                 background = NULL, width = 6, height = NULL, collapsible = FALSE, 
                 collapsed = FALSE, closable = TRUE, label_status = "primary") 
{
    boxClass <- "box"
    if (solidHeader || !is.null(background)) {
        boxClass <- paste(boxClass, "box-solid")
    }
    if (!is.null(status)) {
        validateStatus(status)
        boxClass <- paste0(boxClass, " box-", status)
    }
    if (collapsible && collapsed) {
        boxClass <- paste(boxClass, "collapsed-box")
    }
    if (!is.null(background)) {
        validateColor(background)
        boxClass <- paste0(boxClass, " bg-", background)
    }
    style <- NULL
    if (!is.null(height)) {
        style <- paste0("height: ", validateCssUnit(height))
    }
    titleTag <- NULL
    if (!is.null(title)) {
        titleTag <- h3(class = "box-title", title)
    }
    
    # the new boxtool section
    boxToolTag <- NULL
    if (collapsible || closable) {
        boxToolTag <- div(class = "box-tools pull-right")
    }
    
    collapseTag <- NULL
    if (collapsible) {
        buttonStatus <- status %OR% "default"
        collapseIcon <- if (collapsed) 
            "plus"
        else "minus"
        collapseTag <- tags$button(
            class = paste0("btn btn-box-tool"), 
            `data-widget` = "collapse", shiny::icon(collapseIcon)
        )
    }
    
    closableTag <- NULL
    if (closable) {
        closableTag <- tags$button(
            class = "btn btn-box-tool", 
            `data-widget` = "remove", 
            type = "button",
            tags$i(shiny::icon("times"))
        )
    } 
    
    labelTag <- dashboardLabel("My Label", status = label_status)
    
    # update boxToolTag
    boxToolTag <- tagAppendChildren(boxToolTag, labelTag, collapseTag, closableTag)
    
    headerTag <- NULL
    if (!is.null(titleTag) || !is.null(collapseTag)) {
        # replace by boxToolTag
        headerTag <- div(class = "box-header", titleTag, boxToolTag)
    }
    div(class = if (!is.null(width)) 
        paste0("col-sm-", width), div(class = boxClass, style = if (!is.null(style)) 
            style, headerTag, div(class = "box-body", ...), if (!is.null(footer)) 
                div(class = "box-footer", footer)))
}


##########
#
# test our box
#
##########
shinyApp(
    ui = dashboardPage(
        dashboardHeader(),
        dashboardSidebar(),
        dashboardBody(
            fluidRow(
                box(title = "Histogram box title", closable = TRUE, label_status = "danger",
                    status = "warning", solidHeader = FALSE, collapsible = TRUE,
                    p("Box Content")
                )
            )
        )
    ),
    server = function(input, output) {}
)