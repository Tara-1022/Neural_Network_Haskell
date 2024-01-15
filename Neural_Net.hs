module Neural_Net (epoch_learn, network_predict, Weights, X, Y) where

import Activations (tanh_prime, none)
import Errors (mse, mse_prime)
import Params (activation, activation', error_prime, learning_rate)
import Tools (clip, or_else, get_indices, dot_product, transpose, weights_only, bias_only, prepend, multiply_each)
import Types (Neuron_Weight, Layer_Weight, Weights, X, Y, Activation, Activation_Prime)

epoch_learn :: Weights -> [X] -> [Y] -> Weights
epoch_learn weights [] [] = weights
epoch_learn weights (x: xs) (y: ys) = epoch_learn (update_weights weights x y) xs ys

update_weights :: Weights -> X -> Y -> Weights
update_weights weights x y_test = network_backward weights layerwise_inputs output_gradient []
                            where
                                output_gradient = error_prime y_test y_pred
                                y_pred:layerwise_inputs = network_forward weights [x]

-- return network's new weights
network_backward :: Weights -> [X] -> [Float] -> Weights -> Weights
network_backward [] xs past_gradient new_weights = new_weights
network_backward weights (x:xs) past_gradient new_weights = network_backward (init weights) xs next_gradient (w_new:new_weights)
                                        where
                                            next_gradient = dense_back x w gradient
                                            w_new = updated_layer_weight x w gradient
                                            gradient = (activation_back (dense_forward w x) past_gradient)
                                            w = last weights

updated_layer_weight :: X -> Layer_Weight -> [Float] -> Layer_Weight
updated_layer_weight x layer_weight output_gradient = zipWith (zipWith (-)) layer_weight (multiply_each updations learning_rate)
                                                        where
                                                            weights_gradient = [map ((*) grad_val) x | grad_val <- output_gradient]
                                                            bias_gradient = output_gradient
                                                            updations = prepend bias_gradient weights_gradient

dense_back :: X -> Layer_Weight -> [Float] -> [Float]
dense_back x layer_weight output_gradient = map (dot_product output_gradient) (transpose $ weights_only layer_weight)


activation_back :: X -> [Float] -> [Float]
activation_back x output_gradient = zipWith (*) output_gradient $ map activation' x

-- return network's partial outputs, most recent first
network_forward :: Weights -> [X] -> [Y]
network_forward [] xs = xs
network_forward (layer_weight:weights) (x:xs) = network_forward weights $ (layer_output layer_weight x):x:xs

network_predict :: Weights -> X -> Y
network_predict [] x = x
network_predict (layer_weight:weights) x = network_predict weights $ layer_output layer_weight x

layer_output :: Layer_Weight -> X -> Y 
layer_output layer_weight x = [neuron_output neuron_weight x | neuron_weight <- layer_weight]

neuron_output :: Neuron_Weight -> X -> Float
neuron_output (bias:ws) xs  = activation $ (dot_product ws xs) + bias

dense_forward :: Layer_Weight -> X -> Y
dense_forward layer_weight x = [single_output neuron_weight x | neuron_weight <- layer_weight]
                        where
                            single_output (bias:ws) xs = (dot_product ws xs + bias)