import Data.List
import Data.List.Split
string2int :: String -> Integer
string2int a = read a :: Integer

map' :: Foldable t1 => (t2 -> a) -> t1 t2 -> [a]
map' f = foldr (\x acc -> f x:acc) []

filter' :: Foldable t => (a -> Bool) -> t a -> [a]
filter' f = foldr (\x acc -> if (f x) then x:acc else acc) []

string2word = sum.map converToNumber.map words.splitOn ", "

converToNumber x = (hundred*100 + others)*orders
    where hundred = if "hundred" `elem` x then head.map convertToNumberPos.takeWhile (/="hundred").filter (/="and")$x else 0
          others  = if "hundred" `elem` x then sum.map convertToNumberPos.dropWhile (/="hundred").filter (/="and")$x else sum.map convertToNumberPos$x
          orders  = orderString.last$x

convertToNumberPos x
    | x == "zero"        = 0
    | x == "one"        = 1
    | x == "two"        = 2
    | x == "three"      = 3
    | x == "four"       = 4
    | x == "five"       = 5
    | x == "six"        = 6
    | x == "seven"      = 7
    | x == "eight"      = 8
    | x == "nine"       = 9
    | x == "ten"        = 10
    | x == "eleven"     = 11
    | x == "twelve"     = 12
    | x == "thirteen"   = 13
    | x == "fourteen"   = 14
    | x == "fifteen"    = 15
    | x == "sixteen"    = 16
    | x == "seventeen"  = 17
    | x == "eighteen"   = 18
    | x == "nineteen"   = 19
    | x == "twenty"     = 20
    | x == "thirty"     = 30
    | x == "forty"      = 40
    | x == "fifty"      = 50
    | x == "sixty"      = 60
    | x == "seventy"    = 70
    | x == "eighty"     = 80
    | x == "ninety"     = 90
    | otherwise          = 0

orderString x 
    | x == "thousand"    = 1000
    | x == "million"     = 1000000
    | x == "billion"     = 1000000000
    | x == "trillion"    = 1000000000000
    | x == "quadrillion" = 1000000000000000
    | x == "quintillion" = 1000000000000000000
    | x == "sextillion"  = 1000000000000000000000
    | x == "septillion"  = 1000000000000000000000000
    | x == "octillion"   = 1000000000000000000000000000
    | x == "nonillion"   = 1000000000000000000000000000000
    | x == "decillion"   = 1000000000000000000000000000000000
    | otherwise          = 1

word2string x 
    | x == 0 = "zero"
    | otherwise = reverse.dropWhile (\x -> (x == ' ' || x == ',')).unwords.dropWhile (== "dna").words.reverse.word2stringSolve 0$x

word2stringSolve _ 0 = []
word2stringSolve n x 
    | n == 1 && ((x `mod` 1000) /= 0)  = next ++ (word2stringHundred.mod x$1000) ++ (order n) ++ "and " 
    | x `mod` 1000 == 0 =  next ++ (filter (/=',').word2stringHundred.mod x$1000)
    | otherwise = next ++ (word2stringHundred.mod x$1000) ++ (order n) 
    where next = (word2stringSolve (n+1).quot x$1000)

order n
    | n == 0 = []
    | n == 1 = "thousand, "
    | n == 2 = "million, "
    | n == 3 = "billion, "
    | n == 4 = "trillion, "
    | n == 5 = "quadrillion, "
    | n == 6 = "quintillion, "
    | n == 7 = "sextillion, "
    | n == 8 = "septillion, "
    | n == 9 = "octillion, "
    | n == 10 = "nonillion, "
    | n == 11 = "decillion, "
    | otherwise = "Outside Our Range... "


word2stringHundred x 
    | tens == 0 && ones == 0 && hundreds == 0 = []
    | tens == 0 && ones == 0 = (unwords.filter (/="and").words) hundred ++ " "
    | tens  == 1 = hundred ++ teens1 (x `mod` 100)
    | otherwise = hundred ++ (teens tens) ++ (onees ones)
    where hundred 
                | hundreds == 0 = [] 
                | otherwise = (onees.quot x$100) ++ "hundred and "
          tens = quot (x `mod` 100) 10
          ones = x `mod` 10 
          hundreds = quot x 100

onees x
    | x == 0 = []
    | x == 1 = "one "
    | x == 2 = "two "
    | x == 3 = "three "
    | x == 4 = "four "
    | x == 5 = "five "
    | x == 6 = "six "
    | x == 7 = "seven "
    | x == 8 = "eight "
    | x == 9 = "nine "

teens x
    | x == 0 = []
    | x == 2 = "twenty "
    | x == 3 = "thirty "
    | x == 4 = "forty "
    | x == 5 = "fifty "
    | x == 6 = "sixty "
    | x == 7 = "seventy "
    | x == 8 = "eighty "
    | x == 9 = "ninety "

teens1 x
    | x == 10 = "ten "
    | x == 11 = "eleven "
    | x == 12 = "twelve "
    | x == 13 = "thirteen "
    | x == 14 = "fourteen "
    | x == 15 = "fifteen "
    | x == 16 = "sixteen "
    | x == 17 = "seventeen "
    | x == 18 = "eighteen "
    | x == 19 = "nineteen "
