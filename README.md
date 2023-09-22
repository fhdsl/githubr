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

## Set up credentials

First, set up your GitHub credentials using `usethis::gitcreds_set()`. 
```
install.packages(c("usethis", "gitcreds"))

# Get a token
usethis::create_github_token()

# Give this token to gitcreds_set()
gitcreds::gitcreds_set()
```

## What you can do (so far)

Now you can rock and roll with `githubr`. 

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
