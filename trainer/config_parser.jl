include(dirname(Base.source_path()) * "/globals.jl")
using globals


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


function Inputs()
  deco_config_func(NoDecoInputs, "Inputs")
end


function deco_config_func(func, name)
  globals.g_config_funcs[name] = func
  return func
end


function NoDecoHasInputsSet()
  length(globals.g_current_submodel.input_layer_name) != 0
end

function HasInputsSet()
  deco_config_func(NoDecoHasInputsSet, "HasInputsSet")
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

function Outputs()
  deco_config_func(NoDecoOutputs, "Outputs")
end
