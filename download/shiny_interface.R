if (!require('shiny')) install.packages('shiny'); library('shiny')
if (!require('shinydashboard')) install.packages('shinydashboard'); library('shinydashboard')

# Interface
ui <- dashboardPage(
  dashboardHeader(title = "App"),
  dashboardSidebar(
    sidebarMenu(id = "menu",
                menuItem("Tab 1", tabName = "tab1"),
                menuItem("Tab 2", tabName = "tab2"),  
                menuItem("Tab 3", tabName = "tab3")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1",
              sidebarLayout(
                sidebarPanel(
                ),
                mainPanel(
                )
              )
      ),
      tabItem(tabName = "tab2",
              sidebarLayout(
                sidebarPanel(
                ),
                mainPanel(
                )
              )
      ),
      tabItem(tabName = "tab3",
              sidebarLayout(
                sidebarPanel(
                ),
                mainPanel(
                )
              ))
    )
  )
)

server <- function(input, output, session) {
  # Server logic
}

shinyApp(ui, server)
