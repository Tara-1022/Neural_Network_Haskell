module Params (activation, activation', error_prime, learning_rate, epochs) where

import Activations (relu, relu_prime, sigmoid, step, tanh_prime, none)
import Errors (mse, mse_prime)
import Types (X, Y, Activation, Activation_Prime)

activation :: Activation
activation = relu

activation' :: Activation_Prime
activation' = relu_prime

error_prime :: Y -> Y -> [Float]
error_prime = mse_prime

learning_rate :: Float
learning_rate = 0.001