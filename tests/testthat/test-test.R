test_that("githubr", {

  git_pat <- try(gitcreds::gitcreds_get(), silent = TRUE)

  # Only is tested if we have credentials available
  if (class(git_pat) == "gitcreds") {

    # Test the issue getter
    issues_df <- get_issues("jhudsl/OTTR_Template")
    testthat::expect_true(is.data.frame(issues_df))

    # Test the issue getter with a PAT
    issues_df <- get_issues("jhudsl/OTTR_Template", git_pat = git_pat$password)
    testthat::expect_true(is.data.frame(issues_df))

    # Test the repo getter
    repos_df <- get_repos("fhdsl")
    testthat::expect_true(is.data.frame(repos_df))

    # Test the repo getter
    repos_df <- get_repos("fhdsl", git_pat = git_pat$password)
    testthat::expect_true(is.data.frame(repos_df))
  }

})
