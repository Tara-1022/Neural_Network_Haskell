module Neural_Net (epoch_learn, network_predict, Weights, X, Y) where
import Tools (or_else, get_indices, dot_product, transpose, weights_only, prepend, multiply_each)
import Activations (Activation, Activation_Prime, tanh_prime, none)
import Errors (mse, mse_prime)

type Neuron_Weight = [Float]
type Layer_Weight = [Neuron_Weight]
type Weights = [Layer_Weight]
type X = [Float]
type Y = [Float]

activation :: Activation
activation = tanh

activation' :: Activation_Prime
activation' = tanh_prime

error_prime :: Y -> Y -> [Float]
error_prime = mse_prime

learning_rate :: Float
learning_rate = 0.1

epoch_learn :: Weights -> [X] -> [Y] -> Weights
epoch_learn weights [] [] = weights
epoch_learn weights (x: xs) (y: ys) = epoch_learn (updated_weights weights x y) xs ys

updated_weights :: Weights -> X -> Y -> Weights
updated_weights weights x y_test = reverse [updated_layer_weight (layerwise_inputs !! i) ((reverse weights) !! i) (partial_gradients !! i) | i <- get_indices weights]
                            where 
                                _:partial_gradients = network_backward weights layerwise_inputs [output_gradient]
                                output_gradient = mse_prime y_pred y_test
                                y_pred:layerwise_inputs = network_forward weights [x]

updated_layer_weight :: X -> Layer_Weight -> [Float] -> Layer_Weight
updated_layer_weight x layer_weight output_gradient = zipWith (zipWith (-)) layer_weight (multiply_each updations learning_rate)
                                                        where
                                                            weights_gradient = [map ((*) grad_val) x | grad_val <- output_gradient]
                                                            bias_gradient = output_gradient
                                                            updations = prepend bias_gradient weights_gradient

-- return network's partial gradients, output layer first
network_backward :: Weights -> [X] -> [[Float]] -> [[Float]]
network_backward [] xs gradients = gradients
network_backward weights (x:xs) gradients = network_backward (init weights) xs (prev_gradient:gradients)
                                        where
                                            prev_gradient = prev_output_gradient x (last weights) (head gradients)

prev_output_gradient :: X -> Layer_Weight -> [Float] -> [Float]
prev_output_gradient x layer_weight output_gradient = map (dot_product new_output_gradient) (transpose $ weights_only layer_weight)
                                                        where new_output_gradient = activation_back x output_gradient

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