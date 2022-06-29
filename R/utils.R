pkg_version <- function() {
	read.dcf(system.file("DESCRIPTION", package = "grkstyle"))[, "Version"][[1]]
}
