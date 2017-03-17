
abstract BaseActivation

type TanhActivation <: BaseActivation
  """
  Tanh activation.

  .. math::

     f(z)=tanh(z)=\\frac{e^z-e^{-z}}{e^z+e^{-z}}
  """

  name
  support_hppl

  function TanhActivation()
    this = new()
    this.name = "tanh"
    this.support_hppl = true
    return this
  end

end


type SigmoidActivation <: BaseActivation
  """
  Sigmoid activation.

  .. math::

     f(z) = \\frac{1}{1+exp(-z)}
  """

  name
  support_hppl

  function SigmoidActivation()
    this = new()
    this.name = "sigmoid"
    this.support_hppl = true
    return this
  end

end


type SoftmaxActivation <: BaseActivation
  """
  Softmax activation for simple input



  .. math::

     P(y=j|x) = \\frac{e^{x_j}} {\\sum^K_{k=1} e^{x_j} }
  """

  name
  support_hppl

  function SoftmaxActivation()
    this = new()
    this.name = "softmax"
    this.support_hppl = true
    return this
  end

end


type SequenceSoftmaxActivation <: BaseActivation
  """
  Softmax activation for one sequence. The dimension of input feature must be
  1 and a sequence.

  ..  code:: python

      result = softmax(for each_feature_vector[0] in input_feature)
      for i, each_time_step_output in enumerate(output):
          each_time_step_output = result[i]
  """

  name
  support_hppl

  function SequenceSoftmaxActivation()
    this = new()
    this.name = "sequence_softmax"
    this.support_hppl = true
    return this
  end

end


type IdentityActivation <: BaseActivation
  """
  Identity Activation.

  Just do nothing for output both forward/backward.
  """

  name
  support_hppl

  function IdentityActivation()
    this = new()
    this.name = ""
    this.support_hppl = true
    return this
  end

end


type ReluActivation <: BaseActivation
  """
  Relu activation.

  forward. :math:`y = max(0, z)`

  derivative:

  .. math::

     1  &\\quad if z > 0 \\\\
     0  &\\quad\\mathrm{otherwize}
  """

  name
  support_hppl

  function ReluActivation()
    this = new()
    this.name = "relu"
    this.support_hppl = true
    return this
  end

end


type BReluActivation <: BaseActivation
  """
  BRelu Activation.

  forward.  :math:`y = min(24, max(0, z))`

  derivative:

  .. math::

     1  &\\quad if 0 < z < 24 \\\\
     0  &\\quad \\mathrm{otherwise}
  """

  name
  support_hppl

  function BReluActivation()
    this = new()
    this.name = "brelu"
    this.support_hppl = true
    return this
  end

end


type SoftReluActivation <: BaseActivation

  name
  support_hppl

  function SoftReluActivation()
    this = new()
    this.name = "softrelu"
    this.support_hppl = true
    return this
  end

end


type STanhActivation <: BaseActivation
  """
  Scaled Tanh Activation.

  .. math::

     f(z) = 1.7159 * tanh(2/3*z)
  """

  name
  support_hppl

  function STanhActivation()
    this = new()
    this.name = "stanh"
    this.support_hppl = true
    return this
  end

end


type AbsActivation <: BaseActivation
  """
  Abs Activation.

  Forward:    :math:`f(z) = abs(z)`

  Derivative:

  .. math::

     1 &\\quad if \\quad z > 0 \\\\
     -1 &\\quad if \\quad z < 0 \\\\
     0 &\\quad if \\quad z = 0
  """

  name
  support_hppl

  function AbsActivation()
    this = new()
    this.name = "abs"
    this.support_hppl = true
    return this
  end

end


type SquareActivation <: BaseActivation
  """
  Square Activation.

  .. math::
     f(z) = z^2.
  """

  name
  support_hppl

  function SquareActivation()
    this = new()
    this.name = "square"
    this.support_hppl = true
    return this
  end

end


type ExpActivation <: BaseActivation
  """
  Exponential Activation.

  .. math::
     f(z) = e^z.
  """

  name
  support_hppl

  function ExpActivation()
    this = new()
    this.name = "exponential"
    this.support_hppl = true
    return this
  end

end


type LogActivation <: BaseActivation
  """
  Logarithm Activation.

  .. math::
     f(z) = log(z)
  """

  name
  support_hppl

  function LogActivation()
    this = new()
    this.name = "log"
    this.support_hppl = true
    return this
  end

end
