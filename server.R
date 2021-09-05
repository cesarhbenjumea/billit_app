library(shiny)
library(DT)

shinyServer(
  function(input, output) {
    
    
    #Create data table
    bill_data = data.frame(People=as.character(c("Person 1", "Person 2")),
               Appetizer=c(0, 0),
               Main=c(0, 0),
               Drinks=c(0, 0),
               Subtotal=c(0, 0),
               Taxes=c(0, 0),
               Tip=c(0, 0),
               Total=c(0, 0), stringsAsFactors=FALSE)

    globals <- reactiveValues(dat = bill_data)

    # Make the Table
    output$tbl = renderDT(
      globals$dat, options = list(lengthChange = FALSE, sDom  = '<"top">lrt<"bottom">ip', dom = 't'), escape=FALSE,
      editable = TRUE, class = 'cell-border stripe')
    
    # Add People Button
    observeEvent(input$addPeople, {
      
      if(nrow(globals$dat) < 8) {
        globals$dat <- rbind(globals$dat,c(paste("Person ", as.character(nrow(globals$dat) + 1)),
                                           0,0,0,0,0,0,0))
      } else output$omsg <- renderPrint({"This beta version only supports 8 people in the bill"})
      })
    

    # Remove People Button
    observeEvent(input$remPeople, {
      if(nrow(globals$dat) > 2) {
      globals$dat <- globals$dat[-nrow(globals$dat),]
      } else output$omsg <- renderPrint({"There must be at least 2 people in the bill"})
    })
    
    observeEvent(input[["tbl_cell_edit"]], {
      cell <- input[["tbl_cell_edit"]]
      if(cell$col == 1) { globals$dat[cell$row, cell$col] <- cell$value
      } else {
      globals$dat[cell$row, cell$col] <- round(as.numeric(cell$value), digits = 1)
      
      for(i in 1:nrow(globals$dat)) {
        # Calculate Subtotal
        globals$dat[i,5] <- round(as.numeric(globals$dat[i,2]) + as.numeric(globals$dat[i,3]) + 
          as.numeric(globals$dat[i,4]), digits = 1)
        # Calculate Tax
        globals$dat[i,6] <- round(as.numeric(globals$dat[i,5])*input$tax/100, digits = 1)
        
        # Calculate Tip
        globals$dat[i,7] <- round(as.numeric(globals$dat[i,5])*input$tip/100, digits = 1)
        
        # Calculate Row Totals
        globals$dat[i,8] <- round (as.numeric(globals$dat[i,5]) + as.numeric(globals$dat[i,6]) +
          as.numeric(globals$dat[i,7]), digits = 1)
      }
      
      subt<-reactiveVal(0)
      taxt<-reactiveVal(0)
      tipt<-reactiveVal(0)
      tott<-reactiveVal(0)
      for(i in 1:nrow(globals$dat)) {
      subt2 <- subt() + as.numeric(globals$dat[i,5])
      taxt2 <- taxt() + as.numeric(globals$dat[i,6])
      tipt2 <- tipt() + as.numeric(globals$dat[i,7])
      tott2 <- tott() + as.numeric(globals$dat[i,8])
      subt(subt2)
      taxt(taxt2)
      tipt(tipt2)
      tott(tott2)
      }
      output$osummary <- renderPrint({paste("Subtotal: ",subt2,
                                            " ",
                                            "Tax: ", taxt2,
                                            " ",
                                            "Tip: ", tipt2,
                                            " ",
                                            "Total: ", tott2)})
      
      }
   
    
    })
  })   
