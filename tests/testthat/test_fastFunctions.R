requireNamespace("data.table")
verbose <- TRUE
## fastFilterVariables
#---------------------
data("messy_adult")
# Make it smaller to go faster
messy_adult <- messy_adult[1:5000, ]
messy_adult$age2 = messy_adult$age # add a double

test_that("fastFilterVariables: ", 
          {
            expect_equal(ncol(fastFilterVariables(messy_adult, verbose = verbose)), 20)
          })

## fastRound
##----------
M <- as.data.table(matrix(runif (3e4), ncol = 10))
M[, stringColumn := "a string"] 

test_that("fastRound: ", 
          {
            expect_equal(all(fastRound(M, verbose = verbose)[,1] == round(M[, 1], 2)), TRUE)
            expect_equal(all(fastRound(M, digits = 1, verbose = verbose)[,1] == round(M[, 1], 1)), TRUE)
            expect_error(fastRound(M, digits = "a", verbose = verbose), ": digits should be an integer")
          })


## Handle NA Values
#-------------------
dataSet <-  data.table(numCol = c(1, 2, 3, NA), 
                       charCol = c("", "a", NA, "c"), 
                       booleanCol = c(TRUE, NA, FALSE, NA))

# To set NAs to 0, FALSE and "" (respectivly for numeric, boolean, character)
data_withoutNA <- fastHandleNa(dataSet)

test_that("fastHandleNa: There are no more NAs", 
          {
            expect_equal(sum(is.na(data_withoutNA)), 0)
          })

data("messy_adult")
messy_adult$mail[sample(1:nrow(messy_adult), 10)] = NA
messy_adult <- fastHandleNa(messy_adult)
test_that("fastHandleNa: There are no more NAs with factor", 
          {
            expect_equal(sum(is.na(messy_adult)), 0)
          })

## fastIsEqual
#--------------
data("messy_adult")

test_that("private function: fastIsEqual", 
          {
            expect_equal(fastIsEqual(1:9, 1:10), FALSE)
            expect_equal(fastIsEqual(messy_adult[["education"]], messy_adult[["education_num"]]), FALSE)
            expect_equal(fastIsEqual(1:10, 1:10), TRUE)
            expect_equal(fastIsEqual(1:1001, 1:1001), TRUE)
            expect_equal(fastIsEqual(LETTERS, LETTERS), TRUE)
            expect_equal(fastIsEqual(1, 1), TRUE)
            expect_equal(fastIsEqual(1, 2), FALSE)
            expect_equal(fastIsEqual(messy_adult, messy_adult), TRUE)
          }
)




## fastIsBijection
# -----------------
data("adult")

test_that("private function: fastIsBijection", 
          {
            expect_equal(fastIsBijection(adult[["education"]], adult[["education_num"]]), TRUE)
            expect_equal(fastIsBijection(adult[["education"]], adult[["income"]]), FALSE)
          }
)

## fastMaxNbElt
# -------------
test_that("private function: fastMaxNbElt", 
          {
            expect_equal(fastMaxNbElt(sample(1:5, 100, replace = TRUE), 1), FALSE)
            expect_equal(fastMaxNbElt(sample(1:5, 100, replace = TRUE), 4), FALSE)
            expect_equal(fastMaxNbElt(sample(1:5, 100, replace = TRUE), 5), TRUE)
          })

