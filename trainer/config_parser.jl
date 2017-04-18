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
  if is(b, nothing)
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








#for trying
#globals.g_config_funcs["TST"] = "asdf"
#eval(globals, :(g_add_submodel_suffix = true))