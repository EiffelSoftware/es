module UnicodeLetter (main) where
import qualified Data.Char as Char
 
{-| Print source code. -}
main :: IO ()
main = putStrLn generateCode
 
{-| Generate source code for Eiffel once routine creating array for efficient search. -}
generateCode :: String
generateCode
  = unlines $ prefix ++
      (map makeEntry $ zip letterIntervalsOrdered [1 ..])
      ++ suffix
  where prefix
          = ["\tLetter_intervals_ordered: ARRAY [TUPLE [base: INTEGER; length: INTEGER]]",
             "\t\tonce",
             "\t\t\tcreate Result.make_filled ([0, 0], 1, " ++
               show (length letterIntervalsOrdered)
               ++ ")"]
        makeEntry ((base, length), index)
          = "\t\t\tResult [" ++ show index ++ "] := [" ++ show base ++ ", "
              ++ show length
              ++ "]"
        suffix = ["\t\tend"]
 
{-| Intervals with major general category letter. -}
letterIntervalsOrdered :: [(Int, Int)]
letterIntervalsOrdered = characterIntervalsOrdered Char.isLetter
 
{-| Sorted Unicode code point intervals of characters satisfying predicate. -}
characterIntervalsOrdered :: (Char -> Bool) -> [(Int, Int)]
characterIntervalsOrdered select = foldr grow [] codePoints
  where grow code [] = [(code, 1)]
        grow code intervals@((base, length) : completed)
          = if code + 1 == base then (code, length + 1) : completed else
              (code, 1) : intervals
        codePoints = map Char.ord lettersOrdered
        lettersOrdered = filter select ([minBound .. maxBound] :: [Char])

