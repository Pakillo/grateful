
# Get tidyverse packages
# download.file("https://raw.githubusercontent.com/tidyverse/tidyverse/main/DESCRIPTION",
#               destfile = "tidyverse_DESCRIPTION")
# tidy.pkgs <- desc::desc_get_deps("tidyverse_DESCRIPTION")
# tidy.pkgs <- tidy.pkgs[tidy.pkgs$type == "Imports", "package"]
# dput(tidy.pkgs)

tidy.pkgs <- c("broom", "conflicted", "cli", "dbplyr", "dplyr", "dtplyr",
               "forcats", "ggplot2", "googledrive", "googlesheets4", "haven",
               "hms", "httr", "jsonlite", "lubridate", "magrittr", "modelr",
               "pillar", "purrr", "ragg", "readr", "readxl", "reprex", "rlang",
               "rstudioapi", "rvest", "stringr", "tibble", "tidyr", "xml2")

# dput(citation("tidyverse"))
tidyverse.citation <-
  structure(
    list(
      structure(
        list(
          title = "Welcome to the {tidyverse}",
          author = structure(list(
            list(given = "Hadley", family = "Wickham", role = NULL, email = NULL, comment = NULL),
            list(given = "Mara", family = "Averick", role = NULL, email = NULL, comment = NULL),
            list(given = "Jennifer", family = "Bryan", role = NULL, email = NULL, comment = NULL),
            list(given = "Winston", family = "Chang", role = NULL, email = NULL, comment = NULL),
            list(given = c("Lucy", "D'Agostino"), family = "McGowan", role = NULL, email = NULL, comment = NULL),
            list(given = "Romain", family = "Fran\u00e7ois", role = NULL,email = NULL, comment = NULL),
            list(given = "Garrett", family = "Grolemund", role = NULL, email = NULL, comment = NULL),
            list(given = "Alex", family = "Hayes", role = NULL, email = NULL, comment = NULL),
            list(given = "Lionel", family = "Henry", role = NULL, email = NULL, comment = NULL),
            list(given = "Jim", family = "Hester", role = NULL, email = NULL, comment = NULL),
            list(given = "Max", family = "Kuhn", role = NULL, email = NULL, comment = NULL),
            list(given = c("Thomas", "Lin"), family = "Pedersen", role = NULL, email = NULL, comment = NULL),
            list(given = "Evan", family = "Miller", role = NULL, email = NULL, comment = NULL),
            list(given = c("Stephan", "Milton"), family = "Bache", role = NULL, email = NULL, comment = NULL),
            list(given = "Kirill", family = "M\u00fcller", role = NULL, email = NULL, comment = NULL),
            list(given = "Jeroen", family = "Ooms", role = NULL, email = NULL, comment = NULL),
            list(given = "David", family = "Robinson", role = NULL, email = NULL, comment = NULL),
            list(given = c("Dana", "Paige"), family = "Seidel", role = NULL, email = NULL, comment = NULL),
            list(given = "Vitalie", family = "Spinu", role = NULL, email = NULL, comment = NULL),
            list(given = "Kohske", family = "Takahashi", role = NULL, email = NULL, comment = NULL),
            list(given = "Davis", family = "Vaughan", role = NULL, email = NULL, comment = NULL),
            list(given = "Claus", family = "Wilke", role = NULL, email = NULL, comment = NULL),
            list(given = "Kara", family = "Woo", role = NULL, email = NULL, comment = NULL),
            list(given = "Hiroaki", family = "Yutani", role = NULL, email = NULL, comment = NULL)), class = "person"),
          year = "2019", journal = "Journal of Open Source Software",
          volume = "4", number = "43", pages = "1686", doi = "10.21105/joss.01686"), bibtype = "Article",
        textVersion = "Wickham et al., (2019). Welcome to the tidyverse. Journal of Open Source Software, 4(43), 1686, https://doi.org/10.21105/joss.01686")),
    class = c("citation", "bibentry"), package = "tidyverse")
