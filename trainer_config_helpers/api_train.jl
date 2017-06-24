include("../trainer/config_parser.jl")
include("data_sources.jl")
include("optimizers.jl")
include("layers.jl")
include("activations.jl")
include("networks.jl")
include("JlDataProvider.jl")
include("dataprovider_converter.jl")

using JSON
using PyCall
@pyimport py_paddle.swig_paddle as api


#trainer_config = parse_config("../trainer_config_helpers/trainer_config.lr.jl", "dict_file=../trainer_config_helpers/data/dict.txt")
#print(trainer_config.model_config)
#trainer_config.model_config.layers[1].shared_biases = true
#print(globals.has_field(trainer_config.model_config.layers[1], :shared_biases))

UNK_IDX = 0

config = nothing
trainer_count = nothing
num_passes = nothing
use_gpu = nothing
seq = nothing
train_data = nothing
test_data = nothing
dict_file = nothing

function parseProtoObject(path, obj)
 
    protoObj = PipeBuffer()
    globals.writeproto(protoObj, obj)

    open(path, "w") do f
        write(f, protoObj)
     end
     return path
end

function parseArguments()
    global config = ARGS[1]
    global trainer_count = parse(Int, ARGS[2])
    global num_passes = parse(Int, ARGS[3])
    global use_gpu = parse(Int, ARGS[4])
    global seq = parse(Int, ARGS[5])
    global train_data = ARGS[6]
    global test_data = ARGS[7]
    global dict_file = ARGS[8]
    
    println("=============================")
    println( config )
    println( trainer_count)
    println( num_passes) 
    println( use_gpu )
    println( seq )
    println( train_data )
    println( test_data )
    println( dict_file )
end


#function load_data(file_name, word_dict)
#    function temp()
#        open(file_name) do f
#            while !eof(f)
#                line = readline(f)
#                label, comment = split(strip(line), "\t")
#                words = split(comment)
#                word_slot = [get(word_dict, w, UNK_IDX) for w in words]
#                produce((word_slot, parse(Int, label)))
#            end
#        end
#    end
#    Task(temp)
    #println(consume(train_dataset[1]))
    #println(consume(train_dataset[1]))
    #println(consume(train_dataset[1]))
#end

function load_data(file_name, word_dict)
    ret = []
    open(file_name) do f
        while !eof(f)
            line = readline(f)
            label, comment = split(strip(line), "\t")
            words = split(comment)
            word_slot = [get(word_dict, w, UNK_IDX) for w in words]
            push!(ret, (word_slot, parse(Int, label)))
        end
    end
    return ret
end


function load_dict(dict_file)
    word_dict = Dict()
    open(dict_file) do f
        i = 0
        while !eof(f)
            line = readline(f)
            w = split(strip(line))[1]
            word_dict[w] = i
            i = i +1
        end
    end

    return word_dict
end

function main()

    parseArguments()

    api.initPaddle("--use_gpu=" * string(use_gpu), "--trainer_count=" * string(trainer_count))

    word_dict = load_dict(dict_file)
    train_dataset = load_data(train_data, word_dict)
    test_dataset = nothing
    if test_data != nothing
        test_dataset = load_data(test_data, word_dict)
    else
        test_dataset = nothing
    end
    
    trainer_config = parse_config(config, "dict_file=" * dict_file)

    globals.clear(trainer_config, :data_config)
    globals.clear(trainer_config, :test_data_config)
    globals.clear(trainer_config.model_config.parameters[1], :is_sparse)

    #println(trainer_config.model_config)
    #println("===================================================================")

    model = api.GradientMachine[:createFromConfigProto](parseProtoObject(dirname(Base.source_path()) * "/parser/api_train/" * "model", trainer_config.model_config))
    
    ### create a trainer for the gradient machine
    trainer = api.Trainer[:create](parseProtoObject(dirname(Base.source_path()) * "/parser/api_train/" * "trainer", trainer_config), model)

    input_types = nothing
    #global seq
    #seq = parse(Int, seq)

    if seq != 0
        input_types = [integer_value_sequence(length(word_dict))]
    else 
        input_types = [sparse_binary_vector(length(word_dict)), integer_value(2)]
    end

    converter = DataProviderConverter(input_types)

    batch_size = trainer_config.opt_config.batch_size
    trainer[:startTrain]()

    for train_pass in 1:num_passes
        trainer[:startTrainPass]()
        shuffle(train_dataset)
        for pos in collect(1: batch_size: length(train_dataset))
            size = min(batch_size, length(train_dataset) - pos)
            batch = train_dataset[pos: pos + size - 1]
            trainer[:trainOneDataBatch](size, converter.convert(batch))
        end
        trainer[:finishTrainPass]()
        
        if test_dataset != nothing
            trainer[:startTestPeriod]()
            for pos in collect(1: batch_size: length(test_dataset))
                size = min(batch_size, length(test_dataset) - pos)
                batch = test_dataset[pos: pos + size - 1 ]
                trainer[:testOneDataBatch](size, converter.convert(batch))

            end
            trainer[:finishTestPeriod]()
        end
    end
    trainer[:finishTrain]()

    #println(trainer)
    
    println("End")
end


main()