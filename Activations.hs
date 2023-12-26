module Activations (Activation, Activation_Prime, relu, relu_prime, sigmoid, step, tanh_prime, none) where

import Tools (or_else)

type Activation         = Float -> Float
type Activation_Prime   = Float -> Float

relu :: Activation
relu x  | x > 0 = x
        | or_else = 0

relu_prime :: Activation_Prime
relu_prime x    | x > 0         = 1
                | or_else       = 0
    
sigmoid :: Activation
sigmoid x = 1 / (1 + (exp $ -x))

step :: Activation
step x  | x >= 0 = 1
        | or_else = 0

none :: Activation
none x = x

-- Hyperbolic tangent - tanh
tanh_prime :: Activation_Prime
tanh_prime x = 1 - (tanh x) ^ 2