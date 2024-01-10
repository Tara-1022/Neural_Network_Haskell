module Tools (clip, or_else, get_indices, dot_product, transpose, weights_only, prepend, pow_2, multiply_each) where

or_else :: Bool
or_else = True

get_indices :: [a] -> [Int]
get_indices list = [0..( (length list) - 1)]

dot_product :: [Float] -> [Float] -> Float
dot_product xs ys = foldr (+) 0 $ zipWith (*) xs ys

transpose :: [[Float]] -> [[Float]]
transpose ([]:_) = []
transpose x = (map head x) : transpose (map tail x)

weights_only :: [[Float]] -> [[Float]]
weights_only weights = [ws | w:ws <- weights]

prepend :: [Float] -> [[Float]] -> [[Float]]
prepend x y = zipWith (\a b -> a:b) x y

pow_2 :: Float -> Float
pow_2 x = x ^ 2

multiply_each :: [[Float]] -> Float -> [[Float]]
multiply_each list val = [map ((*) val) x | x <- list]

-- TODO: Verify clipping necessary
clip :: Float -> Float
clip x  | x <= 1.0e-7 = 1.0e-7 
        | x >= 1.0e7 = 1.0e7
        | or_else = x