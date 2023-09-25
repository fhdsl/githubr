#' Accept an invite
#'
#' Given an a user name, accept all invites
#'
#' @param git_pat Whatever credentials are given are where invites will be accepted from.
#'  If none is supplied, then this will attempt to grab from a git pat set in the environment with usethis::create_github_token().
#' @param verbose TRUE/FALSE do you want more progress messages?
#'
#' @return a response from GitHub's API
#'
#' @importFrom magrittr %>%
#' @import dplyr
#' @importFrom httr GET add_headers accept_json
#'
#' @export
#'
#' @examples \dontrun{
#'
#' # First, set up your GitHub credentials using `usethis::gitcreds_set()`.
#' # Get a GitHub personal access token (PAT)
#' usethis::create_github_token()
#'
#' # Give this token to `gitcreds_set()`
#' gitcreds::gitcreds_set()
#'
#' # All invites that have been sent to the PAT you have provided you will be accepted
#' accept_all_invites()
#' }
accept_all_invites <- function(git_pat = NULL,
                               verbose = TRUE) {

  # Try to get credentials other way
  auth_arg <- get_git_auth(git_pat = git_pat, quiet = TRUE)

  git_pat <- try(auth_arg$password, silent = TRUE)

  invites_url <- "https://api.github.com/user/repository_invitations"

  # Github api get
  response <- httr::GET(
    invites_url,
    httr::add_headers(Authorization = paste0("token ", git_pat)),
    httr::accept_json()
  )

  if (httr::http_error(response)) {
    stop(paste0("url: ", invites_url, " failed"))
  }

  content <- unlist(httr::content(response))
  urls <- grep("^https://api.github.com/user/repository_invitations/", content, value = TRUE)

  responses <- sapply(urls, function(url) {
    response <- httr::PATCH(
      url,
      httr::add_headers(Authorization = paste0("token ", git_pat)),
      httr::accept_json()
    )
    if (httr::http_error(response)) {
      stop(paste0("url: ", invites_url, " failed"))
    }
  })

  return(responses)
}
