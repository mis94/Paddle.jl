#include("attrs.jl")
#include("activations.jl")

type DefaultNameFactory
    counter
    name_prefix
    reset::Function

    function DefaultNameFactory(name_prefix)
        this = new()

        this.counter = 0
        this.name_prefix = name_prefix

        this.reset = function()
            this.counter = 0
        end

        return this
    end
end

_name_factories = []

function reset_hook()
    for factory in _name_factories
        factory.reset()
    end
end

function wrap_name_default(name, name_prefix)
    factory = DefaultNameFactory(name_prefix)
    push!(_name_factories, factory)

    if isa(name, Void)
        name = "__" * join([factory.name_prefix, factory.counter], "_") * "__"
    else
        name = "__" * join([name, factory.counter], "_") * "__"
    end

    factory.counter += 1
    return name
end

function wrap_param_attr_default(param_attr)
    if isa(param_attr, Void)
        return ParamAttr()
    else
        return param_attr
    end
end

function wrap_bias_attr_default(bias_attr; has_bias=true)
    if has_bias && isa(bias_attr, Void)
        return ParamAttr(initial_std=0., initial_mean=0.)
    else
        return bias_attr
    end
end

function wrap_act_default(act)
    if isa(act, Void)
        return TanhActivation()
    else
        return act
    end
end