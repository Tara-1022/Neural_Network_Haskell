import Neural_Net (epoch_learn, network_predict, Weights, X, Y)

epochs :: Int
epochs = 500

train_model :: Weights -> [X] -> [Y] -> Float -> Weights
train_model weights xs ys 0 = weights
train_model weights xs ys epoch_no = train_model new_weights xs ys (epoch_no - 1)
                    where new_weights = epoch_learn weights xs ys