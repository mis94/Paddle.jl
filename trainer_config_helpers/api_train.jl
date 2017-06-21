include("../trainer/config_parser.jl")
include("data_sources.jl")
include("optimizers.jl")
include("layers.jl")
include("activations.jl")
include("networks.jl")
using JSON


trainer_config = parse_config("../trainer_config_helpers/trainer_config.lr.jl", "dict_file=../trainer_config_helpers/data/dict.txt")
print(trainer_config.model_config)
trainer_config.model_config.layers[1].shared_biases = true
print(globals.has_field(trainer_config.model_config.layers[1], :shared_biases))
