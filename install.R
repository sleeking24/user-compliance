
install.packages(c('civis',
                   'shiny'),
                 repos='https://cran.rstudio.com/')

library(civis)

query<-(sql("select primary_organization_name as Organization_Name, primary_organization_status as Status, org_type, sum(case when max = 3 then 1 else 0 end) as Report_Viewer_Count, sum(case when max =6 then 1 else 0 end) as Analyst_Count, max_report_users as Max_Report_Viewers, max_analyst_users as Max_Analysts
            from scratch.usercompliance
            group by 1,2,3,6,7
            order by 1"))
uc<-read_civis(query,database="redshift-general")

save(uc,"app/uc.Rdata")
