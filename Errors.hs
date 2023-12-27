module Errors (mse, mse_prime) where

import Tools (pow_2)

type Y = [Float]

mse :: Y -> Y -> Float
mse outputs tgt = (sum $ map pow_2 $ zipWith (-) outputs tgt) / (fromIntegral (length outputs))

mse_prime :: Y -> Y -> [Float]
mse_prime y_test y_pred = zipWith (\x y -> (2 * (x - y) / (fromIntegral (length y_test)))) y_pred y_test