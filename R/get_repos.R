#' Retrieve all repos for an organization or user
#'
#' Given a username or organization, retrieve all the repos
#'
#' @param owner the name of the organization or user to retrieve a list of repos from. E.g. fhdsl
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
#' # Now you can retrieve the repositories
#' repos_df <- get_repos("fhdsl")
#'
#' # Alternatively, you can supply the GitHub PAT directly
#' # to the function to avoid doing the steps above.
#' repos_df <- get_repos("fhdsl", git_pat = "gh_somepersonalaccesstokenhere")
#' }
get_repos <- function(owner,
                      how_many = "all",
                      git_pat = NULL,
                      verbose = TRUE) {

  # Try to get credentials
  auth_arg <- get_git_auth(git_pat = git_pat, quiet = !verbose)

  git_pat <- try(auth_arg$password, silent = TRUE)

  if (!grepl("Error", git_pat[1])) {

    # Set up the per_page parameter based on the how_many argument
      if (how_many == "all" || how_many > 100) {
        max <- 100
      } else {
        max <- as.numeric(how_many)
      }

      # Get the issues through API query with gh package
      my_repos <- gh::gh("GET /users/{owner}/repos", owner = owner, per_page = max)

      # Make it into a dataframe
      repos_df <- suppressWarnings(as.data.frame(t(do.call(cbind, my_repos))))

      if (how_many > 100) {

        next_repos <- my_repos

        while(!grepl("No next page", next_repos[[1]])[1]) {

          next_repos <- try(gh::gh_next(next_repos), silent = TRUE)

          if (!grepl("No next page", next_repos[[1]])[1]) {
          next_repos_df <- suppressWarnings(as.data.frame(t(do.call(cbind, next_repos))))

          repos_df <- dplyr::bind_rows(repos_df, next_repos_df)
          }
        }
      }
    }
  return(repos_df)
}
