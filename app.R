library(shiny)
library(civis)

load("app/uc.Rdata")
# uc
names<-uc[[1]]

ui<-fluidPage(
  tags$h1("User Compliance Report"),
  selectInput("grp","Choose a Org",choices=names),
  DT::dataTableOutput("data")
)


server<-function(input,output){
  output$data<-DT::renderDataTable(uc[uc$organization_name == input$grp, ])
  
}
shinyApp(ui=ui,server=server)


