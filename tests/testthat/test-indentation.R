test_that("re-indentation works as expected", {
	code <- c("fruits <- c(", '"apple",', '"banana",', '"mango"\n)')
	code_tabs     <- strsplit(paste(code, collapse = "\n\t"), "\n")[[1]]
	code_spaces_2 <- strsplit(paste(code, collapse = "\n  "), "\n")[[1]]
	code_spaces_4 <- strsplit(paste(code, collapse = "\n    "), "\n")[[1]]

	expect_equal(
		grk_reindent_tabs_text(code_spaces_2),
		code_tabs,
		ignore_attr = TRUE
	)
	expect_equal(
		grk_reindent_tabs_text(code_spaces_4),
		code_tabs,
		ignore_attr = TRUE
	)
	expect_equal(
		grk_reindent_tabs_text(grk_reindent_tabs_text(code_spaces_2)),
		code_tabs,
		ignore_attr = TRUE
	)
	expect_equal(
		grk_reindent_spaces_text(code_tabs),
		code_spaces_2,
		ignore_attr = TRUE
	)
	expect_equal(
		grk_reindent_spaces_text(code_tabs, indent_by = 4),
		code_spaces_4,
		ignore_attr = TRUE
	)
	expect_equal(
		grk_reindent_spaces_text(grk_reindent_spaces_text(code_tabs)),
		code_spaces_2,
		ignore_attr = TRUE
	)
})

test_that("re-indentation isn't too aggressive with pipes", {
	pipe <- 'if (TRUE) {\n  html <- html %>% paste(collapse = "\\n") %>% xml2::read_html()\n}'

	expect_equal(
		paste(grk_reindent_tabs_text(pipe), collapse = "\n"),
		sub("\n  ", "\n\t", pipe),
		ignore_attr = TRUE
	)
})

test_that("re-indentation isn't too aggressive with oneline ifs", {
	if_oneline <- 'if (TRUE) runif(12)'

	expect_equal(
		paste(grk_reindent_tabs_text(if_oneline), collapse = "\n"),
		if_oneline,
		ignore_attr = TRUE
	)

	if_else_oneline <- 'if (TRUE) runif(12) else runif(13)'
	expect_equal(
		paste(grk_reindent_tabs_text(if_else_oneline), collapse = "\n"),
		if_else_oneline,
		ignore_attr = TRUE
	)
})
