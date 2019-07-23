import System.IO  
import Data.List.Split  
import Data.List

main = do  
    x <- readFile "newCipher.txt"  
    y <- readFile "dictionary.txt"
    -- let a=splitOn " " x
    let a = remempty (splitOn " " (rem' x))
    let b=splitOn "\n" y
    -- let list=[]
    let list= del (reverse (sort (freq (sort x))))
    let mapped_list=[]

    let mapped_list = [(snd(head(list)),'e')]
    let new = [ f' q | q<-a , (length q) == 1 ]

            -- where 
    let mapped_list1 = (mapped_list ++ (new))


    print (group(sort new))
    -- print(mapped_list1)
    -- putStr(map' mapped_list x)
    putStr ""  

f' q 
    | head(q) `elem` ['A'..'Z'] = (head(q),'I')
    | head(q) `elem` ['a'..'z'] = (head(q),'a')

map' mapped_list [] = []
map' mapped_list (x:xs) = (map1 mapped_list x) : map' mapped_list xs   

map1 [] x = x
map1 (a:as) x = if(fst(a)==x) then snd(a) else map1 as x

freq [] = []
freq [z] = [(1,z)]
freq (z:zs)
    | z/=(head zs) = (1,z) : rest
    | otherwise = new : tail rest
    where new = ((fst(head rest)+1),snd(head rest)) 
          rest = freq zs

del [] = []
del (z:zs)
    | f (snd(z)) = del zs
    | otherwise = z : del zs

f z
    | z `elem` ['A'..'Z'] || z `elem` ['a'..'z'] = False
    | otherwise = True

rem' [] = []
rem' (z:zs)
    | z=='\n' = ' ' : rem' zs
    | otherwise = z : (rem' zs)

g z
    | z `elem` ['A'..'Z'] || z `elem` ['a'..'z'] || z == ' ' || z== '\'' = False
    | otherwise = True

remempty [] = []
remempty (z:zs)
    | z=="" = remempty zs
    | otherwise = z : remempty zs