

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
         
check [] n1 n2 
    | n1 == n2 = True
    | otherwise = False
check (x:xs) n1 n2 
    | x == '0' = check xs (n1+1) n2
    | x == '1' = check xs n1 (n2+1)
adder a b 
     | (check a 0 0) || (check b 0 0) = Nothing
     | otherwise = Just (reverse (addersolve (reverse a) (reverse b) '0'))

shiftright a = (head a):(init a)

shiftright2 a c = c:(init a)
negateNumber a = adder "1".flip'$a

flip' [] = []
flip' (x:xs)
     | x == '0' = '1':flip' xs
     | x == '1' = '0':flip' xs
     
solve _ _ _ 0 _ = []
solve aC mR qn1 n mD
    | (last mR == '1') && qn1 == '0' = if aC1 == "dead" then "bug":[] else (aC1 ++ mR1 ++ " " ++ mR1 ++ " " ++ mD): solve aC1 mR1 qn2 (n-1) mD
    | (last mR == '0') && qn1 == '1' = if aC2 == "dead" then "bug":[] else (aC2 ++ mR2 ++ " " ++ mR2 ++ " " ++ mD): solve aC2 mR2 qn2 (n-1) mD 
    | otherwise = (aC3 ++ mR3 ++ " " ++ mR3 ++ " " ++ mD): solve aC3 mR3 qn2 (n-1) mD
    where                   
           temp = (negateNumber mD)  
           temp1 = case temp of Just x -> adder aC x
                                Nothing -> Nothing
           aC1 = case temp1 of Just x -> (shiftright x)
                               Nothing -> "dead"
           mR1 = case temp1 of Just x -> shiftright2 mR (last x)
                               Nothing -> "dead"
           temp2 = adder aC mD
           aC2 = case temp2 of Just x -> (shiftright x)
                               Nothing -> "dead"
           mR2 = case temp2 of Just x -> shiftright2 mR (last x)
                               Nothing -> "dead"  
           aC3 = shiftright aC
           mR3 = shiftright2 mR (last aC)
           qn2 = last mR
           
main = do
    putStrLn "Enter the number of bits in your input"
    n <- getLine
    putStrLn "Enter the 2 numbers in binary"
    a <- getLine
    b <- getLine
    putStrLn "Simulation Begins.....\n\n"
    let num = read n :: Int
    let ans = take num (repeat '0')
    let finalans = ("Product Multiplier Multiplicand"):solve ans b '0' num a
    if (last finalans == "bug") then 
        do
        putStrLn "Fault Incurred! Please Enter another input\n\n"
        main
    else
        mapM_ putStrLn finalans

    putStrLn ""
