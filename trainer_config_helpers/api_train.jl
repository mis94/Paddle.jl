include("../trainer/config_parser.jl")
include("data_sources.jl")
include("optimizers.jl")
include("layers.jl")
include("activations.jl")
include("networks.jl")
using JSON
using PyCall
@pyimport py_paddle.swig_paddle as api


#trainer_config = parse_config("../trainer_config_helpers/trainer_config.lr.jl", "dict_file=../trainer_config_helpers/data/dict.txt")
#print(trainer_config.model_config)
#trainer_config.model_config.layers[1].shared_biases = true
#print(globals.has_field(trainer_config.model_config.layers[1], :shared_biases))

config = nothing
trainer_count = nothing
num_passes = nothing
use_gpu = nothing
seq = nothing
train_data = nothing
test_data = nothing
dict_file = nothing

function parse(path, obj)
 
    protoObj = PipeBuffer()
    globals.writeproto(protoObj, obj)

    open(path, "w") do f
        write(f, protoObj)
     end
     return path
end

function parseArguments()
    global config = ARGS[1]
    global trainer_count = ARGS[2]
    global num_passes = ARGS[3]
    global use_gpu = ARGS[4]
    global seq = ARGS[5]
    global train_data = ARGS[6]
    global test_data = ARGS[7]
    global dict_file = ARGS[8]
end


function main()

    parseArguments()

    println(config)
    println(use_gpu)
    println(train_data)

    #api.initPaddle("--use_gpu=0", "--trainer_count=2")
    #
    #trainer_config = parse_config("../trainer_config_helpers/trainer_config.lr.jl", "dict_file=../trainer_config_helpers/data/dict.txt")
#
#    #globals.clear(trainer_config, :data_config)
#    #globals.clear(trainer_config, :test_data_config)
#
#    ##println(trainer_config.model_config)
#    #println("===================================================================")
#
#    #model = api.GradientMachine[:createFromConfigProto](parse(dirname(Base.source_path()) * "/parser/api_train/" * "model", trainer_config.model_config))
#    #
#    ## create a trainer for the gradient machine
    #trainer = api.Trainer[:create](parse(dirname(Base.source_path()) * "/parser/api_train/" * "trainer", trainer_config), model)

    #input_types = [
    #    integer_value_sequence(len(word_dict)) if options.seq else
    #    sparse_binary_vector(len(word_dict)), integer_value(2)
    #]
    #converter = DataProviderConverter(input_types)

    #batch_size = trainer_config.opt_config.batch_size
    #trainer.startTrain()
    #for train_pass in xrange(options.num_passes)
    #    trainer.startTrainPass()
    #    random.shuffle(train_dataset)
    #    for pos in xrange(0, len(train_dataset), batch_size):
    #        batch = itertools.islice(train_dataset, pos, pos + batch_size)
    #        size = min(batch_size, len(train_dataset) - pos)
    #        trainer.trainOneDataBatch(size, converter(batch))
    #    trainer.finishTrainPass()
    #    if test_dataset:
    #        trainer.startTestPeriod()
    #        for pos in xrange(0, len(test_dataset), batch_size):
    #            batch = itertools.islice(test_dataset, pos, pos + batch_size)
    #            size = min(batch_size, len(test_dataset) - pos)
    #            trainer.testOneDataBatch(size, converter(batch))
    #        trainer.finishTestPeriod()
    #trainer.finishTrain()

    #println(trainer)
    
    println("End")
end


main()