using PyCall
@pyimport py_paddle.swig_paddle as api

function parseProtoObject(path, obj)
 
    protoObj = PipeBuffer()
    globals.writeproto(protoObj, obj)

    open(path, "w") do f
        write(f, protoObj)
     end
     return path
end

type GradientMachine

    swigNetwork

    createFromConfigProto::Function
    forwardTest::Function
    loadParameters::Function

    function GradientMachine()
        this = new()
        this.createFromConfigProto = function(path)
            #for i in 0: 999999999999
            #    varr = 1
            #end
            #if varr
            this.swigNetwork =  api.GradientMachine[:createFromConfigProto](path)          
            return this.swigNetwork
        end

        this.forwardTest = function(input)
            this.swigNetwork[:forwardTest](input)
        end

        this.loadParameters = function(model_dir)
            this.swigNetwork[:loadParameters](model_dir)
        end

        return this
    end
    
end

type Trainer

    swigTrainer

    create::Function
    startTrain::Function
    startTrainPass::Function
    trainOneDataBatch::Function
    finishTrainPass::Function
    startTestPeriod::Function
    testOneDataBatch::Function
    finishTestPeriod::Function
    finishTrain::Function

    function Trainer()
        this = new()
        this.create = function(path, model)
            this.swigTrainer = api.Trainer[:create](path, model)
            return this.swigTrainer
        end

        this.startTrain = function()
            this.swigTrainer[:startTrain]()
        end

        this.startTrainPass= function()
            this.swigTrainer[:startTrainPass]()
        end

        this.trainOneDataBatch= function(size, converter)
            this.swigTrainer[:trainOneDataBatch](size, converter)
        end

        this.finishTrainPass= function()
            this.swigTrainer[:finishTrainPass]()
        end

        this.startTestPeriod= function()
            this.swigTrainer[:startTestPeriod]()
        end

        this.testOneDataBatch = function(size, converter)
            this.swigTrainer[:testOneDataBatch](size, converter)
        end

        this.finishTestPeriod= function()
            this.swigTrainer[:finishTestPeriod]()
        end

        this.finishTrain= function()
            this.swigTrainer[:finishTrain]()
        end

        return this
    end
        
end