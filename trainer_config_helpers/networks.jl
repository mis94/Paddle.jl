# def inputs(layers, *args):
    # """
    # Declare the inputs of network. The order of input should be as same as
    # the data provider's return order.
    #
    # :param layers: Input Layers.
    # :type layers: list|tuple|LayerOutput.
    # :return:
    # """
#
#     if isinstance(layers, LayerOutput) or isinstance(layers, basestring):
#         layers = [layers]
#     if len(args) != 0:
#         layers.extend(args)
#
#     Inputs(*[l.name for l in layers])


"""
Declare the inputs of network. The order of input should be as same as
the data provider's return order.
#TODO change args to julia markup
:param layers: Input Layers.
:type layers: list|tuple|LayerOutput.
:return:
"""
function inputs(layers, args...)
  # This is not working :/
  # if is(layers, LayerOutput) || is(layers, basestring)
  #   layers = [layers]
  # end
  if typeof(layers) == LayerOutput || typeof(layer) == String
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
