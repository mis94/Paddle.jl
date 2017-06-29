#include("../trainer/config_parser.jl")
#include("data_sources.jl")
#include("optimizers.jl")
#include("layers.jl")
#include("activations.jl")
#include("networks.jl")

#This file should be implemented and we can test the API by running it

dict_file = get_config_arg("dict_file", String, "./data/dict.txt")
word_dict = Dict()
open(dict_file) do f
  idx = 0
  for line in eachline(f)
    stripped = strip(line)
    splitted = split(stripped)
    word_dict[splitted[1]] = idx
    idx = idx + 1
  end
end

is_predict = get_config_arg("is_predict", Bool, false)

trn = nothing
tst = nothing
process = nothing
if !is_predict
  trn = "data/train.list"
end

if !is_predict || is_predict == nothing
  tst = "data/test.list"
else
  tst = "process_predict"
end

if !is_predict
  process = "process"
else
  process = "process_predict"
end

define_py_data_sources2(
    trn,
    tst,
    "dataprovider_bow",
    process,
    Dict("dictionary"=>word_dict))

batch_size = nothing

if !is_predict
  batch_size = 128
else
  batch_size = 1
end
#println(batch_size)
settings_f(
    batch_size,
    learning_rate=2e-3,
    learning_method=AdamOptimizer(),
    regularization=L2Regularization(8e-4),
    gradient_clipping_threshold=25)


data = data_layer("word", length(word_dict))

output = fc_layer(data, 2, act=SoftmaxActivation())

if !is_predict

  label = data_layer("label", 2)

  cls = classification_cost(output, label)

  outputs(cls)
else
  maxid = maxid_layer(output)
  outputs([maxid, output])

end
