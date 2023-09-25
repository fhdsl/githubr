#' Retrieve all issues on a repository
#'
#' Given a repository name, get a list of issues.
#'
#' @param repo_name the name of the repository to retrieve issues from, e.g. jhudsl/OTTR_Template
#' @param how_many put the number of how many you would like returned. If all, put "all". By default will return all issues.
#' @param git_pat A personal access token from GitHub. Only necessary if the
#' repository being checked is a private repository.
#' @param verbose TRUE/FALSE do you want more progress messages?
#'
#' @return A data frame that contains information about the issues from the given repository
#' @importFrom gh gh
#' @importFrom dplyr bind_rows
#'
#' @export
#'
#' @examples  \dontrun{
#'
#' # First, set up your GitHub credentials using `usethis::gitcreds_set()`.
#' # Get a GitHub personal access token (PAT)
#' usethis::create_github_token()
#'
#' # Give this token to `gitcreds_set()`
#' gitcreds::gitcreds_set()
#'
#' # Now you can retrieve issues
#' issues_df <- get_issues("jhudsl/OTTR_Template")
#
#' # Alternatively, you can supply the GitHub PAT directly
#' # to the function to avoid doing the steps above.
#' issues_df <- get_issues("jhudsl/OTTR_Template", git_pat = "gh_somepersonalaccesstokenhere")
#' }
get_issues <- function(repo_name,
                       how_many = "all",
                       git_pat = NULL,
                       verbose = TRUE) {
  if (verbose) {
    message(paste("Checking for remote git repository:", repo_name))
  }

  # Try to get credentials
  auth_arg <- get_git_auth(git_pat = git_pat, quiet = !verbose)

  git_pat <- try(auth_arg$password, silent = TRUE)

  if (!grepl("Error", git_pat[1])) {

    repo_exists <- check_git_repo(repo_name, git_pat)

    if (repo_exists) {

      # Set up the per_page parameter based on the how_many argument
      if (how_many == "all" || how_many > 100) {
        max <- 100
      } else {
        max <- as.numeric(how_many)
      }

      # Get the issues through API query with gh package
      my_issues <- gh::gh("GET /repos/{repo}/issues", repo = repo_name, per_page = max)

      # Make it into a dataframe
      issues_df <- suppressWarnings(as.data.frame(t(do.call(cbind, my_issues))))

      if (how_many > 100) {

        next_issues <- my_issues

        while(!grepl("No next page", next_issues[[1]])[1]) {

          next_issues <- try(gh::gh_next(next_issues), silent = TRUE)

          if (!grepl("No next page", next_issues[[1]])[1]) {
          next_issues_df <- suppressWarnings(as.data.frame(t(do.call(cbind, next_issues))))

          issues_df <- dplyr::bind_rows(issues_df, next_issues_df)
          }
        }
      }
    } else {
      stop("That repo doesn't exist or you don't have the credentials to see it.")
    }
  }
  return(issues_df)
}
