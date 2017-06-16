#include("config_parser.jl")

function convert_and_compare(x, Type)
  """
  Convert x to be the same type as Type and then convert back to
  check whether there is a loss of information
  :param x: object to be checked
  :param Type: target type to check x over

  """
convert(typeof(x) ,convert(Type, x)) == x
end

function is_compatible_with(x, Type)
  """
  Check if x has a type compatible with Type
  :param x: object to be checked
  :param Type: target type to check x over

  """
  if typeof(x) == Type
    return true
  end

  try
    if AbstractFloat == Type || Int == Type
    # avoid those types that can be converted to float/int but not very
    # meaningful and  could potentially lead to error
    # i.e., str and bool typed value should not be used for initializing float/int variable
      if typeof(x) != String && typeof(x) == Bool
        return convert_and_compare(x, Type)
      end
    elseif Bool == Type
      # should not use string type to initialize bool variable
      if typeof(x) != String
        return convert_and_compare(x, Type)
      end
    else
      return false
    end
  catch e
    println(typeof(e))
  end

  return false
end

type ParameterAttribute
  """
  Parameter Attributes object. To fine-tuning network training process, user
  can set attribute to control training details, such as l1,l2 rate / learning
  rate / how to init param.

  NOTE: IT IS A HIGH LEVEL USER INTERFACE.

  :param is_static: True if this parameter will be fixed while training.
  :type is_static: bool

  :param initial_std: Gauss Random initialization standard deviation.
                      None if not using Gauss Random initialize parameter.
  :type initial_std: float or None
  :param initial_mean:  Gauss Random initialization mean.
                       None if not using Gauss Random initialize parameter.
  :type initial_mean: float or None
  :param initial_max: Uniform initialization max value.
  :type initial_max: float or None
  :param initial_min: Uniform initialization min value.
  :type initial_min: float or None
  :param l1_rate: the l1 regularization factor
  :type l1_rate: float or None
  :param l2_rate: the l2 regularization factor
  :type l2_rate: float or None
  :param learning_rate: The parameter learning rate. None means 1.
                        The learning rate when optimize is LEARNING_RATE =
                        GLOBAL_LEARNING_RATE * PARAMETER_LEARNING_RATE
                        * SCHEDULER_FACTOR.

  :type learning_rate: float or None
  :param momentum: The parameter momentum. None means use global value.
  :type momentum: float or None
  :param gradient_clipping_threshold: gradient clipping threshold. If gradient
                                      value larger than some value, will be
                                      clipped.
  :type gradient_clipping_threshold: float
  :param sparse_update: Enable sparse update for this parameter. It will
                        enable both local and remote sparse update.
  :type sparse_update: bool
  """

  name
  is_static
  initial_std
  initial_mean
  initial_max
  initial_min
  l1_rate
  l2_rate
  learning_rate
  momentum
  gradient_clipping_threshold
  sparse_update
  attr

  function ParameterAttribute(name = nothing
                            , is_static = false
                            , initial_std = nothing
                            , initial_mean = nothing
                            , initial_max = nothing
                            , initial_min = nothing
                            , l1_rate = nothing
                            , l2_rate = nothing
                            , learning_rate = nothing
                            , momentum = nothing
                            , gradient_clipping_threshold = nothing
                            , sparse_update = false)

    this = new()

    # initialize strategy.
    if is_static
      this.attr = Dict()
      this.attr["is_static"] = true
    elseif initial_std == nothing && initial_mean == nothing && initial_max == nothing && initial_min == nothing
      this.attr = Dict()
      this.attr["initial_smart"] = true
    elseif is_compatible_with(initial_std, AbstractFloat) || is_compatible_with(initial_mean, AbstractFloat)
      this.attr = Dict()
      if initial_std != nothing
        this.attr["initial_std"] = initial_std
      end
      if initial_mean != nothing
        this.attr["initial_mean"] = initial_mean
      end
      this.attr["initial_strategy"] = 0
      # Gauss Random
    elseif is_compatible_with(initial_max, AbstractFloat) && is_compatible_with(initial_min, AbstractFloat)
      this.initial_max = initial_max
      this.initial_min = initial_min

      @assert initial_max < initial_min

      this.initial_mean = (initial_max + initial_min) / 2
      this.initial_std = initial_mean - initial_min

      this.attr = dict()
      this.attr["initial_mean"] = initial_mean
      this.attr["initial_std"] = initial_std
      this.attr["initial_strategy"] = 1  # Uniform Random
    else
      throw(ArgumentError("Unexpected branch."))
    end

    if is_static == false && is_compatible_with(l1_rate, AbstractFloat)
      this.attr["decay_rate_l1"] = l1_rate
    end

    if is_static == false && is_compatible_with(l2_rate, AbstractFloat)
      this.attr["decay_rate"] = l2_rate
    end

    if is_static == false && is_compatible_with(learning_rate, AbstractFloat)
      this.attr["learning_rate"] = learning_rate
    end

    if is_static == false && is_compatible_with(momentum, AbstractFloat)
      this.attr["momentum"] = momentum
    end

    if name != nothing
      this.attr["parameter_name"] = name
    end

    if sparse_update
      this.attr["sparse_update"] = true
      this.attr["sparse_remote_update"] = true
    end

    if gradient_clipping_threshold != nothing && is_compatible_with(gradient_clipping_threshold, AbstractFloat)
      this.attr["gradient_clipping_threshold"] = gradient_clipping_threshold
    end
    return this
  end

  function set_default_parameter_name(name)
    """
    Set default parameter name. If parameter not set, then will use default
    parameter name.


    :param name: default parameter name.
    :type name: basestring
    """
    if haskey(this.attr, "parameter_name") == false
      this.attr["parameter_name"] = name
    end
  end

end

type ExtraLayerAttribute
  """
  Some high level layer attributes config. You can set all attributes here,
  but some layer doesn"t support all attributes. If you set an attribute to a
  layer that not support this attribute, paddle will print an error and core.

  :param error_clipping_threshold: Error clipping threshold.
  :type error_clipping_threshold: float
  :param drop_rate: Dropout rate. Dropout will create a mask on layer output.
                    The dropout rate is the zero rate of this mask. The
                    details of what dropout is please refer to `here
                    <https://www.cs.toronto.edu/~hinton/absps/
                    JMLRdropout.pdf>`_.
  :type drop_rate: float
  :param device: device ID of layer. device=-1, use CPU. device>0, use GPU.
                 The details allocation in parallel_nn please refer to `here
                 <http://www.paddlepaddle.org/doc/ui/cmd_argument/
                 use_case.html#case-2-specify-layers-in-different-devices>`_.
  :type device: int
  """

  error_clipping_threshold
  drop_rate
  device
  attr
  attributesSet::Set{String}

  function ExtraLayerAttribute( error_clipping_threshold = nothing
                              , drop_rate = nothing
                              , device = nothing)

    this = new()
    this.attr = Dict()
    this.attributesSet = Set{String}()


    if typeof(error_clipping_threshold) == AbstractFloat
      @assert error_clipping_threshold > 0
      this.attr["error_clipping_threshold"] = error_clipping_threshold
    end

    if typeof(drop_rate) == AbstractFloat
      @assert drop_rate > 0
      this.attr["drop_rate"] = drop_rate
    end

    if typeof(device) == Int
      @assert device > 0
      this.attr["device"] = device
    end

    return this
  end

  function check(layer_name)
    for key in attr
      if !in(key, attributesSet)
        error("Layer " * layer_name * " cannot support " * key)
      end
    end
  end

end

function to_bias(bias_attr)
  if typeof(bias_attr) == ParameterAttribute
    return Bias(bias_attr.attr)
  else
    return false
  end
end

function to_kwargs(attr)
  if attr == nothing
    return Dict()
  else
    return attr.attr
  end
end

ParamAttr = ParameterAttribute
ExtraAttr = ExtraLayerAttribute
