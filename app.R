install.packages(c('civis',
                   'shiny',
                    'DT'),
                 repos='https://cran.rstudio.com/')

library(civis)
library(shiny)
library(DT)


query<-(sql("select primary_organization_name as Organization_Name, primary_organization_status as Status, org_type, sum(case when max = 3 then 1 else 0 end) as Report_Viewer_Count, sum(case when max =6 then 1 else 0 end) as Analyst_Count, max_report_users as Max_Report_Viewers, max_analyst_users as Max_Analysts, sum(case when max = 3 and active_user =1 then 1 else 0 end) as Active_Report_Viewer_Count, sum(case when max =6 and active_user = 1 then 1 else 0 end) as Active_Analyst_Count
from scratch.usercompliance
group by 1,2,3,6,7
order by 1
"))
uc<-read_civis(query,database="redshift-general")

# uc
names<-uc[[1]]

ui<-fluidPage(
  tags$h1("User Compliance Report"),
  selectInput("grp","Choose a Org",choices=names),
  DT::dataTableOutput("data")
)


server<-function(input,output,session){
  output$data<-DT::renderDataTable(uc[uc$organization_name == input$grp, ])
  
 session$allowReconnect("force")}
shinyApp(ui=ui,server=server)


