import Neural_Net (epoch_learn, network_predict)
import Params (epochs)
import Types (Weights, X, Y)

train_model :: Weights -> [X] -> [Y] -> Float -> Weights
train_model weights xs ys 0 = weights
train_model weights xs ys epoch_no = train_model new_weights xs ys (epoch_no - 1)
                    where new_weights = epoch_learn weights xs ys

predict_values :: Weights -> [X] -> [Y]
predict_values w xs = map (network_predict w) xs