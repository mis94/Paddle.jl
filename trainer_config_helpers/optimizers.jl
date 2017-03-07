# optimizers file
abstract Optimizer

abstract BaseSGDOptimizer <: Optimizer

type MomentumOptimizer <: BaseSGDOptimizer
    extra_settings::Function
    to_setting_kwargs::Function
    #TODO is_support_sparse::Function
    #TODO explicitely state types?
    momentum
    sparse

    function MomentumOptimizer(momentum = nothing, sparse = false)
        this = new()
        
        this.momentum = momentum
        this.sparse = sparse

        this.extra_settings = function ()
            #TODO call default_momentum function in config_parser file
        end

        this.to_setting_kwargs = function ()
            if sparse
                Dict("learning_method" => "sparse_momentum")
            else
                Dict("learning_method" => "momentum")
            end
        end

        return this
    end
end

#TODO delete this
function momentumoptimizer_basic_tests()
    x = MomentumOptimizer(10, true)
    println("momentum: $(x.momentum), sparse: $(x.sparse)")
    x.extra_settings()
    println(x.to_setting_kwargs()["learning_method"])

    x = MomentumOptimizer()
    println("momentum: $(x.momentum), sparse: $(x.sparse)")
    println(x.to_setting_kwargs()["learning_method"])
end

basic_tests()