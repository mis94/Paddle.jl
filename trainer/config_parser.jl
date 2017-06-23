include(dirname(Base.source_path()) * "/globals.jl")
using globals

function default(x, default_value)
  if x != nothing
    return x
  end
  return default_value
end

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


function Parameter(name,
              size,
              device,
              dims;
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
              sparse=nothing,
              format=nothing,
              need_compact=nothing,
              is_static=nothing,
              is_shared=nothing,
              update_hooks=nothing)

    globals.g_config_funcs[string(Parameter)] = Parameter

    globals.fillset(globals.g_config.model_config, :parameters)
    para = globals.ParameterConfig()
    globals.add_field!(globals.g_config.model_config, :parameters, para)

    globals.set_field!(para, :name, name)
    globals.set_field!(para, :size, size)
    if device != nothing
      globals.set_field!(para, :device, device)
    end

    globals.fillset(para, :dims)
    for dim in dims
      globals.add_field!(para, :dims, dim)
    end

    if learning_rate != nothing
      globals.set_field!(para, :learning_rate, learning_rate)
    end

    momentum = default(momentum, globals.g_default_momentum)
    if momentum != nothing
      globals.set_field!(para, :momentum, momentum)
    end

    decay_rate = default(decay_rate, globals.g_default_decay_rate)
    if decay_rate != nothing
      globals.set_field!(para, :decay_rate, decay_rate)
    end

    if decay_rate_l1 != nothing
      globals.set_field!(para, :decay_rate_l1, decay_rate_l1)
    end

    globals.set_field!(para, :initial_std, default(initial_std, globals.g_default_initial_std))
    globals.set_field!(para, :initial_mean, default(initial_mean, globals.g_default_initial_mean))

    num_batches_regularization = default(num_batches_regularization,
                                         globals.g_default_num_batches_regularization)
    if num_batches_regularization != nothing
      globals.set_field!(para, :num_batches_regularization, Int32(num_batches_regularization))
    end


    if sparse_remote_update != nothing
      globals(para, :sparse_remote_update, sparse_remote_update)
      if !globals.has_field(globals.g_config, :opt_config)
        globals.set_field!(globals.g_config, :opt_config, globals.OptimizationConfig())
      end
      if sparse_remote_update
        g_config.opt_config.use_sparse_remote_updater = true
        globals.set_field!(g_config.opt_config, :use_sparse_remote_updater, true)
      end
    end
    if sparse_update != nothing
      globals.set_field!(para, :sparse_update, sparse_update)
    end

    gradient_clipping_threshold = default(gradient_clipping_threshold,
                                          globals.g_default_gradient_clipping_threshold)
    if gradient_clipping_threshold != nothing
      globals.set_field!(para, :gradient_clipping_threshold, Float64(gradient_clipping_threshold))
    end

    globals.set_field!(para, :initial_strategy, Int32(default(initial_strategy,
                                    globals.g_default_initial_strategy)))
    globals.set_field!(para, :initial_smart, default(initial_smart, globals.g_default_initial_smart))

    if para.initial_smart
      globals.set_field!(para, :initial_mean, 0.)
      if length(para.dims) != 0
        globals.set_field!(para, :initial_std, 1./sqrt(para.dims[1]))
      else
        para.initial_std = 1. / math.sqrt(para.size)
      end
    end

    if sparse != nothing
      globals.set_field!(para, :is_sparse, sparse)
    end

    if format != nothing
      globals.set_field!(para, :format, format)
    end

    if need_compact != nothing
      globals.set_field!(para, :need_compact, need_compact)
    end

    if is_static != nothing
      globals.set_field!(para, :is_static, is_static)
    end

    if is_shared != nothing
      globals.set_field!(para, :is_shared, is_shared)
    end

    #update_hooks = default(update_hooks, g_default_update_hooks)
    globals.g_parameter_map[name] = para
end


function Inputs(args)
  globals.g_config_funcs[string(Inputs)] = Inputs

  globals.fillset(globals.g_current_submodel, :input_layer_names)
  globals.fillset(globals.g_config.model_config, :input_layer_names)

  for name in args
    name = MakeLayerNameInSubmodel(name)

    if globals.g_current_submodel.is_recurrent_layer_group
      config_assert(false, "Do not set Inputs in recurrent layer group")
    else
      globals.add_field!(globals.g_current_submodel, :input_layer_names, name)
    end

    if is(globals.g_current_submodel, globals.g_root_submodel)
      globals.add_field!(globals.g_config.model_config, :input_layer_names, name)
    end

  end
end

function HasInputsSet()
  globals.g_config_funcs[string(HasInputsSet)] = HasInputsSet
  return globals.has_field(globals.g_current_submodel, :input_layer_names) && length(globals.g_current_submodel.input_layer_names) != 0
end

function Outputs(args)
  globals.g_config_funcs[string(Outputs)] = Outputs

  globals.fillset(globals.g_current_submodel, :output_layer_names)
  globals.fillset(globals.g_config.model_config, :output_layer_names)
  
  for name in args

    name = MakeLayerNameInSubmodel(name)
    if globals.g_current_submodel.is_recurrent_layer_group
      config_assert(false, "Do not set Outputs in recurrent layer group")
    else
      globals.add_field!(globals.g_current_submodel, :output_layer_names, name)
    end

    if is(globals.g_current_submodel, globals.g_root_submodel)
      globals.add_field!(globals.g_config.model_config, :output_layer_names, name)
    end
  end
end

function Layer(name, layerType, kwargs)
  globals.g_config_funcs[string(Layer)] = Layer

  if layerType == "data"
    layerBase = LayerBase(name, "data", kwargs["size"], [], device=nothing)
    if kwargs["height"] != nothing && kwargs["height"] != 0 && kwargs["width"] != nothing && kwargs["width"] != 0
      layerBase.set_layer_height_width(kwargs["height"], kwargs["width"])
    end
  elseif layerType == "fc"
    layerBase = LayerBase(name, "fc", kwargs["size"], kwargs["inputs"], device=nothing, active_type=kwargs["active_type"])
    for input_index in 1:length(kwargs["inputs"])
      input_layer = layerBase.get_input_layer(input_index)
      psize = layerBase.config.size * input_layer.size
      dims = [input_layer.size, layerBase.config.size]
      format = layerBase.inputs[input_index].locals["format"]
      sparse = false
      if format == "csr" || format == "csc"
        sparse = true
      end
      if sparse
        psize = layerBase.inputs[input_index].nnz
      else
        spase = nothing
      end
      layerBase.create_input_parameter(input_index, psize, dims, sparse, format)
    end
    layerBase.create_bias_parameter(kwargs["bias"], layerBase.config.size)
  elseif layerType == "multi-class-cross-entropy"
    LayerBase(name, "multi-class-cross-entropy", 1, kwargs["inputs"], coeff=1.)
  end

  #config_assert(layer_func, "layer type " * layerType * " not supported")
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

type Operator
  _type
  operator_conf
  calc_output_size::Function

  function Operator(input_layer_name)

    globals.g_config_funcs[string(Input)] = Input

    this = new()
    this._type = nothing
    this.operator_conf = globals.OperatorConfig()
    this.operator_conf._type = this._type

    this.calc_output_size = function(input_size)
      return 0
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
  globals.set_default_decay_rate(val)
  return

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
    "l2weight_zero_iter" => Int32(0),
    "c1" => 0.0001,
    "backoff" => 0.5,
    "owlqn_steps" => Int32(10),
    "max_backoff" => Int32(5),
    "average_window" => 0.,
    "do_average_in_cpu" => false,
    "max_average_window" => nothing,
    "ada_epsilon" => 1e-6,
    "ada_rou" => 0.95,
    "delta_add_rate" => 1.0,
    "shrink_parameter_value" => 0.,
    "adam_beta1" => 0.9,
    "adam_beta2" => 0.999,
    "adam_epsilon" => 1e-8)

trainer_settings = Dict(
    "save_dir" => "./output/model",
    "init_model_path" => nothing,
    "start_pass" => Int32(0))


function Settings(kwargs)
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

  globals.fillset(globals.g_config.model_config, :evaluators)

  globals.add_field!(globals.g_config.model_config, :evaluators, evaluator)

  globals.set_field!(evaluator, :_type, etype)
  globals.set_field!(evaluator, :name, MakeLayerNameInSubmodel(name))

  if isa(inputs, AbstractString)
    inputs = [inputs]
  end

  globals.fillset(evaluator, :input_layers)
  for name in inputs
    globals.add_field!(evaluator, :input_layers, MakeLayerNameInSubmodel(name))
  end

  if chunk_scheme != nothing
    globals.set_field!(evaluator, :chunk_scheme, chunk_scheme)
    globals.set_field!(evaluator, :num_chunk_types, num_chunk_types)
  end

  globals.fillset(globals.g_current_submodel, :evaluator_names)    
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

    globals.fillset(globals.evaluator, :excluded_chunk_types)    

    for chunk in excluded_chunk_types
      globals.add_field!(globals.evaluator, :excluded_chunk_types, chunk)
    end
  end
end

global_config_args = Dict()

function get_config_arg(name, Type, default=nothing)

  if Type == Bool
    s = get(global_config_args, name, nothing)
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
    return Type(get(global_config_args, name, default))
  end
end


function update_g_config()
  if !globals.has_field(globals.g_config, :opt_config)
    globals.set_field!(globals.g_config, :opt_config, globals.OptimizationConfig())
  end
  for pair in enumerate(settings)
    pair2 = collect(pair[2])
    k = pair2[1]
    v = pair2[2]

    if v == nothing
      continue
    end
    globals.set_field!(globals.g_config.opt_config, Symbol(k), v)
  end


  for pair in enumerate(trainer_settings)
    pair2 = collect(pair[2])
    k = pair2[1]
    v = pair2[2]

    if v == nothing
      continue
    end

    globals.set_field!(globals.g_config, Symbol(k), v)
  end

  return globals.g_config
end

function parse_config(trainer_config, config_arg_str)

  globals.init_config_environment()

  config_args = Dict()

  #make sure all proto usage is alright
  globals.set_field!(globals.g_config, :model_config, globals.ModelConfig())
  globals.set_field!(globals.g_config.model_config, :_type, "nn")

  if config_arg_str != nothing
    config_args = Dict([split(f, '=') for f in split(config_arg_str, ',')])
  end

  merge!(globals.g_command_config_args, config_args)

  #globals.g_root_submodel = globals.SubModelConfig()
  eval(globals, :(g_root_submodel = SubModelConfig()))

  globals.fillset(globals.g_config.model_config, :sub_models)    
  globals.add_field!(globals.g_config.model_config, :sub_models, globals.g_root_submodel)
  globals.set_field!(globals.g_root_submodel, :name, "root")
  globals.set_field!(globals.g_root_submodel, :is_recurrent_layer_group, false)

  #globals.g_current_submodel = globals.g_root_submodel
  eval(globals, :(g_current_submodel = g_root_submodel))

  global_config_args = config_args

  include(trainer_config) #execute the file

  return update_g_config()

end

function TrainData(data_config, async_load_data=nothing)
  globals.g_config_funcs[string(TrainData)] =  TrainData
  globals.set_field!(globals.g_config, :data_config, deepcopy(data_config))
  globals.set_field!(globals.g_config.data_config, :for_test, true)
  if async_load_data != nothing
    globals.set_field!(globals.g_config.data_config, :async_load_data, async_load_data)
  end
end

function TestData(data_config, async_load_data=nothing)
  globals.g_config_funcs[string(TestData)] = TestData
  globals.set_field!(globals.g_config, :test_data_config, deepcopy(data_config))
  globals.set_field!(globals.g_config.test_data_config, :for_test, true)
  if async_load_data != nothing
    globals.set_field!(globals.g_config.test_data_config, :async_load_data, async_load_data)
  end
end




function DataBase(async_load_data=false, constant_slots=nothing, data_ratio=1, is_main_data=true, usage_ratio=nothing)
  data_config = globals.DataConfig()
  globals.set_field!(data_config, :async_load_data, async_load_data)

  if constant_slots != nothing

    globals.fillset(data_config, :constant_slots)    

    for slot in constant_slots
      globals.add_field!(data_config, :constant_slots, slot)
    end
  end
  globals.set_field!(data_config, :data_ratio, Int32(data_ratio))
  globals.set_field!(data_config, :is_main_data, is_main_data)

  if usage_ratio == nothing
    usage_ratio = 1
  end
  globals.set_field!(data_config, :usage_ratio, Float64(usage_ratio))

  return data_config
end

type LayerBase
  name
  Type
  size
  inputs
  device
  active_type
  drop_rate
  coeff
  config
  operators
  get_input_layer::Function
  set_layer_height_width::Function
  create_input_parameter::Function
  create_bias_parameter::Function

  function LayerBase(name, Type, size, inputs; device=nothing, active_type="", drop_rate=0., coeff=nothing)
    this = new()
    this.get_input_layer = function(input_index)
      return globals.g_layer_map[this.config.inputs[input_index].input_layer_name]
    end
    this.set_layer_height_width = function(height, width)
          this.config.height = height
          this.config.width = width
    end

    this.create_input_parameter = function(input_index, size, dims=nothing, sparse=nothing, format=nothing)
      if dims == nothing
        dims = []
      end

      if size == 0
        return
      end

      input_config = this.inputs[input_index]

      globals.set_field!(this.config.inputs[input_index], :input_parameter_name, input_config.locals["parameter_name"])
      if in(globals.g_parameter_map, input_config.locals["parameter_name"])
        return
      end

      temp_device = nothing
      if globals.has_field(this.config, :device)
        temp_device = this.config.device
      end

      Parameter(
              input_config.locals["parameter_name"],
              size,
              temp_device,
              dims,
              learning_rate = input_config.locals["learning_rate"],
              momentum = input_config.locals["momentum"],
              decay_rate=input_config.locals["decay_rate"],
              decay_rate_l1=input_config.locals["decay_rate_l1"],
              initial_mean=input_config.locals["initial_mean"],
              initial_std=input_config.locals["initial_std"],
              initial_strategy=input_config.locals["initial_strategy"],
              initial_smart=input_config.locals["initial_smart"],
              num_batches_regularization=input_config.locals["num_batches_regularization"],
              sparse_remote_update=input_config.locals["sparse_remote_update"],
              sparse_update=input_config.locals["sparse_update"],
              gradient_clipping_threshold=input_config.locals["gradient_clipping_threshold"],
              sparse=sparse,
              format=format,
              is_static=input_config.locals["is_static"],
              is_shared=input_config.locals["is_shared"],
              update_hooks=input_config.locals["update_hooks"])

    end

    this.create_bias_parameter = function(bias, size, dims = nothing, for_self = true)
      if size == 0
          return
      end
      if dims == nothing
          dims = [1, size]
      end

      if typeof(bias) == Bool
          if bias
              bias = Bias()
          end
      end

      if typeof(bias) == Bias
          if bias.locals["parameter_name"] == nothing
              bias.locals["parameter_name"] = "_" * this.config.name * ".wbias"
          end
          if !in(globals.g_parameter_map, bias.locals["parameter_name"])

            temp_device = nothing
            if globals.has_field(this.config, :device)
              temp_device = this.config.device
            end
            Parameter(
                bias.locals["parameter_name"],
                size,
                temp_device,
                dims,
                learning_rate=bias.locals["learning_rate"],
                momentum=bias.locals["momentum"],
                decay_rate=bias.locals["decay_rate"],
                decay_rate_l1=bias.locals["decay_rate_l1"],
                initial_mean=bias.locals["initial_mean"],
                initial_std=bias.locals["initial_std"],
                initial_strategy=bias.locals["initial_strategy"],
                initial_smart=bias.locals["initial_smart"],
                num_batches_regularization=bias.locals["num_batches_regularization"],
                sparse_remote_update=bias.locals["sparse_remote_update"],
                gradient_clipping_threshold=bias.locals["gradient_clipping_threshold"],
                is_static=bias.locals["is_static"],
                is_shared=bias.locals["is_shared"] )
          end
          if for_self
              globals.set_field!(this.config, :bias_parameter_name, bias.locals["parameter_name"])
          else
              return bias.locals["parameter_name"]
          end
      end
    end

    name = MakeLayerNameInSubmodel(name) #verify
    this.inputs = deepcopy(inputs)
    this.operators = []

    if this.inputs == nothing
      this.inputs = []
    elseif !isa(this.inputs, Array)
      this.inputs = [this.inputs]
    end
    this.inputs = Array{Any}(this.inputs)


    this.config = globals.LayerConfig()

    globals.fillset(globals.g_config.model_config, :layers)    
    globals.add_field!(globals.g_config.model_config, :layers, this.config)

    globals.set_field!(this.config, :name, name)
    globals.set_field!(this.config, :_type, Type)
    globals.set_field!(this.config, :active_type, active_type)

    if coeff != nothing
      globals.set_field!(this.config, :coeff, Float64(coeff))
    end

    if size != 0
      globals.set_field!(this.config, :size, UInt64(size))
    end

    if drop_rate != 0
      globals.set_field!(this.config, :drop_rate, drop_rate)
    end

    if device != nothing
      globals.set_field!(this.config, :device, device)
    elseif globals.g_default_device != nothing
      globals.set_field!(this.config, :device, globals.g_default_device)
    end

    globals.set_field!(this.config, :inputs, Array{globals.LayerInputConfig, 1}([]) )
    for input_index in 1:length(this.inputs)
      input = this.inputs[input_index]
      input_config = nothing
      input_layer_name = ""

      p_name = "_" * name * ".w" * string(input_index)
      if isa(input, AbstractString)
          input_layer_name = input
          input_config = Input(
              input,
              Dict("parameter_name"=>p_name))
          input_layer_name = input_config.input_layer_name
      elseif isa(input, Input)
        input_layer_name = input.input_layer_name
        input_config = input
        if input_config.locals["parameter_name"] == nothing
          input_config.locals["parameter_name"] = p_name
        end
      elseif isa(input, Operator)
        push!(this.operators, input)

        globals.fillset(input.operator_conf, :input_indices)    
        globals.add_field!(input.operator_conf, :input_indices, input_index)
        input_config = Input(input.input_layer_name[1])
        input_layer_name = input_config.input_layer_name
      end

      this.inputs[input_index] = input_config

      # layer_input = self.config.inputs.add()
      layer_input = globals.LayerInputConfig()

      globals.fillset(this.config, :inputs)    
      globals.add_field!(this.config, :inputs, layer_input)

      globals.set_field!(layer_input, :input_layer_name, input_config.input_layer_name)

      if input_config.locals["input_layer_argument"] != nothing #add locals dictionary to Operator class
          globals.set_field!(layer_input, :input_layer_argument, input_config.locals["input_layer_argument"])
      end
    end
    globals.g_layer_map[name] = this.config
    #globals.g_current_submodel.layer_names.append(this.config.name)

    globals.fillset(globals.g_current_submodel, :layer_names)    
    globals.add_field!(globals.g_current_submodel, :layer_names, this.config.name)

    if this.config._type != "data" && globals.g_pass_height_width
          height = this.get_input_layer(1).height
          width = this.get_input_layer(1).width
          if height != nothing && height != 0 && width != nothing && width != 0
              this.set_layer_height_width(height, width)
          end
    end

    return this
  end

end

#layerbase = LayerBase("name", "type",5, "name", 3, "qwuihiusksa", 0.25, 956)




#for trying
#globals.g_config_funcs["TST"] = "asdf"
#eval(globals, :(g_add_submodel_suffix = true))
