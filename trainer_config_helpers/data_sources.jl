"""
Data Sources are helpers to define paddle training data or testing data.
"""

include("default_decorators")
include("layers")
include("evaluators")
include("networks")
include("networks0")
include("optimizers")

function define_py_data_source(file_list, cls, _module, obj, args=nothing, async=False, data_cls=PyData):
  """
    Define a python data source.

    For example, the simplest usage in trainer_config.py as follow:

    ..  code-block:: python

        define_py_data_source("train.list", TrainData, "data_provider", "process")

    Or. if you want to pass arguments from trainer_config to data_provider.py, then

    ..  code-block:: python

        define_py_data_source("train.list", TrainData, "data_provider", "process",
                              args={"dictionary": dict_name})

    :param data_cls:
    :param file_list: file list name, which contains all data file paths
    :type file_list: basestring
    :param cls: Train or Test Class.
    :type cls: TrainData or TestData
    :param module: python module name.
    :type module: basestring
    :param obj: python object name. May be a function name if using
                PyDataProviderWrapper.
    :type obj: basestring
    :param args: The best practice is using dict to pass arguments into
                 DataProvider, and use :code:`@init_hook_wrapper` to
                 receive arguments.
    :type args: string or picklable object
    :param async: Load Data asynchronously or not.
    :type async: bool
    :return: nothing
    :rtype: nothing
    """

    if typeof(file_list) == list
      file_list_name = 'train.list'
      if is(cls, TestData)
        file_list_name = 'test.list'
      end
    end

    cls(
          data_cls(
              files=file_list,
              load_data_module=_module,
              load_data_object=obj,
              load_data_args=args,
              async_load_data=async))

end

function define_py_data_sources(train_list, test_list, _module, obj, args=nothing, train_async=False, data_cls=PyData):
    """
    The annotation is almost the same as define_py_data_sources2, except that
    it can specific train_async and data_cls.

    :param data_cls:
    :param train_list: Train list name.
    :type train_list: basestring
    :param test_list: Test list name.
    :type test_list: basestring
    :param module: python module name. If train and test is different, then
                   pass a tuple or list to this argument.
    :type module: basestring or tuple or list
    :param obj: python object name. May be a function name if using
                PyDataProviderWrapper. If train and test is different, then pass
                a tuple or list to this argument.
    :type obj: basestring or tuple or list
    :param args: The best practice is using dict() to pass arguments into
                 DataProvider, and use :code:`@init_hook_wrapper` to receive
                 arguments. If train and test is different, then pass a tuple
                 or list to this argument.
    :type args: string or picklable object or list or tuple.
    :param train_async: Is training data load asynchronously or not.
    :type train_async: bool
    :return: nothing
    :rtype: nothing
    """

    function __is_splitable__(o)
      (isa(o,Array) || isa(o,Tuple)) && in('__len__', o) && length(o) == 2
    end

    @assert train_list != nothing || test_list != nothing
    @assert _module != nothing && obj != nothing

    test_module = _module
    train_module = _module

    if __is_splitable__(obj):
      train_obj = obj
      test_obj = obj
    end

    if args != nothing
      args = ""
    end

    train_args = args
    test_args = args

    if train_list != nothing
      define_py_data_source(train_list, TrainData, train_module, train_obj,
                                train_args, train_async, data_cls)
    end

    if test_list != nothing
        define_py_data_source(test_list, TestData, test_module, test_obj,
                              test_args, false, data_cls)
    end
end

function define_py_data_sources2(train_list, test_list, _module, obj, args=nothing):
    """
    Define python Train/Test data sources in one method. If train/test use
    the same Data Provider configuration, module/obj/args contain one argument,
    otherwise contain a list or tuple of arguments. For example\:

    ..  code-block:: python

        define_py_data_sources2(train_list="train.list",
                                test_list="test.list",
                                module="data_provider"
                                # if train/test use different configurations,
                                # obj=["process_train", "process_test"]
                                obj="process",
                                args={"dictionary": dict_name})

    The related data provider can refer to :ref:`api_pydataprovider2_sequential_model` .

    :param train_list: Train list name.
    :type train_list: basestring
    :param test_list: Test list name.
    :type test_list: basestring
    :param module: python module name. If train and test is different, then
                   pass a tuple or list to this argument.
    :type module: basestring or tuple or list
    :param obj: python object name. May be a function name if using
                PyDataProviderWrapper. If train and test is different, then pass
                a tuple or list to this argument.
    :type obj: basestring or tuple or list
    :param args: The best practice is using dict() to pass arguments into
                 DataProvider, and use :code:`@init_hook_wrapper` to receive
                 arguments. If train and test is different, then pass a tuple
                 or list to this argument.
    :type args: string or picklable object or list or tuple.
    :return: nothing
    :rtype: nothing
    """

    function py_data2(files, load_data_module, load_data_object, load_data_args,
                   kwargs):
      data = DataBase()
      data.type = 'py2'
      data.files = files
      data.load_data_module = load_data_module
      data.load_data_object = load_data_object
      data.load_data_args = load_data_args
      data.async_load_data = true
      data
    end

    define_py_data_sources(
          train_list=train_list,
          test_list=test_list,
          _module = _module,
          obj=obj,
          args=args,
          data_cls=py_data2)

end
