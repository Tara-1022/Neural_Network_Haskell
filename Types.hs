module Types (Neuron_Weight, Layer_Weight, Weights, X, Y, Activation, Activation_Prime) where

type Neuron_Weight = [Float]
type Layer_Weight = [Neuron_Weight]
type Weights = [Layer_Weight]
type X = [Float]
type Y = [Float]

type Activation         = Float -> Float
type Activation_Prime   = Float -> Float