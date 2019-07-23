import System.IO
import Data.List
import Data.Function
import Data.List.Split

main = do
    cipher <- readFile "newCipher.txt"
    dict <- readFile "dictionary.txt"
    
    -- let cipher_words = sortBy(compare `on` length).concat.map words.lines$cipher
    let cipher_words = filter specialCharCheck (remempty (splitOn " " (rem' cipher)))
    let dict_words = lines$dict

    let official_freq_order = ['e','a','o','i','d','h','n','r','s','t','u','y','c','f','g','l','m','w','b','k','p','q','x','z']

    
    let cipher_char_freq = freq.concat$cipher_words
    let dict_freq = freq.concat$dict_words
    let cipher_word_frequency = freq cipher_words

    -- Update Cipher based on the assumption that e occurs most in english
    -- dictionary
    
    let mapping1 = [(fst.head$(cipher_char_freq),'e')]
    
    -- Updating Cipher with mapping of a,A,I
    let singleWords = freq.words_with_length cipher_words$1                                                         
    let mapping2 = updateaAI singleWords mapping1

    let tripleWords = map fst.freq.words_with_length cipher_words$3
    -- let mapping2 = updateThe tripleWords "the" mapping3 mapping1

    -- Heuristic 2: 
    let mapping_Heuristic2 = heuristic2 mapping2 cipher_words dict_words mapping2

    -- Heuristic 1: freq to freq mapping
    let mapping_Heuristic1 =  heuristic1 mapping2 cipher_char_freq official_freq_order
    
    
    -- let curr_words = extractWords 'd' 'e' cipher_words
    -- let mappingupdate = maptodict curr_words dict_words [] mapping2
    -- let mappp = mappingfix mappingupdate mapping2
    -- let mapp = mapping2 ++ mappp
    -- print mapp

    -- print mapping_Heuristic2


    -- let new_cipher = updateCipher mapping_Heuristic2 cipher_words
    let decoded_cipher = updateCipher mapping_Heuristic2 cipher
    -- print (mylookup new_cipher dict_words)
    putStr decoded_cipher
    putStr ""

specialCharCheck [] = True
specialCharCheck (x:xs)
    | x `elem` ['a'..'z'] || x `elem` ['A'..'Z'] = specialCharCheck xs
    | otherwise = False


-- Heuristic 2

heuristic2 [] _ _ mapp = mapp 
heuristic2 (a:mapp_rec) cipher_words dict_words imp_mapp = heuristic2 (mapp_rec ++ mappingupdate) cipher_words dict_words (imp_mapp ++ mappingupdate) 
    where curr_words = extractWords (fst a) (snd a) cipher_words
          mappingup = maptodict curr_words dict_words [] imp_mapp
          mappingupdate = mappingfix mappingup imp_mapp

mappingfix [] mapp = []
mappingfix (a:new) mapp 
    | (fst a) `elem` (map fst mapp) = mappingfix new mapp
    -- | (snd a) `elem` (map snd mapp) = mappingfix new mapp
    | otherwise = a:mappingfix new (a:mapp)

maptodict [] _ mapp imp_mapp = mapp
maptodict ((a,b,c):curr_words) dict_words mapp imp_mapp = maptodict curr_words dict_words (mapp ++ mappingupdate) (imp_mapp ++ mappingupdate)
    where mappingup = maptodictword (a,b,c) dict_words [] imp_mapp
          mappingupdate = mappingfix mappingup imp_mapp

maptodictword (a,b,c) dict_words mapp imp_mapp
    | len == 1 = mapp ++ (updateMappingNow a (head val) [] b)
    | otherwise = mapp
    where 
          val = allwords dict_words (a,b,c) imp_mapp
          len = length val



allwords [] _ _ = []
allwords (x:dict_words) (a,b,c) imp_mapp
    | (length x) /= (length a) = allwords dict_words (a,b,c) imp_mapp
    | checker x a imp_mapp = x:allwords dict_words (a,b,c) imp_mapp
    | otherwise = allwords dict_words (a,b,c) imp_mapp

checker dict my imp_mapp = all (\(a,b)->check dict my a b) imp_mapp

check [] _ _  _ = True
check (x:xs) (y:ys) b c
    | (x == c) && (y /= b) = False
    | (x /= c) && (y == b) = False
    | otherwise = check xs ys b c

updateMappingNow [] _ mapp _ = mapp
updateMappingNow _ [] mapp _ = mapp
updateMappingNow (x:xs) (y:ys) mapp b
    | x == b = updateMappingNow xs ys mapp b
    | otherwise = updateMappingNow xs ys (updateMapping mapp x y) b



updateMapping mapp a b
    | a `elem` (map fst mapp) = mapp
    | b `elem` (map snd mapp) = mapp
    | otherwise = mapp ++ [(a,b)]

extractWords a b words = [(x, a, b) | x<-words, a `elem` x]

-- findInd a [] _ = -1
-- findInd a (x:xs) pos
--     | a == x = pos
--     | otherwise = findInd a xs (pos+1)









-- To update the cipher finally based on the mapping generated

-- finalAnswer mapp (x:cipher)
    -- | 


-- To calculate the frequency of the words or characters
freq x = reverse.sortBy ((compare) `on` (snd)).map (\x -> (head x,length x)).group.sort$x

-- This will look and tell me the words that mapped correctly to dictionary words
mylookup decoded dict = [x | x<-decoded, x `elem` dict]
                    
-- This updates the cipher_words based on the mapping
updateCipher _ [] = []
updateCipher mapping (x:cipher) 
    | x `elem` (map fst mapping) = (findMap x mapping):updateCipher mapping cipher
    | otherwise = x:updateCipher mapping cipher

findMap x (a:mapp)
    | fst a == x = snd a
    | otherwise = findMap x mapp



-- This returns subet of the list of words with words of the given length
words_with_length x a = [b | b<-x, (length b) == a]

-- This updates my mapping with mapping of a,I,A
updateaAI singlewords mapp 
    | length singlewords == 1 = mapp ++ ((head.fst) (singlewords !! 0),'a'):[]
    | length singlewords >= 2 = mapp ++ ((head.fst) (singlewords !! 0),'a'):((head.fst) (singlewords !! 1),'I'):[] 
    -- | length singlewords == 3 = mapp ++ ((head.fst) (singlewords !! 0),'a'):((head.fst) (singlewords !! 1),'I'):((head.fst) (singlewords !! 2),'A'):[]
    | otherwise = mapp

updateThe tripleWords value mapp mapping = updatenewthe val value mapp
    where val = head [ x | x<-tripleWords, x!!2 == (fst.head$mapping)]

updatenewthe [] _ mapp = mapp
updatenewthe (x:xs) (y:value) mapp
   | x `elem` (map fst mapp) = updatenewthe xs value mapp
   | otherwise = updatenewthe xs value (mapp ++ [(x,y)])

-- This is my heuristic1 which is based on the official order of frequency order of letters
heuristic1 mapp [] _ = mapp
heuristic1 mapp _ [] = mapp
heuristic1 mapp (a:cipher) (b:dict)
    | (fst a) `elem` (map fst mapp) = heuristic1 mapp cipher (b:dict)
    | b `elem` (map snd mapp) = heuristic1 mapp (a:cipher) dict
    | otherwise = heuristic1 ((fst a,b):mapp) cipher dict

rem' [] = []
rem' (z:zs)
    | z=='\n' = ' ' : rem' zs
    | otherwise = z : (rem' zs)

remempty [] = []
remempty (z:zs)
    | z=="" = remempty zs
    | otherwise = z : remempty zs



----
----
----


maptodict' [] _ mapp _ = []
maptodict' ((a,b,c):curr_words) dict_words mapp imp_mapp = mappingupdate ++ maptodict' curr_words dict_words mapp imp_mapp
    where mappingupdate = maptodictword' (a,b,c) dict_words [] imp_mapp

maptodictword' (a,b,c) dict_words mapp imp_mapp
    | len == 1 = [(a,head val)]
    | otherwise = []
    where 
          val = allwords dict_words (a,b,c) imp_mapp
          len = length val

----
----
----
