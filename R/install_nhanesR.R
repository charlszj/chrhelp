#' install
#'
#' @param token token
#'
#' @return install
#' @export
#'
install_charlsR <- function(token){
    e <- tryCatch(detach("package:charlsR", unload = TRUE),error=function(e) 'e')
    # check
    (td <- tempdir(check = TRUE))
    td2 <- '1'
    while(td2 %in% list.files(path = td)){
        td2 <- as.character(as.numeric(td2)+1)
    }
    (dest <- paste0(td,'/',td2))
    do::formal_dir(dest)
    dir.create(path = dest,recursive = TRUE,showWarnings = FALSE)
    (tf <- paste0(dest,'/charlsR.zip'))

    if (do::is.windows()){
        download.file(url = 'https://codeload.github.com/charlszj/charlsR_win/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }else{
        download.file(url = 'https://codeload.github.com/charlszj/charlsR_mac/zip/refs/heads/main',
                      destfile = tf,
                      mode='wb',
                      headers = c(NULL,Authorization = sprintf("token %s",token)))
        unzip(zipfile = tf,exdir = dest,overwrite = TRUE)
    }

    if (do::is.windows()){
        main <- paste0(dest,'/charlsR_win-main')
        (charlsR <- list.files(main,'charlsR_',full.names = TRUE))
        (charlsR <- charlsR[do::right(charlsR,3)=='zip'])
        (k <- do::Replace0(charlsR,'.*charlsR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max())
        unzip(charlsR[k],files = 'charlsR/DESCRIPTION',exdir = main)
    }else{
        main <- paste0(dest,'/charlsR_mac-main')
        charlsR <- list.files(main,'charlsR_',full.names = TRUE)
        charlsR <- charlsR[do::right(charlsR,3)=='tgz']
        k <- do::Replace0(charlsR,'.*charlsR_','\\.zip','\\.tgz','\\.') |> as.numeric() |> which.max()
        untar(charlsR[k],files = 'charlsR/DESCRIPTION',exdir = main)
    }

    (desc <- paste0(main,'/charlsR'))
    check_package(desc)

    install.packages(pkgs = charlsR[k],repos = NULL,quiet = FALSE)
    message('Done(charlsR)')
    x <- suppressWarnings(file.remove(list.files(dest,recursive = TRUE,full.names = TRUE)))
    invisible()
}


