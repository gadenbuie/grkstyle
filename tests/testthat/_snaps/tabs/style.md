# tabs not spaces

    Code
      as_grk_styled_text(text_vec)
    Output
      fruits <- c(
      	"apple",
      	"banana",
      	"mango"
      )

# line breaks

    Code
      as_grk_styled_text(text_line_breaks)
    Output
      do_something_very_complicated(
      	something = "that",
      	requires = many,
      	arguments = "some of which may be long"
      )

# function args

    Code
      as_grk_styled_text(text_fn_args)
    Output
      long_function_name <- function(
      	a = "a long argument",
      	b = "another argument",
      	c = "another long argument"
      ) {
      	# As usual code is indented by two spaces.
      }

