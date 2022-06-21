#'
#' #' An S4 class to hold species information
#' #'
#' #' @slot aou The AOU
#' #' @slot genus genus
#' #' @slot species species
#' #' @slot mean_size size
#' #' @slot sd_size sd of size
#' #' @slot sd_method known, or estimated
#' #' @slot id if AOU is provided, AOU; otherwise an integer for keeping track of hypothetical species
#'
#' Species <- setClass("Species", slots = list(aou = "numeric", genus = "character", species = "character", mean_size = "numeric", sd_size = "numeric", sd_method = "character", id = "numeric"))
#'
