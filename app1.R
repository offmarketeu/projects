

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("EasyWord"),
   
   sidebarLayout(
     sidebarPanel(
        textInput("word","Input text here")
        ),
   
   fluidRow(
     h3("Sugestion"),
     column(1,
          uiOutput("wd1")
            ),
       column(2,offset = 1,
              uiOutput("wd2")
       ),
         column(3,
                uiOutput("wd3")
         )   
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
  #dir3<-"'~/TOKENS"
  #setwd(dir3)
  
  output$fileUploaded <- reactive({
    tkm<- read.csv("tokens2.csv")
    tkm_<- read.csv("tokens3.csv")
    return(0)
  })
  
 
  tkm<- read.csv("tokens2.csv")
  tkm_<- read.csv("tokens3.csv")
  
  
    
  sugest<- reactive({
      lit<- tolower(input$word)
      lit_str<- strsplit(lit," ")
      n_lit<- length(lit_str[[1]])
      if (n_lit==1) {
        # 2-g
        search<-tkm[grepl(paste("^",lit,sep=""), tkm$Content),]
        search<-search[order(-search$Frequency),]
        leader<- head(search,3)
        #des<- t(data.frame((strsplit(as.character(leader$Content)," "))))
        st1<-strsplit(as.character(leader$Content)," ")
        sugestion<- c(st1[[1]][2],st1[[2]][2],st1[[3]][2])
        
      } else {
        # find the lag
        liting <- as.character()
        for (j in max(1,n_lit-1):n_lit) {
          liting <- paste(liting, lit_str[[1]][j], sep=" ")
        }
        liting<- substring(liting,2)
        # 3-g
        search_<-tkm_[grepl(paste("^",liting,sep=""), tkm_$Content),]
        if (nrow(search_)>0) {
          search_<-search_[order(-search_$Frequency),]
          leader_<- head(search_,3)
          st1<-strsplit(as.character(leader_$Content)," ")
          sugestion<- c(st1[[1]][3],st1[[2]][3],st1[[3]][3])
        } else {
          sep<- strsplit(lit, " ")
          lit<-sep[[1]][3]
          search<-tkm[grepl(paste("^",lit,sep=""), tkm$Content),]
          search<-search[order(-search$Frequency),]
          leader<- head(search,3)
          st1<-strsplit(as.character(leader$Content)," ")
          sugestion<- c(st1[[1]][2],st1[[2]][2],st1[[3]][2])
        }
      }  
      sugestion<- t(as.data.frame(sugestion))
      #vector[1]            
      })
      output$wording <- renderTable({sugest()})
      output$wd1 <- renderUI({
        ss<- sugest()
        if (is.null(ss[1,1]) | ss[1,1]==0) {
          actionButton("wdd1", label = "No word")
        } else {
          actionButton("wdd1", label = ss[1,1])
        }
      })
      output$wd2 <- renderUI({
        ss<- sugest()
        actionButton("wdd2", label = ss[1,2])
      })
      output$wd3 <- renderUI({
        ss<- sugest()
        actionButton("wdd3", label = ss[1,3])
      })
      
      observeEvent(input$wdd1, {
        ss<- sugest()
        updateTextInput(session, "word", value = paste(input$word,ss[1,1]))
      })
      
      observeEvent(input$wdd2, {
        ss<- sugest()
        updateTextInput(session, "word", value = paste(input$word,ss[1,2]))
      })
      observeEvent(input$wdd3, {
        ss<- sugest()
        updateTextInput(session, "word", value = paste(input$word,ss[1,3]))
      })
}

# Run the application 
shinyApp(ui = ui, server = server)

