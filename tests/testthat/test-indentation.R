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
