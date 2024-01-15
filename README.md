# Neural Network in Haskell

A simple neural network library in Haskell. The project aims to be of use to newcomers to Haskell, and an exploratory tool for neural networks. The entirety of this learning library is written from scratch, and hence may not be the best choice for efficiency.

## Prerequisites

- Installation of GHCI is required. Instructions to install using GHCup (recommended) are available [here](https://www.haskell.org/ghcup/) (version - 9.4.7)

## Usage
The [`Main.hs`](./Main.hs) file provides two interfaces to the Neural Network's operations: `train_model` and `predict_values`.

Execute `Main.hs` in the terminal. 

To train a model,
- Set hyperparameters in Params.hs. 
    **Note**: Currently, a single activation is applied throughout the network.
- Execute `:reload` to update the compiled source (alternatively, `:load Main.hs` if compiling for the first time)
- Set the training features & their corresponding outputs in variables (here, `xs` and `ys`)
- Provide randomised weights corresponding to the network structure. For each layer of *n* inputs and *m* outputs, the corresponding weights must be a list of *m* lists, each of length *n + 1*. 
    **Note**: Currently, the feature inputs are implicitly considered to be an input layer with no activation.
- Use function `train_model` to obtain the new weights of your network, providing the number of epochs required.

Predicting values is straightforward; `predict_values` uses the network's learnt weights to predict outputs for given data points.

### Sample execution:
```
> ghci Main.hs
ghci> w = [ [[0.3, 0.4], [0.9, 0.6], [5, 0.3], [2, 1], [0.001, 0.5]], [[0.6, 0.5, 0.6, 0.3, 0.8, 0.9]]] -- a 1x5x1 network
ghci> xs = [[1], [2], [3], [4], [9], [8], [5], [3], [1], [0], [9], [8]]                              
ghci> ys = map (map (\x -> 5*x)) xs                                                                  
ghci> w2 = train_model w xs ys 50                                                                    
ghci> predict_values w2 xs                                                                           
[[4.9379373],[9.953882],[14.969826],[19.985771],[45.065495],[40.049545],[25.001715],[14.969826],[4.9379373],[0.17317355],[45.065495],[40.049545]]
```

for [`Params.hs`](./Params.hs):
```
activation :: Activation
activation = relu

activation' :: Activation_Prime
activation' = relu_prime

error_prime :: Y -> Y -> [Float]
error_prime = mse_prime

learning_rate :: Float
learning_rate = 0.001
```