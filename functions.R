#' Selectize input with placeholder
#' 
#' Helper function that generates selectize input with placeholder text
#' 
#' @param inputId character string
#' @param label character string
#' @param choices list, values to select from
#' @param ... arguments passed to `selectizeInput()`
#' @param options list of options; the placeholder option will be overwritten by `placeholder_text`
#' @param placeholder_text character string
#' 
#' @return shiny tag
selectize_with_placeholder <- function(inputId, label, choices = NULL, ..., options = list(),
                                       placeholder_text = "no choices available"){
  checkmate::assert_string(
    x = inputId, 
    min.chars = 1
  )
  checkmate::assert(
    checkmate::check_string(label),
    checkmate::check_null(label)
  )
  checkmate::assert_list(options)
  checkmate::assert_string(
    x = placeholder_text,
    min.chars = 1
  )
  
  options[["placeholder"]] <- placeholder_text
  
  shiny::selectizeInput(
    inputId = inputId,
    label = label,
    choices = choices,
    options = options,
    ...
  )
}

#' Generate plot
#' 
#' Produces a simple scatter plot
#' 
#' @param df data.frame, input data
#' @param x_var character string, x variable
#' @param y_var character string, y variable
#' @param color_var character string, color variable
#' @param title character string, plot title
#' 
#' @return ggplot object
generate_plot <- function(df, x_var, y_var, color_var, title = "Dummy plot"){
  checkmate::assert_data_frame(df)
  checkmate::assert_string(x_var)
  checkmate::assert_string(y_var)
  checkmate::assert_string(color_var)
  checkmate::assert_string(title)
  
  choices <- colnames(df)
  
  checkmate::assert_subset(x_var, choices)
  checkmate::assert_subset(y_var, choices)
  checkmate::assert_subset(color_var, choices)
  
  x_var_sym <- rlang::sym(x_var)
  y_var_sym <- rlang::sym(y_var)
  color_var_sym <- rlang::sym(color_var)
  
  ggplot2::ggplot(
    data = df,
    mapping = ggplot2::aes(
      x = !!x_var_sym,
      y = !!y_var_sym,
      color = !!color_var_sym
    )
  ) + 
    ggplot2::geom_point() + 
    ggplot2::ggtitle(title)
}

#' Get DB configuration
#' 
#' @param cfg configuration list
#' 
#' @return list
get_db_config <- function(cfg){
  checkmate::assert_list(cfg)
  checkmate::assert_set_equal(
    x = names(cfg), 
    y = "db"
  )
  
  db_cfg <- cfg[["db"]]
  
  checkmate::assert_list(db_cfg)
  checkmate::assert_set_equal(
    x = names(db_cfg), 
    y = c("host", "user", "password")
  )
  
  checkmate::assert_string(
    x = db_cfg[["host"]],
    min.chars = 1
  )
  checkmate::assert_string(
    x = db_cfg[["user"]],
    min.chars = 1
  )
  checkmate::assert_string(
    x = db_cfg[["password"]],
    min.chars = 1
  )
  
  db_cfg
}

#' Get columns for condition function
#' 
#' @param df data.frame
#' @param fun function
#' 
#' @return character vector
get_col_names <- function(df, fun){
  checkmate::assert_data_frame(df)
  checkmate::assert_function(fun)
  
  df |>
    dplyr::select(tidyselect::where(fun)) |>
    colnames()
}
