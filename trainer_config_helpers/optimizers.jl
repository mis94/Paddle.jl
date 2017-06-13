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
                #TODO default_momentum(self.momentum)
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
                    #TODO default_decay_rate(self.decay_rate)
                end
            end

            return this
        end
    end

    type ModelAverage <: Optimizer
        average_window
        max_average_window
        do_average_in_cpu
        extra_settings::Function
        to_setting_kwargs::Function

        function ModelAverage(average_window,
                     max_average_window=nothing,
                     do_average_in_cpu=false)
            this = new()
            this.average_window = average_window
            this.max_average_window = max_average_window
            this.do_average_in_cpu = do_average_in_cpu

            this.to_setting_kwargs = function ()
                return Dict(
                    "average_window" => this.average_window,
                    "max_average_window" => this.max_average_window,
                    "do_average_in_cpu" => this.do_average_in_cpu
                )
            end

            this.extra_settings = function ()
            end

            return this
        end
    end

    type GradientClippingThreshold <: Optimizer
        threshold
        extra_settings::Function
        to_setting_kwargs::Function

        function GradientClippingThreshold(threshold)
            this = new()
            this.threshold = threshold

            this.to_setting_kwargs = function ()
                return Dict()
            end

            this.extra_settings = function ()
                #TODO default_gradient_clipping_threshold(self.threshold)
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

    function basic_tests_Optimizer()
        # ================= ModelAverage =================
        x = ModelAverage(10, 20, true)
        println("avg: $(x.average_window), mx: $(x.max_average_window), do: $(x.do_average_in_cpu)")
        println(x.to_setting_kwargs())
        x.extra_settings()

        x = ModelAverage(10)
        println("avg: $(x.average_window), mx: $(x.max_average_window), do: $(x.do_average_in_cpu)")
        println(x.to_setting_kwargs())
        x.extra_settings()
        println("\n =========================== \n")

        # ================= GradientClippingThreshold =================
        x = GradientClippingThreshold(10)
        println("threshold: $(x.threshold)")
        println(x.to_setting_kwargs())
        x.extra_settings()
    end
    function extends(dict1, dict2)
        for kv in dict2
            dict1[kv[1]] = kv[2]
        end
        return dict1;
    end

    function settings(batch_size;
                 learning_rate=1e-3,
                 learning_rate_decay_a=0.0,
                 learning_rate_decay_b=0.0,
                 learning_rate_schedule="poly",
                 learning_rate_args="",
                 learning_method=nothing,
                 regularization=nothing,
                 is_async=false,
                 model_average=nothing,
                 gradient_clipping_threshold=nothing)
        
        if isa(regularization, BaseRegularization)
            regularization = [regularization]
        end

        @assert isa(learning_method, Optimizer)        
        if isa(learning_method, BaseSGDOptimizer)
            algorithm = is_async ? "async_sgd" : "sgd"
        else
            algorithm = "owlqn"
        end

        kwargs = Dict()
        kwargs["algorithm"] = algorithm
        kwargs["batch_size"] = batch_size
        kwargs["learning_rate"] = learning_rate
        kwargs["learning_rate_decay_a"] = learning_rate_decay_a
        kwargs["learning_rate_decay_b"] = learning_rate_decay_b
        kwargs["learning_rate_schedule"] = learning_rate_schedule
        kwargs["learning_rate_args"] = learning_rate_args
        kwargs = extends(kwargs, learning_method.to_setting_kwargs())
        learning_method.extra_settings()

        for regular in regularization
            @assert isa(regular, BaseRegularization)
            regular.algorithm = algorithm
            regular.learning_method = kwargs["learning_method"]
            kwargs = extends(kwargs, regular.to_setting_kwargs())
            regular.extra_settings()
        end

        if gradient_clipping_threshold != nothing
            gradient_clipping_threshold = GradientClippingThreshold(
            threshold=gradient_clipping_threshold)
        end

        for each in [model_average, gradient_clipping_threshold]
            if each != nothing
                @assert isa(each, Optimizer)
                each.algorithm = algorithm
                each.learning_method = kwargs["learning_method"]
                kwargs = extends(kwargs, each.to_setting_kwargs())
                each.extra_settings()
            end
        end
    end

settings(10, learning_method=AdamOptimizer(), regularization = L2Regularization(0.5))