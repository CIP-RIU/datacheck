
# SETUP sample database
ELEVATION = -1:8
LOCATION  = LETTERS[1:10]
GENUS = rep("Solanum")
db = cbind(ELEVATION, LOCATION, GENUS )
db = as.data.frame(db, stringsAsFactors=F)

context("datacheck helper function: has_punct")

test_that("has_punct works",{
  expect_that( has_punct("test")  , is_false() )
  expect_that( has_punct("test123")  , is_false() )
  expect_that( has_punct("test  123")  , is_true() ) 
  expect_that( has_punct("test.")    , is_true() )
  expect_that( has_punct("test?")    , is_true() )
  expect_that( has_punct("test'")    , is_true() )
  expect_that( has_punct("test\\")   , is_true() )
  expect_that( has_punct("test!")    , is_true() )
  expect_that( has_punct("test_")    , is_true() )
  expect_that( has_punct("test@")    , is_true() )
  expect_that( has_punct("test#")    , is_true() )
  expect_that( has_punct("test$")    , is_true() )
  expect_that( has_punct("test\\%")  , is_true() )
  expect_that( has_punct("test^")  , is_true() )
  expect_that( has_punct("test\\&")  , is_true() )
  expect_that( has_punct("test\\*")  , is_true() )
  expect_that( has_punct("test\\(")  , is_true() )
  expect_that( has_punct("test\\)")  , is_true() )
  expect_that( has_punct("test-")  , is_true() )
  expect_that( has_punct("test+")  , is_true() )
  expect_that( has_punct("test=")  , is_true() )
  expect_that( has_punct("test:")  , is_true() )
  expect_that( has_punct("test;")  , is_true() )
  expect_that( has_punct("test<")  , is_true() )
  expect_that( has_punct("test>")  , is_true() )
  expect_that( has_punct("test,")  , is_true() )
  expect_that( has_punct("test\\/")  , is_true() )
  expect_that( has_punct("test\\{")  , is_true() )
  expect_that( has_punct("test\\}")  , is_true() )
  expect_that( has_punct("test\\[")  , is_true() )
  expect_that( has_punct("test\\]")  , is_true() )
  expect_that( has_punct("test\\|")  , is_true() )
  expect_that( has_punct("test\\\\")  , is_true() )
  
})


context("datacheck helper function: is_proper_name")

test_that("is_proper_name works",{
  expect_that( is_proper_name("Solanum")    , is_true() )
  expect_that( is_proper_name("123") , is_false() )
  expect_that( is_proper_name(123) , is_false() )
  expect_that( is_proper_name("Sol_anum") , is_false() )
  expect_that( is_proper_name("solanum") , is_false() )
  expect_that( is_proper_name("Sol-anum") , is_false() )
  expect_that( is_proper_name("Sol@anum") , is_false() )
})

context("datacheck helper function: is_only_lowers")

test_that("is_only_lowers works",{
  expect_that( is_only_lowers("solanum")    , is_true() )
  expect_that( is_only_lowers("Solanum") , is_false() )
  expect_that( is_only_lowers("123") , is_false() )
  expect_that( is_only_lowers("sol.") , is_false() )
  expect_that( is_only_lowers("sol-") , is_false() )
  expect_that( is_only_lowers("so12l") , is_false() )
  expect_that( is_only_lowers(123) , throws_error() )
  expect_that( is_only_lowers() , throws_error() )
  expect_that( is_only_lowers(x) , throws_error() )
})

context("datacheck helper function: is_one_of")

test_that("is_one_of works",{
  expect_that( is_one_of("s","s")    , is_true() )
  expect_that( is_one_of("S",c("T","S")) , is_true() )
  expect_that( is_one_of("s","t") , is_false() )
  
  #expect_that( is_one_of( c("a","b"),c("a","b","c")) , is_true() )
})


context("datacheck helper function: is_within_range")

test_that("is_within_range works",{
  expect_that( is_within_range(2,2,3)    , is_true() )
  expect_that( is_within_range(2,1,3)    , is_true() )
  expect_that( is_within_range(1,1,3)    , is_true() )
  expect_that( is_within_range(3,1,3)    , is_true() )
  expect_that( is_within_range(3.1,1,3)    , is_false() )
  
  expect_that( is_within_range(0,1,3) , is_false() )
 expect_that( is_within_range("x",1,3) , throws_error() )
})


context("datacheck helper function: apply a rule")

test_that("Rule testing works", {
  ELEVATION = -1:8
  LOCATION  = LETTERS[1:10]
  GENUS = rep("Solanum")
  db = cbind(ELEVATION, LOCATION, GENUS )
  db = as.data.frame(db, stringsAsFactors=F)
  expect_that( check_data_rule("-1 <= ELEVATION", db)[1], is_true() )
  expect_that( check_data_rule("ELEVATION <=8  ", db)[10], is_true() )
  expect_that( check_data_rule("1 <= ELEVATION & ELEVATION <= 9", db)[2], is_false() )
  expect_that( check_data_rule("1 <= ELEVATION & ELEVATION <= 9", db)[3], is_true() )
  expect_that( all(check_data_rule("sapply(LOCATION, is.character)", db)), is_true() )
  expect_that( all(check_data_rule("'A' %in% LOCATION", db)), is_true() )
  expect_that( all(check_data_rule("sapply(GENUS,is_proper_name)", db)), is_true() )
  rm(db)
})


context("Testing reading a rules file in R compliant format.")

test_that("Reading a file works",{
  apath = system.file("examples/rules.R", package='datacheck')
  # SETUP sample database
  ELEVATION = -1:8
  LOCATION  = LETTERS[1:10]
  GENUS = rep("Solanum")
  db = cbind(ELEVATION, LOCATION, GENUS )
  db = as.data.frame(db, stringsAsFactors=F)
  
                    
  expect_that( is.na(read_rules("")), is_true())
  
  expect_that( is.na(read_rules(NA)),  is_true())
  expect_that( (nrow(read_rules(apath)) > 0), is_true())
  
  rr = read_rules(apath)
#   print("\n")
#   print(rr)
#   expect_that( all(check_data_rule(rr[4,"Rules"], db)), is_true())
#   expect_that( all(check_data_rule(rr[6,"Rules"], db)), is_true())
  
  rm(db)
})

context("Testing the rule profiler.")

test_that("Rule profiling works",{
  arule = system.file("examples/rules.R", package='datacheck')
  arule2 = system.file("examples/rules2.R", package='datacheck')
  atbl  = system.file("examples/db.csv", package='datacheck')
  atbler= system.file("examples/db-err.csv", package='datacheck')
  
  at = read.csv(atbl, stringsAsFactors = FALSE)
  ad = read_rules(arule)
  
  pt = datadict_profile(at, ad)
  expect_that( nrow(pt$checks)==9, is_true())
  expect_that( has_rule_errors(pt$checks),  is_false())
  rm(pt)
  
  at = read.csv(atbler, stringsAsFactors = FALSE)
  pte = datadict_profile(at, ad)
  at = read.csv(atbler, stringsAsFactors = FALSE, encoding = "UTF-8")
  expect_that( nrow(pte$checks)==9, is_true())
  expect_that( is.na(read_rules(arule2)), is_true())
  
})

context("Testing: pkg_version")

test_that("Access works",{
  expect_that( pkg_version("datacheck") == "1.1.0", is_true() )
})

