
and' a b 
    | a == 1 && b == 1 = 1
    | otherwise = 0

or' a b
    | a == 0 && b == 0 = 0
    | otherwise = 1

xor' a b
    | a == 0 && b == 1 = 1
    | a == 1 && b == 0 = 1
    | otherwise = 0

char2int a 
    | a == '0' = 0
    | a == '1' = 1

int2char a
    | a == 0 = '0'
    | a == 1 = '1'

addersolve [] [] carry = []
addersolve (x:xs) [] carry = ans: addersolve xs [] newcarry
    where a = char2int x
          b = 0
          c = char2int carry
          anstemp = xor' (xor' a b) c
          carrytemp   = or' (or' (and' a b) (and' a c))  (and' b c)
          ans = int2char anstemp
          newcarry = int2char carrytemp 
addersolve [] (y:ys) carry = ans: addersolve [] ys newcarry
    where a = 0
          b = char2int y
          c = char2int carry
          anstemp = xor' (xor' a b) c
          carrytemp   = or' (or' (and' a b) (and' a c))  (and' b c)
          ans = int2char anstemp
          newcarry = int2char carrytemp 
addersolve (x:xs) (y:ys) carry = ans: addersolve xs ys newcarry
    where a = char2int x 
          b = char2int y 
          c = char2int carry
          anstemp = xor' (xor' a b) c
          carrytemp   = or' (or' (and' a b) (and' a c))  (and' b c)
          ans = int2char anstemp
          newcarry = int2char carrytemp

adder a b = reverse (addersolve (reverse a) (reverse b) '0')

shiftright a = (head a):(init a)

shiftright2 a c = c:(init a)
negateNumber a = adder "1".flip'$a

flip' [] = []
flip' (x:xs)
     | x == '0' = '1':flip' xs
     | x == '1' = '0':flip' xs
     
solve _ _ _ 0 _ = []
solve aC mR qn1 n mD
    | (last mR == '1') && qn1 == '0' = (aC1 ++ mR1 ++ " " ++ mR1 ++ " " ++ mD): solve aC1 mR1 qn2 (n-1) mD
    | (last mR == '0') && qn1 == '1' = (aC2 ++ mR2 ++ " " ++ mR2 ++ " " ++ mD): solve aC2 mR2 qn2 (n-1) mD 
    | otherwise = (aC3 ++ mR3 ++ " " ++ mR3 ++ " " ++ mD): solve aC3 mR3 qn2 (n-1) mD
    where  aC1 = shiftright (adder aC (negateNumber mD))
           temp1 = adder aC (negateNumber mD)
           mR1 = shiftright2 mR (last temp1)
           aC2 = shiftright (adder aC mD)
           temp2 = adder aC mD
           mR2 = shiftright2 mR (last temp2)
           aC3 = shiftright aC
           mR3 = shiftright2 mR (last aC)
           qn2 = last mR
           
main = do
    putStrLn "Enter the number of bits"
    n <- getLine
    putStrLn "Enter the two numbers"
    a <- getLine
    b <- getLine
    let num = read n :: Int
    let ans = take num (repeat '0')
    let finalans = ("Product Multiplier Multiplicand"):solve ans b '0' num a
    mapM_ putStrLn finalans

    putStrLn ""
