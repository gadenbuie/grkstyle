test_that("xaringan comments work", {
	code <- 'base <- c(
\t"grep",
\t"grepl",
\t"sub", #<<
\t"gsub", #<<
\t"regexpr",
\t"gregexpr",
\t"regexec"
)'
	code_styled <- grk_style_text(code)
	expect_equal(paste(code_styled, collapse = "\n"), code)
})

as_grk_styled_text <- function(text) {
	grk <- unclass(grkstyle::grk_style_text(text))
	grk <- paste(grk, collapse = "\n")
	cat(grk)
}

test_that("tabs not spaces", {
	text_vec <- 'fruits <- c(\n  "apple",\n  "banana",\n  "mango"\n)'
	expect_snapshot(as_grk_styled_text(text_vec))
})

test_that("line breaks", {
	text_line_breaks <- '
do_something_very_complicated(something = "that", requires = many,
                              arguments = "some of which may be long")
'
	expect_snapshot(as_grk_styled_text(text_line_breaks))
})

test_that("function args", {
	text_fn_args <- '
long_function_name <- function(a = "a long argument",
                               b = "another argument",
                               c = "another long argument") {
  # As usual code is indented by two spaces.
}
'
	expect_snapshot(as_grk_styled_text(text_fn_args))
})
