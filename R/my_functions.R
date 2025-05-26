#' Multiply two matrices and multiply 10 (using Rcpp)
#'
#' This function multiplies two numeric matrices using an Rcpp implementation
#' and multiplies the result by 10.
#'
#' @param x A numeric matrix
#' @param y A numeric matrix
#'
#' @return A numeric matrix: 10 times the matrix product of x and y
#'
#' @details
#' Internally, this function uses \code{prod_cpp()}, a C++ function compiled with Rcpp,
#' to perform fast matrix multiplication. The result is then multiplied by a factor of 10.
#' This function is useful for demonstrating how to combine R and C++ in a package.
#'
#' @examples
#' mat1 <- matrix(1:6, nrow = 2)
#' mat2 <- matrix(1:6, nrow = 3)
#' multiply_matrix_ten_times(mat1, mat2)
#'
#' @references
#' See the full source code and documentation at:\cr
#' \url{https://github.com/downey21/r_package_practice}
#'
#' @export
multiply_matrix_ten_times <- function(x, y) {
    
    result <- prod_cpp(x, y)
    
    return(result * 10)
}

# Internal helper to check for NA values in a matrix
#'
#' This is an internal function that is not exported.
check_for_na <- function(mat) {

    if (anyNA(mat)) {
        idx <- which(is.na(mat), arr.ind = TRUE)
        message("NA found at positions:")
        print(idx)
    }
}

#' Element-wise addition of two matrices
#'
#' This function adds two numeric matrices element-wise. It also checks
#' for NA values in each matrix and reports their locations if found.
#'
#' @param mat1 A numeric matrix
#' @param mat2 A numeric matrix
#'
#' @return A numeric matrix with mat1 + mat2
#'
#' @details
#' The function first calls an internal helper \code{check_for_na()} on both matrices
#' to detect and print the locations of any \code{NA} values. If no \code{NA}s are present,
#' the function returns the element-wise sum of the two matrices using the \code{+} operator.
#'
#' The two matrices must have the same dimensions; otherwise, R will throw an error.
#'
#' @examples
#' mat1 <- matrix(1:4, nrow = 2)
#' mat2 <- matrix(5:8, nrow = 2)
#' plus_two_matrix(mat1, mat2)
#'
#' mat3 <- matrix(c(1, NA, 3, 4), nrow = 2)
#' plus_two_matrix(mat3, mat2)  # Will print NA position
#'
#' @references
#' See the full source code and documentation at:\cr
#' \url{https://github.com/downey21/r_package_practice}
#'
#' @export
plus_two_matrix <- function(mat1, mat2) {
    
    check_for_na(mat1)
    check_for_na(mat2)
    
    return(mat1 + mat2)
}
