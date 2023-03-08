library(shiny)
library(maps)
library(mapproj) 

# Run source code for mapping and data
source("helpers.R")
counties <- readRDS("data/counties.rds")

# Define UI ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
    h3("Dat repository"),
    helpText("Create demographic maps with
           information from the 2010 US Census.",
           
           selectInput("var", h3("Choose a variable to display"),
                       choices = list("Percent White",
                                      "Percent Black",
                                      "Percent Hispanic",
                                      "Percent Asian")),
           
           sliderInput("range", "Range of interest",
                       min = 0, max = 100, value = c(0, 100)))
    ),
    mainPanel(
      plotOutput("map")
    )
    )
)
# Define server logic ----
server <- function(input, output){
  output$map <- renderPlot({
    args <- switch(input$var,
                   "Percent White" = list(counties$white, "darkgreen","% white"),
                   "Percent Black" = list(counties$black, "black","% black"),
                   "Percent Hispanic" = list(counties$hispanic, "darkorange","% hispanic"),
                   "Percent Asian" = list(counties$asian, "darkviolet","% asian"),
                   )
    
    args$min <- input$range[1]
    args$max <- input$range[2]
    
    do.call(percent_map,args)
  })
}


# Run the app ----
shinyApp(ui = ui, server = server)