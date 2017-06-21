include("../trainer/config_parser.jl")
include("data_sources.jl")
include("optimizers.jl")
include("layers.jl")
include("activations.jl")
include("networks.jl")
using JSON


trainer_config = parse_config("../trainer_config_helpers/trainer_config.lr.jl", "dict_file=../trainer_config_helpers/data/dict.txt")

println("*****************************************************")

#println(trainer_config.model_config) # OK Passed
#println(trainer_config.opt_config) # OK Passed
#println(trainer_config.config_files) # an empty array not set
#println(trainer_config.save_dir) # OK Passed
#println(trainer_config.init_model_path) #an empty string not set
#println(trainer_config.start_pass) # OK Passed
#println(trainer_config.config_file) # an empty string not set

println("*****************************************************")