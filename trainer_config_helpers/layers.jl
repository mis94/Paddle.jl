include("attrs.jl")
include("evaluators.jl")
include("config_parser.jl")
include("default_decorators.jl")

type LayerType

    layersTypes::Set{String}
    is_layer_type::Function

    function LayerType()
        this = new()

        this.layersTypes = Set{String}()

        push!(this.layersTypes, "data")
        push!(this.layersTypes, "mixed")
        push!(this.layersTypes, "lstmemory")
        push!(this.layersTypes, "gated_recurrent")
        push!(this.layersTypes, "seqlastins")
        push!(this.layersTypes, "seqfirstins")
        push!(this.layersTypes, "max")
        push!(this.layersTypes, "average")
        push!(this.layersTypes, "fc")
        push!(this.layersTypes, "cost")
        push!(this.layersTypes, "cos_vm")
        push!(this.layersTypes, "cos")
        push!(this.layersTypes, "hsigmoid")
        push!(this.layersTypes, "conv")
        push!(this.layersTypes, "convt")
        push!(this.layersTypes, "exconv")
        push!(this.layersTypes, "exconvt")
        push!(this.layersTypes, "cudnn_conv")
        push!(this.layersTypes, "pool")
        push!(this.layersTypes, "batch_norm")
        push!(this.layersTypes, "norm")
        push!(this.layersTypes, "sum_to_one_norm")
        push!(this.layersTypes, "addto")
        push!(this.layersTypes, "concat")
        push!(this.layersTypes, "concat2")
        push!(this.layersTypes, "lstm_step")
        push!(this.layersTypes, "gru_step")
        push!(this.layersTypes, "get_output")
        push!(this.layersTypes, "expand")
        push!(this.layersTypes, "interpolation")
        push!(this.layersTypes, "bilinear_interp")
        push!(this.layersTypes, "power")
        push!(this.layersTypes, "scaling")
        push!(this.layersTypes, "trans")
        push!(this.layersTypes, "out_prod")
        push!(this.layersTypes, "featmap_expand")
        push!(this.layersTypes, "memory")
        push!(this.layersTypes, "maxid")
        push!(this.layersTypes, "eos_id")
        push!(this.layersTypes, "recurrent")
        push!(this.layersTypes, "conv_shift")
        push!(this.layersTypes, "tensor")
        push!(this.layersTypes, "selective_fc")
        push!(this.layersTypes, "sampling_id")
        push!(this.layersTypes, "slope_intercept")
        push!(this.layersTypes, "convex_comb")
        push!(this.layersTypes, "blockexpand")
        push!(this.layersTypes, "maxout")
        push!(this.layersTypes, "spp")
        push!(this.layersTypes, "pad")
        push!(this.layersTypes, "print")
        push!(this.layersTypes, "priorbox")
        push!(this.layersTypes, "ctc")
        push!(this.layersTypes, "warp_ctc")
        push!(this.layersTypes, "crf")
        push!(this.layersTypes, "crf_decoding")
        push!(this.layersTypes, "nce")
        push!(this.layersTypes, "rank-cost")
        push!(this.layersTypes, "lambda_cost")
        push!(this.layersTypes, "huber")
        push!(this.layersTypes, "multi-class-cross-entropy")
        push!(this.layersTypes, "multi_class_cross_entropy_with_selfnorm")
        push!(this.layersTypes, "soft_binary_class_cross_entropy")
        push!(this.layersTypes, "multi_binary_label_cross_entropy")
        push!(this.layersTypes, "sum_cost")


        this.is_layer_type = function(type_name)

            if in(type_name, this.layersTypes)
                return true
            else
                return false
            end
        end

        return this
    end
end

layerType = LayerType()

type LayerOutput
    name
    layer_type
    size
    parents
    activation
    num_filters
    img_norm_type
    outputs
    reverse

    function LayerOutput(name,
                        layer_type;
                        parents=nothing,
                        activation=nothing,
                        num_filters=nothing,
                        img_norm_type=nothing,
                        size=nothing,
                        outputs=nothing,
                        reverse=nothing)

        @assert isa(name, String)
        @assert isa(layer_type, String)
        @assert !isa(size, Void)
        @assert layerType.is_layer_type(layer_type)

        this = new()

        this.name = name
        this.layer_type = layer_type
        if !isa(parents, Void) && !isa(parents, Array)
            this.parents = [parents]
        else
            this.parents = []
        end
        this.activation = activation
        this.num_filters = num_filters
        this.img_norm_type = img_norm_type
        this.size = size
        if isa(outputs, Void)
            outputs = ["default"]
        end
        this.outputs = outputs
        this.reverse = reverse

        return this
    end
end

function layer_support(methodName, args...; kwargs...)
    for each in args
        if isa(each, ExtraLayerAttribute)
            for attr in kwargs
                push!(each.attributesSet, join(["can", attr[2]], "_"))
            end
            each.check(methodName)
        end
    end
end

function data_layer(name, size; height=nothing, width=nothing, layer_attr=nothing)
    layer_support(string(data_layer), name, size, height, width, layer_attr, device="device")

    kwargs = Dict()
    kwargs["size"] = size
    kwargs["height"] = height
    kwargs["width"] = width

    #discuss how should static method be implemented
    merge!(kwargs, to_kwargs(layer_attr))

    Layer(name, "data", kwargs)

    return LayerOutput(name, "data", size=size)
end

function fc_layer(input,
                 size;
                 act=nothing,
                 name=nothing,
                 param_attr=nothing,
                 bias_attr=nothing,
                 layer_attr=nothing)

    layer_support(string(fc_layer), input, size, act, name, param_attr, bias_attr, layer_attr,
        errorClipping = "error_clipping_threshold", dropout = "drop_rate")

    act = wrap_act_default(act)
    bias_attr = wrap_bias_attr_default(bias_attr)
    param_attr = wrap_param_attr_default(param_attr)
    name = wrap_name_default(name, string(fc_layer))

    if isa(input, LayerOutput)
        input = [input]
        @assert !isa(param_attr, Array)
        @assert !isa(param_attr, Tuple)
        param_attr = [param_attr]
    else
        if isa(param_attr, Array) || isa(param_attr, Tuple)
            @assert length(input) == length(param_attr)
        else
            deepCopyOfParamAttr = deepcopy(param_attr)
            param_attr = []
            for i in 1:length(input)
                push!(param_attr, deepCopyOfParamAttr)
            end
        end
    end

    @assert isa(input, Array) || isa(input, Tuple)

    kwargs = Dict()

    inputs = []
    for (ipt, attr) in zip(input, param_attr)
        push!(inputs, Input(ipt.name, attr.attr))
    end
    kwargs["inputs"] = inputs

    kwargs["size"] = size
    kwargs["bias"] = to_bias(bias_attr)
    kwargs["active_type"] = act.name
    merge!(kwargs, to_kwargs(layer_attr))

    Layer(name, "fc", kwargs)

    return LayerOutput(name, "fc", activation=act, size=size)
end

function classificationCost(input,
                            label;
                            weight=nothing,
                            name=nothing,
                            evaluator=classification_error_evaluator,
                            layer_attr=nothing)

    layer_support(string(classificationCost), input, label, weight, name, evaluator, layer_attr,
        device="device")

    name = wrap_name_default("cost", string(classificationCost))

    @assert input.layer_type != "data"
    @assert isa(input.activation, SoftmaxActivation)
    @assert label.layer_type == "data"

    ipts, parents = __cost_input__(input, label, weight)

    kwargs = Dict()
    kwargs["inputs"] = ipts
    merge!(kwargs, to_kwargs(layer_attr))

    Layer(name, "multi-class-cross-entropy", kwargs)

    function __add_evaluator__(e)
        @assert isa(e, Function)
        e(input, label, name=string(evaluator), weight=weight)
    end

    if !isa(evaluator, Array) && !isa(evaluator, Tuple)
        evaluator = [evaluator]
    end

    for(eachEvaluator in evaluator)
        __add_evaluator__(eachEvaluator)
    end

    return LayerOutput(name, "cost", parents=parents, size=1)
end

function __cost_input__(input, label; weight=nothing)
    ipts = [Input(input.name), Input(input.name)]
    parents = [input, label]
    if !isa(weight, Void)
        @assert weight.layer_type == "data"
        push!(ipts, Input(weight.name))
        push!(parents, weight)
    end
    return ipts, parents
end

function maxid_layer(input; name=nothing, layer_attr=nothing)
    name = wrap_name_default(name, string(maxid_layer))

    @assert isa(input, LayerOutput)

    kwargs = Dict()
    kwargs["inputs"] = [input.name]
    merge!(kwargs, to_kwargs(layer_attr))

    l = Layer(name, "maxid", kwargs)

    return LayerOutput(name=name, layer_type="maxid", parents=[input], size=l.config.size)
end
