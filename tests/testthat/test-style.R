test_that("xaringan comments work", {
  code <- 'base <- c(
  "grep",
  "grepl",
  "sub", #<<
  "gsub", #<<
  "regexpr",
  "gregexpr",
  "regexec"
)'
  code_styled <- grk_style_text(code)
  expect_equal(paste(code_styled, collapse = "\n"), code)
})
