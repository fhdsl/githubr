#' Handle GitHub PAT authorization
#'
#' Handle things whether or not a GitHub PAT is supplied.
#'
#' @param git_pat If private repositories are to be retrieved, a github personal
#' access token needs to be supplied. If none is supplied, then this will attempt to
#' grab from a git pat set in the environment with usethis::create_github_token().
#' @param git_username Optional, can include username for credentials.
#' @param quiet Use TRUE if you don't want the warning about no GitHub credentials.
#'
#' @return Authorization argument to supply to curl OR a blank string if no
#' authorization is found or supplied.
#'
#' @export
#'
get_git_auth <- function(git_pat = NULL, git_username = "PersonalAccessToken", quiet = FALSE) {
  auth_arg <- NULL

  # If git pat is not provided, try to get credentials with gitcreds
  if (is.null(git_pat)) {

    # Try getting credentials
    auth_arg <- try(gitcreds::gitcreds_get(), silent = TRUE)

    if (grepl("Could not find any credentials", auth_arg[1])) {

      # Only if we're running this interactively
      if (interactive()) {
        # Set credentials if null
        auth_arg <- gitcreds::gitcreds_set()
      } else {
        if (!quiet) {
          message("Could not find git credentials, please set by running usethis::create_github_token(),
                    or directly providing a personal access token using the git_pat argument")
        }
      }
    }
  } else { # If git_pat is given, use it.
    # Set to Renviron file temporarily
    Sys.setenv(GITHUB_PAT = git_pat)

    # Put it in gitcreds
    auth_arg <- gitcreds::gitcreds_get()

    # Delete from Renviron file
    Sys.unsetenv("GITHUB_PAT")

    # Set up rest of token
    auth_arg$protocol <- "https"
    auth_arg$host <- "github.com"
    auth_arg$username <- git_username
  }

  # Check if we have authentication
  git_pat <- try(auth_arg$password, silent = TRUE)

  if (grepl("Error", git_pat[1])) {
    if (!quiet) {
      message("No github credentials found or provided; only public repositories will be successful.")
    }
  }

  return(auth_arg)
}
