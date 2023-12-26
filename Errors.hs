module Errors (mse, mse_prime) where

import Tools (pow_2)

type Y = [Float]

mse :: Y -> Y -> Float
mse outputs tgt = (sum $ map pow_2 $ zipWith (-) outputs tgt) / (fromIntegral (length outputs))

mse_prime :: Y -> Y -> [Float]
mse_prime outputs tgt = zipWith (\x y -> (2 * (y - x) / (fromIntegral (length outputs)))) outputs tgt