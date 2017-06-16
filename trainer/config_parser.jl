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

function Inputs(args)
  globals.g_config_funcs[string(Inputs)] = Inputs
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

function HasInputsSet()
  globals.g_config_funcs[string(HasInputsSet)] = HasInputsSet
  length(globals.g_current_submodel.input_layer_name) != 0
end

function Outputs(args)
  globals.g_config_funcs[string(Outputs)] = Outputs
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

function Layer(name, layerType, kwargs)
  globals.g_config_funcs[string(Layer)] = Layer
  layers = Dict()
  merge!(layers, globals.g_cost_map, globals.g_layer_type_map)
  layer_func = layers[layerType]
  config_assert(layer_func, "layer type " * layerType * " not supported")
  return layer_func(name, kwargs)
end

type Bias

  locals

  function Bias(kwargs=nothing)

    globals.g_config_funcs[string(Bias)] = Bias

    this = new()

    this.locals = Dict()
    temp = Dict()

    temp["parameter_name"] = nothing
    temp["learning_rate"] = nothing
    temp["momentum"] = nothing
    temp["decay_rate"] = nothing
    temp["decay_rate_l1"] = nothing
    temp["initial_mean"] = nothing
    temp["initial_std"] = nothing
    temp["initial_strategy"] = nothing
    temp["initial_smart"] = nothing
    temp["num_batches_regularization"] = nothing
    temp["sparse_remote_update"] = nothing
    temp["gradient_clipping_threshold"] = nothing
    temp["is_static"] = nothing
    temp["is_shared"] = nothing

    if kwargs != nothing
      for key in keys(kwargs)
        temp[key] = kwargs[key]
      end
    end

    for key in keys(temp)
      if key[1] != '_'
        this.locals[key] = temp[key]
      end
    end

    return this

  end
end

type Input

  input_layer_name
  locals

  function Input(input_layer_name, kwargs=nothing)

    globals.g_config_funcs[string(Input)] = Input

    this = new()

    this.locals = Dict()
    temp = Dict()

    temp["parameter_name"] = nothing
    temp["learning_rate"] = nothing
    temp["momentum"] = nothing
    temp["decay_rate"] = nothing
    temp["decay_rate_l1"] = nothing
    temp["initial_mean"] = nothing
    temp["initial_std"] = nothing
    temp["initial_strategy"] = nothing
    temp["initial_smart"] = nothing
    temp["num_batches_regularization"] = nothing
    temp["sparse_remote_update"] = nothing
    temp["sparse_update"] = nothing
    temp["gradient_clipping_threshold"] = nothing
    temp["conv"] = nothing
    temp["bilinear_interp"] = nothing
    temp["norm"] = nothing
    temp["pool"] = nothing
    temp["image"] = nothing
    temp["block_expand"] = nothing
    temp["maxout"] = nothing
    temp["spp"] = nothing
    temp["pad"] = nothing
    temp["format"] = nothing
    temp["nnz"] = nothing
    temp["is_static"] = nothing
    temp["is_shared"] = nothing
    temp["update_hooks"] = nothing
    temp["input_layer_argument"] = nothing
    temp["make_layer_name_in_submodel"] = true

    if kwargs != nothing
      for key in keys(kwargs)
        temp[key] = kwargs[key]
      end
    end

    for key in keys(temp)
      if key[1] != '_'
        this.locals[key] = temp[key]
      end
    end

    if this.locals["make_layer_name_in_submodel"] == true
      this.input_layer_name = MakeLayerNameInSubmodel(input_layer_name)
    else
      this.input_layer_name = input_layer_name
    end

    return this

  end
end

function default_momentum(val)
  globals.g_config_funcs[string(default_momentum)] = default_momentum
  #globals.g_default_momentum = val
  globals.set_default_momentum(val)
end

function default_decay_rate(val)
    globals.g_config_funcs[string(default_decay_rate)] = default_decay_rate
    #globals.g_default_decay_rate = val
    globals.set_default_momentum(val)

end

function default_gradient_clipping_threshold(val)
  globals.g_config_funcs[string(default_gradient_clipping_threshold)] = default_gradient_clipping_threshold
  #globals.default_gradient_clipping_threshold = val
  globals.set_default_gradient_clipping_threshold(val)
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

function Evaluator(
        name,
        etype,
        inputs;
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

  evaluator = globals.EvaluatorConfig()
  globals.add_field!(globals.g_config.model_config, :evaluators, evaluator)

  globals.set_field!(evaluator, :_type, etype)
  globals.set_field!(evaluator, :name, MakeLayerNameInSubmodel(name))

  if isa(inputs, AbstractString)
    inputs = [inputs]
  end

  for name in inputs
    globals.add_field!(evaluator, :input_layers, MakeLayerNameInSubmodel(name))
  end

  if chunk_scheme != nothing
    globals.set_field!(evaluator, :chunk_scheme, chunk_scheme)
    globals.set_field!(evaluator, :num_chunk_types, num_chunk_types)
  end

  globals.add_field!(globals.g_current_submodel, :evaluator_names, evaluator.name)

  if classification_threshold != nothing
    evaluator.classification_threshold = classification_threshold
    globals.set_field!(evaluator, :classification_threshold, classification_threshold)
  end
  if positive_label != nothing
    globals.set_field!(evaluator, :positive_label, positive_label)
  end
  if dict_file != nothing
    globals.set_field!(evaluator, :dict_file, dict_file)
  end
  if result_file != nothing
    globals.set_field!(evaluator, :result_file, result_file)
  end
  if num_results != nothing
    globals.set_field!(evaluator, :num_results, num_results)
  end
  if top_k != nothing
    globals.set_field!(evaluator, :top_k, top_k)
  end
  if delimited != nothing
    globals.set_field!(evaluator, :delimited, delimited)
  end

  if excluded_chunk_types != nothing
    for chunk in excluded_chunk_types
      globals.add_field!(globals.evaluator, :excluded_chunk_types, chunk)
    end
  end
end

global_config_args = Dict()

function get_config_arg(name, Type, default=nothing)

  if Type == Bool
    s = global_config_args[name]
    if s == nothing || s == false
      return default
    end
    if s == "True" || s == "1" || s == "true"
      return true
    end
    if s == "False" || s == "0" || s == "false"
      return false
    end
  else
    return typeof(get(global_config_args, name, default))
  end
end


function update_g_config()

  for pair in enumerate(globals.settings)
    pair2 = collect(pair[2])
    k = pair2[1]
    v = pair2[2]

    if v == nothing
      continue
    end

    globals.set_field!(globals.g_config.opt_config, :k, v)
  end


  for pair in enumerate(globals.trainer_settings)
    pair2 = collect(pair[2])
    k = pair2[1]
    v = pair2[2]

    if v == nothing
      continue
    end

    globals.set_field!(globals.g_config.opt_config, :k, v)
  end

  return globals.g_config
end

function parse_config(trainer_config, config_arg_str)

  globals.init_config_environment()

  config_args = Dict()

  #make sure all proto usage is alright

  globals.set_field!(globals.g_config.model_config, :_type, "nn")

  if config_arg_str != nothing
    config_args = Dict([split(f, '=') for f in split(config_arg_str, ',')])
  end

  merge!(globals.g_command_config_args, config_args)

  globals.g_root_submodel = globals.SubModelConfig()

  globals.set_field!(globals.g_config, :model_config, globals.ModelConfig())

  globals.add_field!(globals.g_config.model_config, :sub_models, globals.g_root_submodel)
  globals.set_field!(globals.g_root_submodel, :name, "root")
  globals.set_field!(globals.g_root_submodel, :is_recurrent_layer_group, false)

  globals.g_current_submodel = globals.g_root_submodel

  global_config_args = config_args

  include(trainer_config) #execute the file

  return update_g_config()

end
















#for trying
#globals.g_config_funcs["TST"] = "asdf"
#eval(globals, :(g_add_submodel_suffix = true))
