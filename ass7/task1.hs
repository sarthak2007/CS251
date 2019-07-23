-- Recursion to Calculate all fibonacci numbers upto n
fibtemp :: Int -> [Integer]
fibtemp n 
    | n==0 = [0] 
    | n==1 = [0,1] 
    | otherwise = a ++ [((a!!(n-1)) + (a!!(n-2)))]
    where
        a=fibtemp(n-1) 

-- To output nth fibonacci number using fibtemp
fib :: Int -> Integer
fib n = last (fibtemp n)

-- Printing all fibonacci numbers
fibinf :: [Integer]
fibinf = [fib n | n<-[0..] ]

-- To check if the number is prime
ifprime :: Integer -> Bool
ifprime x
    | (temp == x) = True
    | otherwise = False
   where temp = head [y | y<-[2..x], x `mod` y == 0]
   
-- Printing the nth fibonacci from the infinite list
-- And since haskell is a lazy language after finding any nth
-- Your infinite list will be already filled upto n so (n+1)th 
-- would be calculated immediately
prime :: Int -> Integer
prime n = last (take n primeInf)

-- Printing infinite prime numbers
primeInf :: [Integer]
primeInf = [x | x<-[2..], ifprime x]
