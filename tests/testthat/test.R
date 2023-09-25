test_that("get_issues", {

  # Only is tested if we have credentials available
  if (class(get_git_auth()) == "gitcreds") {

    # Test the issue getter
    issues_df <- get_issues("jhudsl/OTTR_Template")
    expect_true(is.data.frame(issues_df))

    # Test the repo getter
    repos_df <- get_repos("fhdsl")
    expect_true(is.data.frame(repos_df))
  }

})
