clone_git <- function(url) {
  
  system(paste("git clone", url))
  path <- extract_repo_name(url)
  cat("Setting working directory to ", path)
  setwd(path)
  
  invisible(TRUE)
}

extract_repo_name <- function(url) {
  gsub(".*/([A-Za-z0-9._-]+?)(\\.git|/)?$", "\\1", url)
}

write_gitignore <- function(..., path = ".") {
  gitignew <- c(...)
  if (file.exists(".gitignore")) {
    gitignore <- readLines(".gitignore")
    gitignew <- union(gitignore, gitignew)
  }
  cat(gitignew, file = file.path(path, ".gitignore"), append = FALSE, sep = "\n")
  invisible(TRUE)
}
