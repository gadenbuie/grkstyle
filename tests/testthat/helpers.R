with_options <- function(opts, expr) {
	old <- options(opts)
	on.exit(options(old))
	force(expr)
}
