reactiveTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    verbatimTextOutput(ns("code")),
    plotOutput(ns("plot"))
  )
}

#' @import ggplot2
reactiveTabServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    rr_env <- environment()

    pengiun_data <- reactive(palmerpenguins::penguins)

    plot_code <- reactive({
      ggplot2::ggplot(pengiun_data()) +
        ggplot2::aes(x = flipper_length_mm, y = body_mass_g, color = species) +
        ggplot2::geom_point(size = 3, alpha = 0.8) +
        ggplot2::geom_smooth(method = "lm", se = FALSE) +
        ggplot2::labs(
          title = "Flipper Length vs Body Mass of Palmer Penguins",
          subtitle = "Colored by Species",
          x = "Flipper Length (mm)",
          y = "Body Mass (g)",
          color = "Penguin Species"
        ) +
        ggplot2::theme_minimal(base_size = 14) +
        ggplot2::theme(
          plot.title = element_text(face = "bold", hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5),
          legend.position = "top"
        )
    })

    output$code <- renderText({
      # browser()
      repro(plot_code)
    })

    output$plot <- renderPlot(plot_code())
  })
}
