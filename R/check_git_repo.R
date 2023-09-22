#' Check if a repository exists on GitHub
#'
#' Given a repository name, check with git ls-remote whether the repository exists and return a TRUE/FALSE
#'
#' @param repo_name the name of the repository, e.g. jhudsl/OTTR_Template
#' @param git_pat A personal access token from GitHub. Only necessary if the
#' repository being checked is a private repository.
#' @param silent TRUE/FALSE of whether the warning from the git ls-remote
#' command should be echoed back if it does fail.
#' @param verbose TRUE/FALSE do you want more progress messages?
#' @param return_repo TRUE/FALSE of whether or not the output from git ls-remote
#' should be saved to a file (if the repo exists)
#'
#' @return A TRUE/FALSE whether or not the repository exists. Optionally the
#' output from git ls-remote if return_repo = TRUE.
#'
#' @export
#'
#' @examples
#'
#' check_git_repo("jhudsl/OTTR_Template")
check_git_repo <- function(repo_name,
                           git_pat = NULL,
                           silent = TRUE,
                           return_repo = FALSE,
                           verbose = TRUE) {
  if (verbose) {
    message(paste("Checking for remote git repository:", repo_name))
  }
  # If silent = TRUE don't print out the warning message from the 'try'
  report <- ifelse(silent, suppressWarnings, message)

  # Try to get credentials
  auth_arg <- get_git_auth(git_pat = git_pat, quiet = !verbose)

  git_pat <- try(auth_arg$password, silent = TRUE)

  # Run git ls-remote
  if (!grepl("Error", git_pat[1])) {
    # If git_pat is supplied, use it
    test_repo <- report(
      try(system(paste0("git ls-remote https://", git_pat, "@github.com/", repo_name),
        intern = TRUE, ignore.stderr = TRUE
      ))
    )
  } else {
    # Try to git ls-remote the repo_name given
    test_repo <- report
    try(system(paste0("git ls-remote https://github.com/", repo_name),
      intern = TRUE, ignore.stderr = TRUE
    ))
  }
  # If 128 is returned as a status attribute it means it failed
  exists <- ifelse(is.null(attr(test_repo, "status")), TRUE, FALSE)

  if (return_repo && exists) {
    # Make file name
    output_file <- paste0("git_ls_remote_", gsub("/", "_", repo_name))

    # Tell the user the file was saved
    message(paste("Saving output from git ls-remote to file:", output_file))

    # Write to file
    writeLines(exists, file.path(output_file))
  }

  return(exists)
}
