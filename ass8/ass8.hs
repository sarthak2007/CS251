insertAt ::  a -> [a] -> Int -> [a]
insertAt a list pos = take (pos-1) list ++ [a] ++ drop (pos-1) list


incrrange :: (Num a)=> [a]->(Int,Int)->[a] 
incrrange x (a,b) = take (a-1) x ++ (map (+1).drop (a-1).take b$x) ++ drop b x

combinations n [] = [[]]
combinations 0 x = [[]]
combinations n (x:xs) 
    | len < n = map (x:).combinations (n-1)$xs
    | otherwise = (map (x:) (combinations (n-1) xs)) ++ (combinations n xs)
    where len = length xs 
