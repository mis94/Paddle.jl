include("../trainer/config_parser.jl")
include("data_sources.jl")
include("optimizers.jl")
include("layers.jl")
include("activations.jl")
include("networks.jl")
include("JlDataProvider.jl")
include("dataprovider_converter.jl")
include("api.jl")

function parseProtoObject(path, obj)
 
    protoObj = PipeBuffer()
    globals.writeproto(protoObj, obj)

    open(path, "w") do f
        write(f, protoObj)
     end
     return path
end

type QuickStartPrediction
    train_conf
    dict_file
    model_dir
    label_file

    word_dict
    dict_dim
    label
    converter
    network

    load_dict::Function
    load_label::Function
    get_index::Function
    batch_predict::Function

    api_GradientMachine

    function QuickStartPrediction(train_conf, dict_file; model_dir=nothing, label_file=nothing)

        this = new()

        this.api_GradientMachine = GradientMachine()

        this.load_dict = function()
            """
            Load dictionary from self.dict_file.
            """
            open(this.dict_file) do f
                line_count = 0
                while !eof(f)
                    line = readline(f)
                    temp = split(strip(line), "\t")
                    this.word_dict[temp[1]] = line_count

                    line_count = line_count + 1
                end
            end

            return length(this.word_dict)
        end

        this.load_label = function(label_file)
            """
            Load label.
            """
            this.label = Dict()

            open(label_file) do f 
                while !eof(f)
                    v = readline(f)
                    temp = split(v, "\t")
                    this.label[parse(Int, temp[2])] = temp[1]
                end
            end
        end

        this.get_index = function(data)
            """
            transform word into integer index according to the dictionary.
            """
            words = split(strip(data))

            word_slot = [this.word_dict[w] for w in words if w in keys(this.word_dict)]
            return word_slot
        end

        this.batch_predict = function(data_batch)

            input = this.converter.convert(data_batch)
            output = this.api_GradientMachine.forwardTest(input)
            prob = output[1]["id"]
            println("predicting labels is:")
            println(prob)
        end

        this.train_conf = train_conf
        this.dict_file = dict_file
        this.word_dict = Dict()
        this.dict_dim = this.load_dict()
        this.model_dir = model_dir

        if model_dir == nothing
            this.model_dir = dirname(Base.source_path()) * train_conf
        end

        this.label = nothing
        if label_file != nothing
            this.load_label(label_file)
        end

        conf = parse_config(train_conf, "is_predict=1")
        this.api_GradientMachine.createFromConfigProto(parseProtoObject(dirname(Base.source_path()) * "/parser/api_predict/" * "model", conf.model_config))
        this.api_GradientMachine.loadParameters(this.model_dir)
        input_types = [sparse_binary_vector(this.dict_dim)] #check type 
        this.converter = DataProviderConverter(input_types)

        return this
    end

end

function main()

    #train_conf = config
    #dict_file = dict
    #model_path = model

    config= ARGS[1]
    model= ARGS[2]
    label= ARGS[3]
    dict= ARGS[4]
    batch_size= parse(Int, ARGS[5])


    api.initPaddle("--use_gpu=0")
    predict = QuickStartPrediction(config, dict, model_dir=model, label_file=label)

    batch = []
    labels = []


    for line in eachline(STDIN)
        label, text = split(line, "\t")
        append!(labels, parse(Int,label))
        push!(batch, [predict.get_index(text)])
    end

    #open(STDIN) do f
    #    while !eof(STDIN)
    #        line = readline(STDIN)
    #        label, text = line.split("\t")
    #        labels.append!(Int(label))
    #        batch.append!([predict.get_index(text)])
    #    end
    #end

    println("labels is:")
    println(labels)

    predict.batch_predict(batch)
end

main()