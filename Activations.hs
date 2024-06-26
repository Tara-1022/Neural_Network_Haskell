module Activations (relu, relu_prime, sigmoid, step, tanh_prime, none, leaky_relu, leaky_relu_prime) where

import Tools (or_else)
import Types (Activation, Activation_Prime)

leaky_relu :: Activation
leaky_relu x = max x $ 0.01 * x

leaky_relu_prime :: Activation_Prime
leaky_relu_prime x | x < 0      = 0.01
                   | or_else    = 1

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