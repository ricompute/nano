library(readr)
library(stringr)
library(dplyr)


ui <- fluidPage(
    titlePanel("NanoDrop to CSV Converter", "ndj2csv"),
    "This app lets you upload a .ndj file, view the data, and download the data in CSV format.",
    tags$br(),
    tags$br(),
    sidebarLayout(
        sidebarPanel(
            tags$h2("Upload File"),
            fileInput("file1", "Choose .ndj File",
                      accept = ".ndj"
            ),
            # tags$hr(),
            # tags$h2("Options"),
            # radioButtons("options", "Choose what to display and download:",
            #              choices = c("Full file (everything)" = "everything",
            #                          "Bare minimum (ID, ng/\u03bcg, 260/280, 260/230)" = "min",
            #                          "More options" = "more")),
            # uiOutput("more_options"),
            tags$hr(),
            tags$h2("Download CSV"),
            tags$br(),
            downloadButton("download_csv", "Download CSV")
        ),
        mainPanel(
            tableOutput("contents")
        )
    )
)

server <- function(input, output) {
    output$contents <- renderTable({
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, it will be a data frame with 'name',
        # 'size', 'type', and 'datapath' columns. The 'datapath'
        # column will contain the local filenames where the data can
        # be found.
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        options(readr.num_columns = 0)
        ndj <<- read_tsv(inFile$datapath, skip = 4)
        
        # if (input$options == "min") {
        #     ndj <- ndj %>% select(`Sample ID`, `ng/ul`, `260/280`, `260/230`)
        # }
        # ndj
    })
    
    # observeEvent(input$file1, {
    #     output$download_csv <- downloadHandler(
    #         filename = function () {
    #             inFile <- input$file1
    #             str_replace(inFile$name, "ndj$", "csv")
    #         },
    #         
    #         content = function(file) {
    #             write_csv(ndj, file) 
    #         }
    #     )
    # })
    output$download_csv <- downloadHandler(
        filename = function () {
            inFile <- input$file1
            str_replace(inFile$name, "ndj$", "csv")
        },
        
        content = function(file) {
            write_csv(ndj, file) 
        }
    )
}

shinyApp(ui, server)
