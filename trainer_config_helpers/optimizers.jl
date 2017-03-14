# optimizers file
abstract Optimizer

abstract BaseSGDOptimizer <: Optimizer

type MomentumOptimizer <: BaseSGDOptimizer
    momentum
    sparse
    extra_settings::Function
    to_setting_kwargs::Function
    #TODO is_support_sparse::Function
    #TODO explicitely state types?
    

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


type AdamOptimizer <: BaseSGDOptimizer
    beta1
    beta2
    epsilon
    extra_settings::Function
    to_setting_kwargs::Function
    #TODO is_support_sparse::Function
    function AdamOptimizer(beta1=0.9, beta2=0.999, epsilon=1e-8)
        this = new()
        this.beta1 = beta1
        this.beta2 = beta2
        this.epsilon = epsilon
        this.extra_settings = function ()
        end

        this.to_setting_kwargs = function()
            return Dict("learning_method" => "adam",
                        "adam_beta1" => this.beta1,
                        "adam_beta2" => this.beta2,
                        "adam_epsilon" => this.epsilon)
        end
    
        return this
    end
end

#TODO delete this
function basic_tests()
    # ================= MomentumOptimizer =================
    x = MomentumOptimizer(10, true)
    println("momentum: $(x.momentum), sparse: $(x.sparse)")
    x.extra_settings()
    println(x.to_setting_kwargs()["learning_method"])

    x = MomentumOptimizer()
    println("momentum: $(x.momentum), sparse: $(x.sparse)")
    println(x.to_setting_kwargs()["learning_method"])

    # ================= AdamOptimizer =================
    x = AdamOptimizer(10, 20, 30);
    println("beta1: $(x.beta1), beta2: $(x.beta2), epsilon: $(x.epsilon)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println(y["learning_method"])

    x = AdamOptimizer()
    println("beta1: $(x.beta1), beta2: $(x.beta2), epsilon: $(x.epsilon)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println(y["learning_method"])

    
end

basic_tests()