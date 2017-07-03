# Paddle.jl
A Julia wrapper for <a href="https://github.com/PaddlePaddle/Paddle">Paddle</a> deep learning library.

## How To Use
### Initialize PaddlePaddle 
api.initPaddle("--use_gpu=0", "--trainer_count=1") 
Initializing paddle process with some configurations.   

### Configuration Parsing 
trainer_config = parse_config("trainer_config.jl", "dict_file=PATH") 
Setting the configurations for both training and prediction process, using the  “trainer_config.jl” file which implemented also by the user of the interface   

### GradientMachine.createFromConfigProto 
model =  api.GradientMachine.createFromConfigProto(parseProtoObject(PATH,  trainer_config.model_config)) 
Serialize the model config proto object and save it to a file to be read by the  python code and deserialized so it can be passed to the C++ code. The  function returns the created GradientMachine object that will be used for the  creation of the training model. 
 
### Trainer.create 
api.Trainer.create(parseProtoObject(PATH, trainer_config), model) 
Serialize the trainer config proto object and save it to a file to be read by the  python code and desiralized so it can be passed to the C++ code. The  function returns the created Train object that will be used in the training  process.   

### Trainer.startTrain() 
trainer.startTrainPass() 
Marks the beginning of the training pass    

### Trainer.trainOneDataBatch 
trainer.trainOneDataBatch(size, converter.convert(batch)) 
Trains the neural network on the provided data that is converted into  Argument C++ class.  
Prints the training info    

### trainer.finishTrainPass 
trainer.finishTrainPass() 
Marks the ending of the training pass 
 
### Trainer.startTestPeriod 
trainer.startTestPeriod(size, converter.convert(batch)) 
Start test process    

### trainer.finishTestPeriod 
trainer.finishTestPeriod() 
Marks the ending of the test process 
