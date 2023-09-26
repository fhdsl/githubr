test_that("githubr", {

  auth_arg <- try(gitcreds::gitcreds_get(), silent = TRUE)

  # Only is tested if we have credentials available
  if (class(auth_arg) != "try-error") {

    # Test the issue getter
    issues_df <- get_issues("jhudsl/OTTR_Template")
    expect_true(is.data.frame(issues_df))

    # Test the repo getter
    repos_df <- get_repos("fhdsl")
    expect_true(is.data.frame(repos_df))
  }

})
