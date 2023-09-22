# githubr

An easier to use GitHub API wrapper for R

**This is really newly under development**

## How to install

``` r
if (!("remotes" %in% installed.packages())) {
  install.packages("remotes")
}
remotes::install_github("fhdsl/githubr")
```

## What you can do (so far)

Return a TRUE/FALSE if a repo exists:
```
exists <- check_git_repo("jhudsl/OTTR_Template")

if (exists) message("Yup, this repo exists")
```

Return a data frame of repos' information for an organization or user
```
repos_df <- get_repos("fhdsl")
```

Return a data frame of issues' information for a repo
```
issues_df <- get_issues("jhudsl/OTTR_Template")
```
