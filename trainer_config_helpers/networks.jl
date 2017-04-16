include(dirname(Base.source_path()) * "/../trainer/config_parser.jl")
using globals


"""
Declare the inputs of network. The order of input should be as same as
the data provider's return order.
#TODO change args to julia markup
:param layers: Input Layers.
:type layers: list|tuple|LayerOutput.
:return:
"""
function inputs(layers, args...)
  if isa(layers, LayerOutput) || isa(layer, String)
    layers = [layers]
  end

  if legnth(args) != 0
    for arg in args
      layers = vcat(layers, arg)
    end
  end

  names = []
  for layer in layers
    names = vcat(names, layer.name)
  end

  Inputs(names)
end




"""
Declare the outputs of network. If user have not defined the inputs of
network, this method will calculate the input order by dfs travel.

:param layers: Output layers.
:type layers: list|tuple|LayerOutput
:return:
"""
function outputs(layers, args...)
  function __dfs_travel__(layer, predicate = x -> x.layer_type == "data") #TODO: Change hardcoded "DATA" to LayerType.DATA
    @assert isa(layer, LayerOutput) @sprintf("layer is %s", layer)
    retv = []

    if layer.parents != nothing
      for p in layer.parents
        retv = vcat(__dfs_travel__(p, predicate))
      end
    end

    if predicate(layer)
      retv = vcat(retv, layer)
    end

    return retv
  end

  if isa(layers, LayerOutput)
    layers = [layers]
  end

  if length(args) != 0
    layers = vcat(layers, args)
  end

  @assert length(layers) > 0

  if HasInputsSet()
    names = []
    for layer in layers
      names = vcat(names, layer.name)
    end
    return
  end

  # if length(layers) != 1
  #   logger.warning("`outputs` routine try to calculate network's, inputs and outputs order. It might not work well. Please see follow log carefully.")
  # end

  inputs = []
  outputs = []

  for each_layer in layers
    @assert isa(each_layer, LayerOutput)
    inputs = vcat(inputs, __dfs_travel__(each_layer))
    outputs = vcat(outputs, __dfs_travel__(each_layer, x -> x.layer_type == "cost")) #TODO: Change hardcoded "COST" to LayerType.COST
  end

  final_inputs = []
  final_outputs =

  for each_input in inputs
    @assert isa(each_input, LayerOutput)
    if !(each_input.name in final_inputs)
      final_inputs = vcat(final_inputs, each_input.name)
    end
  end

  for each_out in outputs
    @assert isa(each_out, LayerOutput)
    if !(each_output.name in final_outputs)
      final_outputs = vcat(final_outputs, each_output.name)
    end
  end

  # logger.info("The input order is [" * join(final_inputs, ", ") * "]")

  if length(final_outputs) == 0
    final_outputs = map(x->x.name, layers)
  end

  # logger.info("The output order is [" * join(final_outputs, ", ") * "]")

  Inputs(final_inputs)
  Outputs(final_outputs)
end
