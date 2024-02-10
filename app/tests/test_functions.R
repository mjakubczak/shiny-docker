library(testthat)

source("../functions.R")

test_that(
  desc = "generate_plot tests",
  code = {
    expect_is(
      object = generate_plot(
        df = iris,
        x_var = "Petal.Width",
        y_var = "Sepal.Length",
        color_var = "Species"
      ), 
      class = "ggplot"
    )
    
    expect_error(
      object = generate_plot(
        df = NULL,
        x_var = "Petal.Width",
        y_var = "Sepal.Length",
        color_var = "Species"
      ), 
      regexp = "Assertion on 'df' failed: Must be of type 'data.frame', not 'NULL'"
    )
    
    expect_error(
      object = generate_plot(
        df = iris,
        x_var = "dummy",
        y_var = "Petal.Width",
        color_var = "Species"
      ), 
      regexp = "Assertion on 'x_var' failed"
    )
    
    expect_error(
      object = generate_plot(
        df = iris,
        x_var = "Petal.Width",
        y_var = "dummy",
        color_var = "Species"
      ), 
      regexp = "Assertion on 'y_var' failed"
    )
    
    expect_error(
      object = generate_plot(
        df = iris,
        x_var = "Petal.Width",
        y_var = "Sepal.Length",
        color_var = "dummy"
      ), 
      regexp = "Assertion on 'color_var' failed"
    )
    
    expect_error(
      object = generate_plot(
        df = iris,
        x_var = "Petal.Width",
        y_var = "Sepal.Length",
        color_var = "Species",
        title = NULL
      ), 
      regexp = "Assertion on 'title' failed"
    )
  }
)

test_that(
  desc = "get_col_names tests",
  code = {
    expect_equal(
      object = get_col_names(iris, is.numeric),
      expected = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
    )
    
    expect_equal(
      object = get_col_names(iris, is.factor),
      expected = "Species"
    )
    
    expect_equal(
      object = get_col_names(iris, is.character),
      expected = character(0)
    )
    
    expect_error(
      object = get_col_names(list(a = 1, b = 2), is.numeric),
      regexp = "Assertion on 'df' failed"
    )
    
    expect_error(
      object = get_col_names(NULL, is.numeric),
      regexp = "Assertion on 'df' failed"
    )
    
    expect_error(
      object = get_col_names(iris, NULL),
      regexp = "Assertion on 'fun' failed"
    )
  }
)

test_that(
  desc = "get_db_config tests",
  code = {
    cfg <- list(
      db = list(
        host = "localhost",
        user = "user",
        password = "password"
      )
    )
    
    res <- get_db_config(cfg)
    expect_is(
      object = res,
      class = "list"
    )
    expect_equal(
      object = res,
      expected = cfg$db
    )
    
    expect_error(
      object = get_db_config(list(
        dbx = list(
          host = "localhost",
          user = "user",
          password = "password"
        )
      )),
      regexp = "Assertion on 'names\\(cfg\\)' failed"
    )
    
    expect_error(
      object = get_db_config(list(
        db = list(
          hostx = "localhost",
          user = "user",
          password = "password"
        )
      )),
      regexp = "Assertion on 'names\\(db_cfg\\)' failed"
    )
    
    expect_error(
      object = get_db_config(list(
        db = list(
          host = NULL,
          user = "user",
          password = "password"
        )
      )),
      regexp = "Assertion on 'db_cfg\\[\\[\"host\"\\]\\]' failed"
    )
    
    expect_error(
      object = get_db_config(list(
        db = list(
          host = "",
          user = "user",
          password = "password"
        )
      )),
      regexp = "Assertion on 'db_cfg\\[\\[\"host\"\\]\\]' failed"
    )
    expect_error(
      object = get_db_config(list(
        db = list(
          host = "localhost",
          user = "",
          password = "password"
        )
      )),
      regexp = "Assertion on 'db_cfg\\[\\[\"user\"\\]\\]' failed"
    )
    
    expect_error(
      object = get_db_config(list(
        db = list(
          host = "localhost",
          user = "user",
          password = ""
        )
      )),
      regexp = "Assertion on 'db_cfg\\[\\[\"password\"\\]\\]' failed"
    )
  }
)

test_that(
  desc = "selectize_with_placeholder tests",
  code = {
    res <- selectize_with_placeholder(
      inputId = "dummy",
      label = "Dummy",
      placeholder_text = "test placeholder"
    )
    
    expect_is(
      object = res,
      class = "shiny.tag"
    )
    opts_json <- res$children[[2]]$children[[2]]$children[[1]]
    expect_is(
      object = opts_json,
      class = "character"
    )
    expect_true(jsonlite::validate(opts_json))
    opts_list <- jsonlite::fromJSON(opts_json)
    expect_true("placeholder" %in% names(opts_list))
    expect_equal(
      object = opts_list[["placeholder"]],
      expected = "test placeholder"
    )
    
    res2 <- selectize_with_placeholder(
      inputId = "dummy",
      label = "Dummy",
      options = list(placeholder = "wrong placeholder"),
      placeholder_text = "test placeholder 2"
    )
    opts_list2 <- jsonlite::fromJSON(res2$children[[2]]$children[[2]]$children[[1]])
    expect_equal(
      object = opts_list2[["placeholder"]],
      expected = "test placeholder 2"
    )
    
    expect_error(
      object = selectize_with_placeholder(
        inputId = "",
        label = "Dummy"
      ),
      regexp = "Assertion on 'inputId' failed"
    )
    expect_error(
      object = selectize_with_placeholder(
        inputId = "dummy",
        label = "Dummy",
        placeholder_text = ""
      ),
      regexp = "Assertion on 'placeholder_text' failed"
    )
  }
)
