library(shiny)
library(DT)
library(data.table)

shinyUI(
  fluidPage(headerPanel("BILLIT"),
            h3("This new app will allow you to enter the individual expenses 
               of a restaurant bill and make splitting easier."),
            h3("Just type the expenses directly into the table and see how 
               the Subtotal, tip, taxes and total are automatically calculated."),
            h4(""),
            h4("You can also edit the tax and tip percentage in the boxes below"),
            numericInput("tax", "Tax Percentage", 8.875, min = 0, max = 10),
            verbatimTextOutput("tax"),
            numericInput("tip", "Tip Percentage:", 20, min = 0, max = 40),
            verbatimTextOutput("tip"),
            actionButton("addPeople", "Add People"),
            actionButton("remPeople", "Remove People"),
            h4("Expenses Table"),
            DTOutput("tbl"),
            h4("Bill Summary"),
            verbatimTextOutput("osummary"),
            h4("App Messages"),
            verbatimTextOutput("omsg")
    )
)