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
    # logger.fata(msg)
    println(msg)
  end
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
  deco_config_func(NoDecoInputs, args, string(Inputs))
end


function deco_config_func(func, args, name)
  globals.g_config_funcs[name] = func
  if(is(args, nothing))
    return func()
  end
  return func(args)
end


function NoDecoHasInputsSet()
  length(globals.g_current_submodel.input_layer_name) != 0
end

function HasInputsSet()
  deco_config_func(NoDecoHasInputsSet, nothing, string(HasInputsSet))
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
  deco_config_func(NoDecoOutputs, args, string(Outputs))
end



globals.g_config_funcs["TST"] = "asdf"
eval(globals, :(g_add_submodel_suffix = true))