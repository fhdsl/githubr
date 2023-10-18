test_that("githubr", {

  git_credentials <- try(gitcreds::gitcreds_get()$password, silent = TRUE)

  git_pat_found <- grepl("ghp", git_credentials)

  # Only is tested if we have credentials available
  if (git_pat_found) {

    # Test the issue getter
    issues_df <- get_issues("jhudsl/OTTR_Template")
    testthat::expect_true(is.data.frame(issues_df))

    # Test the issue getter with a PAT
    issues_df <- get_issues("jhudsl/OTTR_Template", git_pat = git_credentials)
    testthat::expect_true(is.data.frame(issues_df))

    # Test the repo getter
    repos_df <- get_repos("fhdsl", git_pat = git_credentials)
    testthat::expect_true(is.data.frame(repos_df))
  }

})
