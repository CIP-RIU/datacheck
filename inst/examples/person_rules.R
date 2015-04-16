is.integer(id) # id
id > 0 & id < 11 # id

is.character(lastname) #lastname
is.properName(lastname) #lastname

is.character(firstname) #firstname
is.properName(firstname) #firstname

is.character(gender) #gender
is.oneOf(gender, c("m", "f")) #gender

age > 10 & age < 70