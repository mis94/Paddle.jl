include(dirname(Base.source_path()) * "/globals.jl")
using globals



function MakeLayerNameInSubmodel(name, submodel_name=nothing)
  if is(submodel_name, nothing) && !globals.g_add_submodel_suffix && !globals.g_current_submodel.is_recurrent_layer_group
    return name
  end

  if is(submodel_name, nothing)
    submodel_name = globals.g_current_submodel.name
  end

  return name * "@" * submodel_name
end

function config_assert(b, msg)
  if !b
    #TODO: logger
    # logger.fatal(msg)
    println(msg)
  end
end

function deco_config_func(func, name)
  globals.g_config_funcs[name] = func
end

function deco_config_func1(func, name, args)
  deco_config_func(func, name)
  if(is(args, nothing))
    return func()
  end
  return func(args)
end

function deco_config_func2(func, name, layerName, layerType, kwargs)
  deco_config_func(func, name)
  func(layerName, layerType, kwargs)
end

function NoDecoInputs(args)
  for name in args

    name = MakeLayerNameInSubmodel(name)
    if globals.g_current_submodel.is_recurrent_layer_group
      config_assert(false, "Do not set Inputs in recurrent layer group")
    else
      append!(globals.g_current_submodel.input_layer_names, name)
    end

    if is(globals.g_current_submodel, globals.g_root_submodel)
      append!(globals.g_config.model_config.input_layer_names, name)
    end

  end
end

function Inputs(args)
  deco_config_func1(NoDecoInputs, string(Inputs), args)
end

function NoDecoHasInputsSet()
  length(globals.g_current_submodel.input_layer_name) != 0
end

function HasInputsSet()
  deco_config_func1(NoDecoHasInputsSet, string(HasInputsSet), nothing)
end

function NoDecoOutputs(args)
  for name in args

    name = MakeLayerNameInSubmodel(name)
    if globals.g_current_submodel.is_recurrent_layer_group
      config_assert(false, "Do not set Outputs in recurrent layer group")
    else
      append!(globals.g_current_submodel.output_layer_names, name)
    end

    if is(globals.g_current_submodel, globals.g_root_submodel)
      append!(globals.g_config.model_config.output_layer_names, name)
    end

  end
end

function Outputs(args)
  deco_config_func1(NoDecoOutputs, string(Outputs), args)
end

function NoDecoLayer(name, layerType, kwargs)
  layers = Dict()
  merge!(layers, globals.g_cost_map, globals.g_layer_type_map)
  layer_func = layers[layerType]
  config_assert(layer_func, "layer type " * layerType * " not supported")
  return layer_func(name, kwargs)
end

function Layer(name, layerType, kwargs)
  deco_config_func2(NoDecoLayer, string(Layer), name, layerType, kwargs)
end

type Input
  input_layer_name

  function Input(input_layer_name;
            parameter_name=nothing,
            learning_rate=nothing,
            momentum=nothing,
            decay_rate=nothing,
            decay_rate_l1=nothing,
            initial_mean=nothing,
            initial_std=nothing,
            initial_strategy=nothing,
            initial_smart=nothing,
            num_batches_regularization=nothing,
            sparse_remote_update=nothing,
            sparse_update=nothing,
            gradient_clipping_threshold=nothing,
            conv=nothing,
            bilinear_interp=nothing,
            norm=nothing,
            pool=nothing,
            image=nothing,
            block_expand=nothing,
            maxout=nothing,
            spp=nothing,
            pad=nothing,
            format=nothing,
            nnz=nothing,
            is_static=nothing,
            is_shared=nothing,
            update_hooks=nothing,
            input_layer_argument=nothing,
            make_layer_name_in_submodel=true)

    globals.g_config_funcs[string(Input)] = Input

    this = new()

    if make_layer_name_in_submodel
      this.input_layer_name = MakeLayerNameInSubmodel(input_layer_name)
    else
      this.input_layer_name = input_layer_name
    end

    return this

  end
end

function default_momentum(val)
  globals.g_config_funcs[string(default_momentum)] = default_momentum
  globals.g_default_momentum = val
end

function default_decay_rate(val)
    globals.g_config_funcs[string(default_decay_rate)] = default_decay_rate
    globals.g_default_decay_rate = val
end

function default_gradient_clipping_threshold(val)
  globals.g_config_funcs[string(default_gradient_clipping_threshold)] = default_gradient_clipping_threshold
  globals.default_gradient_clipping_threshold = val
end

settings  =  Dict(
    "batch_size" => nothing,
    "mini_batch_size" => nothing,
    "algorithm" => "async_sgd",
    "async_lagged_grad_discard_ratio" => 1.5,
    "learning_method" => "momentum",
    "num_batches_per_send_parameter" => nothing,
    "num_batches_per_get_parameter" => nothing,
    "center_parameter_update_method" => nothing,
    "learning_rate" => 1.,
    "learning_rate_decay_a" => 0.,
    "learning_rate_decay_b" => 0.,
    "learning_rate_schedule" => "poly",
    "learning_rate_args" => "",
    "l1weight" => 0.1,
    "l2weight" => 0.,
    "l2weight_zero_iter" => 0,
    "c1" => 0.0001,
    "backoff" => 0.5,
    "owlqn_steps" => 10,
    "max_backoff" => 5,
    "average_window" => 0,
    "do_average_in_cpu" => false,
    "max_average_window" => nothing,
    "ada_epsilon" => 1e-6,
    "ada_rou" => 0.95,
    "delta_add_rate" => 1.0,
    "shrink_parameter_value" => 0,
    "adam_beta1" => 0.9,
    "adam_beta2" => 0.999,
    "adam_epsilon" => 1e-8)

trainer_settings = Dict(
    "save_dir" => "./output/model",
    "init_model_path" => "nothing",
    "start_pass" => 0)


function Settings(;kwargs...)
  for arg in kwargs
    k = string(arg[1])
    v = arg[2]
    if k in keys(settings)
      settings[k] = v
    elseif k in keys(trainer_settings)
      trainer_settings[k] = v
    end
    #TODO fatal if k not in settings nor trainer_settings
  end
end

#TODO check UndefRefError in proto
function Evaluator(
        name,
        etype,
        inputs,
        chunk_scheme=nothing,
        num_chunk_types=nothing,
        classification_threshold=nothing,
        positive_label=nothing,
        dict_file=nothing,
        result_file=nothing,
        num_results=nothing,
        top_k=nothing,
        delimited=nothing,
        excluded_chunk_types=nothing)
  globals.g_config_funcs[string(Evaluator)] = Evaluator

  evaluator = EvaluatorConfig()
  push!(globals.g_config.model_config.evaluators, evaluator)

  evaluator.etype = etype
  evaluator.name = MakeLayerNameInSubmodel(name)
  if isa(inputs, AbstractString)
    inputs = [inputs]
  end

  for name in inputs
    push!(evaluator.input_layers, MakeLayerNameInSubmodel(name))
  end

  if chunk_scheme != nothing
    evaluator.chunk_scheme = chunk_scheme
    evaluator.num_chunk_types = num_chunk_types
  end

  push!(globals.g_current_submodel.evaluator_names, evaluator.name)

  if classification_threshold != nothing
    evaluator.classification_threshold = classification_threshold
  end
  if positive_label != nothing
    evaluator.positive_label = positive_label
  end
  if dict_file != nothing
    evaluator.dict_file = dict_file
  end
  if result_file != nothing
    evaluator.result_file = result_file
  end
  if num_results != nothing
    evaluator.num_results = num_results
  end
  if top_k != nothing
    evaluator.top_k = top_k
  end
  if delimited != nothing
    evaluator.delimited = delimited
  end
  if excluded_chunk_types != nothing
    for chunk in excluded_chunk_types
      push!(evaluator.excluded_chunk_types, chunk)
    end
  end
end


#for trying
#globals.g_config_funcs["TST"] = "asdf"
#eval(globals, :(g_add_submodel_suffix = true))