# def MakeLayerNameInSubmodel(name, submodel_name=None):
#     global g_current_submodel
#     global g_add_submodel_suffix
#     if (submodel_name is None and not g_add_submodel_suffix and
#             not g_current_submodel.is_recurrent_layer_group):
#         return name
#     if submodel_name is None:
#         submodel_name = g_current_submodel.name
#     return name + "@" + submodel_name
#
# # Check a condition derived config file
# def config_assert(b, msg):
#     if not b:
#         logger.fatal(msg)
#
# # Initialize global variables. We use this function so that we can
# # call parse_config() multiple times
# def init_config_environment(
#         g_default_momentum=None,
#         g_default_decay_rate=None,
#         g_default_initial_mean=0.,
#         g_default_initial_std=0.01,
#         g_default_num_batches_regularization=None,
#         g_default_initial_strategy=0,
#         g_default_initial_smart=False,
#         g_default_gradient_clipping_threshold=None,
#         g_default_device=None,
#         g_default_update_hooks=None,
#         g_default_compact_func=None,
#         g_config=TrainerConfig(),
#         g_layer_map={},
#         g_parameter_map={},
#         g_extended_config_funcs={},
#
#         # store command args of paddle_trainer
#         g_command_config_args={},
#
#         # Used for PyDataProvider to avoid duplicate module name
#         g_py_module_name_list=[],
#         g_current_submodel=None,
#         g_root_submodel=None,
#         g_submodel_map={},
#         g_submodel_stack=[],
#         g_add_submodel_suffix=False, ):
#
#     for k, v in locals().iteritems():
#         globals()[k] = copy.deepcopy(v)




module globals
  # These includes are topologically sorted
  proto_path = dirname(Base.source_path()) * "/../proto.jl/"
  println(proto_path)
  include(proto_path * "DataConfig_pb.jl")
  include(proto_path * "ParameterConfig_pb.jl")
  include(proto_path * "ModelConfig_pb.jl")
  include(proto_path * "TrainerConfig_pb.jl")

  import Base.deepcopy


  g_default_momentum=nothing
  g_default_decay_rate=nothing
  g_default_initial_mean=0.0
  g_default_initial_std=0.01
  g_default_num_batches_regularization=nothing
  g_default_initial_strategy=0
  g_default_initial_smart=false
  g_default_gradient_clipping_threshold=nothing
  g_default_device=nothing
  g_default_update_hooks=nothing
  g_default_compact_func=nothing
  g_config=TrainerConfig()
  g_layer_map=Dict()
  g_parameter_map=Dict()
  g_extended_config_funcs=Dict()

  # store command args of paddle_trainer
  g_command_config_args=Dict()

  # Used for PyDataProvider to avoid duplicate module name
  g_py_module_name_list=[]
  g_current_submodel=nothing
  g_root_submodel=nothing
  g_submodel_map=Dict()
  g_submodel_stack=[]
  g_add_submodel_suffix=false

  function init_config_environment(
  default_momentum=nothing,
  default_decay_rate=nothing,
  default_initial_mean=0.0,
  default_initial_std=0.01,
  default_num_batches_regularization=nothing,
  default_initial_strategy=0,
  default_initial_smart=false,
  default_gradient_clipping_threshold=nothing,
  default_device=nothing,
  default_update_hooks=nothing,
  default_compact_func=nothing,
  config=TrainerConfig,
  layer_map=Dict(),
  parameter_map=Dict(),
  extended_config_funcs=Dict(),
  command_config_args=Dict(),
  py_module_name_list=[],
  current_submodel=nothing,
  root_submodel=nothing,
  submodel_map=Dict(),
  submodel_stack=[],
  add_submodel_suffix=false)

  #Parameter Assignments
    g_default_momentum                     =deepcopy(default_momentum)
    g_default_decay_rate                   =deepcopy(default_decay_rate)
    g_default_initial_mean                 =deepcopy(default_initial_mean)
    g_default_initial_std                  =deepcopy(default_initial_std)
    g_default_num_batches_regularization   =deepcopy(default_num_batches_regularization)
    g_default_initial_strategy             =deepcopy(default_initial_strategy)
    g_default_initial_smart                =deepcopy(default_initial_smart)
    g_default_gradient_clipping_threshold  =deepcopy(default_gradient_clipping_threshold)
    g_default_device                       =deepcopy(default_device)
    g_default_update_hooks                 =deepcopy(default_update_hooks)
    g_default_compact_func                 =deepcopy(default_compact_func)
    g_config                               =deepcopy(config)
    g_layer_map                            =deepcopy(layer_map)
    g_parameter_map                        =deepcopy(parameter_map)
    g_extended_config_funcs                =deepcopy(extended_config_funcs)
    g_command_config_args                  =deepcopy(command_config_args)
    g_py_module_name_list                  =deepcopy(py_module_name_list)
    g_current_submodel                     =deepcopy(current_submodel)
    g_root_submodel                        =deepcopy(root_submodel)
    g_submodel_map                         =deepcopy(submodel_map)
    g_submodel_stack                       =deepcopy(submodel_stack)
    g_add_submodel_suffix                  =deepcopy(add_submodel_suffix)
    end
  end
end
