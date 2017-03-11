# layers file

type LayerType
    # layer type enumerations
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
    activations
    num_filters
    img_norm_type
    outputs
    reverse

    function LayerOutput(name,
                        layer_type;
                        parents=nothing,
                        activations=nothing,
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
        this.activations = activations
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
