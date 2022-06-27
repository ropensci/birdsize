#' Format a data frame nicely for printing
#'
#' @param data_table a data frame
#'
#' @return formatted datatable
#'
#' @export
#' @examples
#'
#' niceOutput(raw_masses)
#'
#' @importFrom DT datatable
niceOutput <- function(data_table) {
  DT::datatable(
    data_table,
    extensions = c('FixedColumns',"FixedHeader"),
    options = list(
      scrollX = TRUE,
      paging=T,
      fixedHeader=TRUE,
      pageLength = 5
    )
  )

}
