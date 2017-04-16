# # functions available in config file
#
#
# # Define the name of the input layers of the NeuralNetwork.
# # The type of these layers must be "data".
# # These layers will be provided with the DataBatch obtained
# # from DataProvider. The data streams from DataProvider must
# # have the same order.
# @config_func
# def Inputs(*args):
#     for name in args:
#         name = MakeLayerNameInSubmodel(name)
#         global g_current_submodel, g_root_submodel
#         if g_current_submodel.is_recurrent_layer_group:
#             config_assert(False, "Do not set Inputs in recurrent layer group")
#         else:
#             g_current_submodel.input_layer_names.append(name)
#
#         if g_current_submodel is g_root_submodel:
#             g_config.model_config.input_layer_names.append(name)
#
#
# @config_func
# def HasInputsSet():
#     return len(g_current_submodel.input_layer_names) != 0
#
#
# # Define the name of the output layers of the NeuralNetwork.
# # Usually the output is simply the cost layer.
# # You can specify other layers as outputs and calculate the
# # cost (and its derivative) yourself.
# @config_func
# def Outputs(*args):
#     for name in args:
#         name = MakeLayerNameInSubmodel(name)
#         global g_current_submodel, g_root_submodel
#         if g_current_submodel.is_recurrent_layer_group:
#             config_assert(False, "Do not set Outputs in recurrent layer group")
#         else:
#             g_current_submodel.output_layer_names.append(name)
#
#         if g_current_submodel is g_root_submodel:
#             g_config.model_config.output_layer_names.append(name)
