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


type AdamxOptimizer <: BaseSGDOptimizer
    beta1
    beta2
    extra_settings::Function
    to_setting_kwargs::Function
    #TODO is_support_sparse::Function
    function AdamxOptimizer(beta1, beta2)
        this = new()
        this.beta1 = beta1
        this.beta2 = beta2
        this.extra_settings = function ()
        end

        this.to_setting_kwargs = function()
            return Dict("learning_method" => "adamx",
                        "adam_beta1" => this.beta1,
                        "adam_beta2" => this.beta2)
        end
    
        return this
    end
end

type AdaGradOptimizer <: BaseSGDOptimizer
    extra_settings::Function
    to_setting_kwargs::Function
    #TODO is_support_sparse::Function
    function AdaGradOptimizer()
        this = new()
        this.extra_settings = function ()
        end

        this.to_setting_kwargs = function()
            return Dict("learning_method" => "adagrad")
        end
    
        return this
    end
end


type RMSPropOptimizer <: BaseSGDOptimizer
    rho
    epsilon
    extra_settings::Function
    to_setting_kwargs::Function
    #TODO is_support_sparse::Function
    function RMSPropOptimizer(rho=0.95, epsilon=1e-6)
        this = new()
        this.rho = rho
        this.epsilon = epsilon
        this.extra_settings = function ()
        end

        this.to_setting_kwargs = function()
            return Dict("learning_method" => "rmsprop",
                        "ada_rou" => this.rho,
                        "ada_epsilon" => this.epsilon)
        end
    
        return this
    end
end

type DecayedAdaGradOptimizer <: BaseSGDOptimizer
    rho
    epsilon
    extra_settings::Function
    to_setting_kwargs::Function
    #TODO is_support_sparse::Function
    function DecayedAdaGradOptimizer(rho=0.95, epsilon=1e-6)
        this = new()
        this.rho = rho
        this.epsilon = epsilon
        this.extra_settings = function ()
        end

        this.to_setting_kwargs = function()
            return Dict("learning_method" => "decayed_adagrad",
                        "ada_rou" => this.rho,
                        "ada_epsilon" => this.epsilon)
        end
    
        return this
    end
end

type AdaDeltaOptimizer <: BaseSGDOptimizer
    rho
    epsilon
    extra_settings::Function
    to_setting_kwargs::Function
    #TODO is_support_sparse::Function
    function AdaDeltaOptimizer(rho=0.95, epsilon=1e-6)
        this = new()
        this.rho = rho
        this.epsilon = epsilon
        this.extra_settings = function ()
        end

        this.to_setting_kwargs = function()
            return Dict("learning_method" => "adadelta",
                        "ada_rou" => this.rho,
                        "ada_epsilon" => this.epsilon)
        end
        
        return this
    end
end

abstract BaseRegularization <: Optimizer

type L2Regularization <: BaseRegularization
    algorithm
    learning_method
    decay_rate
    extra_settings::Function
    to_setting_kwargs::Function

    function L2Regularization(rate)
        this = new()
        this.algorithm = ""
        this.learning_method = ""
        this.decay_rate = rate
        this.to_setting_kwargs = function ()
            if this.algorithm == "owlqn"
                return Dict("l2weight" => this.decay_rate)
            else
                return Dict()
            end
        end

        this.extra_settings = function ()
            if this.algorithm == "sgd" || this.algorithm == "async_sgd"
                #TODO call default_decay_rate function in config_parser file
            end
        end

        return this
    end
end

#TODO delete this
function basic_tests_BaseSGDOptimizer()
    # ================= MomentumOptimizer =================
    x = MomentumOptimizer(10, true)
    println("momentum: $(x.momentum), sparse: $(x.sparse)")
    x.extra_settings()
    println(x.to_setting_kwargs()["learning_method"])

    x = MomentumOptimizer()
    println("momentum: $(x.momentum), sparse: $(x.sparse)")
    println(x.to_setting_kwargs()["learning_method"])
    println("\n =========================== \n")

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
    println("\n =========================== \n")
    
    # ================= AdamaxOptimizer =================
    x = AdamxOptimizer(10, 20);
    println("beta1: $(x.beta1), beta2: $(x.beta2)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println(y["learning_method"])
    println("\n =========================== \n")

    # ================= AdaGradOptimizer =================
    x = AdaGradOptimizer();
    println("AdaGradOptimizer: OK!")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println(y["learning_method"])
    println("\n =========================== \n")

    # ================= RMSPropOptimizer =================
    x = RMSPropOptimizer(10, 20);
    println("rho: $(x.rho), epsilon: $(x.epsilon)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println("$(y["learning_method"]), $(y["ada_rou"]), $(y["ada_epsilon"])")

    x = RMSPropOptimizer();
    println("rho: $(x.rho), epsilon: $(x.epsilon)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println("$(y["learning_method"]), $(y["ada_rou"]), $(y["ada_epsilon"])")
    println("\n =========================== \n")

    # ================= DecayedAdaGradOptimizer =================
    x = DecayedAdaGradOptimizer(10, 20);
    println("rho: $(x.rho), epsilon: $(x.epsilon)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println("$(y["learning_method"]), $(y["ada_rou"]), $(y["ada_epsilon"])")

    x = DecayedAdaGradOptimizer();
    println("rho: $(x.rho), epsilon: $(x.epsilon)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println("$(y["learning_method"]), $(y["ada_rou"]), $(y["ada_epsilon"])")
    println("\n =========================== \n")

    # ================= AdaDeltaOptimizer =================
    x = AdaDeltaOptimizer(10, 20);
    println("rho: $(x.rho), epsilon: $(x.epsilon)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println("$(y["learning_method"]), $(y["ada_rou"]), $(y["ada_epsilon"])")

    x = AdaDeltaOptimizer();
    println("rho: $(x.rho), epsilon: $(x.epsilon)")
    x.extra_settings()
    y = x.to_setting_kwargs()
    println("$(y["learning_method"]), $(y["ada_rou"]), $(y["ada_epsilon"])")
    
end

function basic_tests_BaseRegularization()
    # ================= L2Regularization =================
    x = L2Regularization(0.5)
    println("algorithm: $(x.algorithm), learning_method: $(x.learning_method), rate: $(x.decay_rate)")
    x.algorithm = "owlqn"
    y = x.to_setting_kwargs()
    println(y["l2weight"])
end
basic_tests_BaseRegularization()