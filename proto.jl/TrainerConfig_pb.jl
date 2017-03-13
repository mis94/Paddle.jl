# syntax: proto2
using Compat
using ProtoBuf
import ProtoBuf.meta
import Base: hash, isequal, ==

type OptimizationConfig
    batch_size::Int32
    algorithm::AbstractString
    num_batches_per_send_parameter::Int32
    num_batches_per_get_parameter::Int32
    learning_rate::Float64
    learning_rate_decay_a::Float64
    learning_rate_decay_b::Float64
    learning_rate_schedule::AbstractString
    l1weight::Float64
    l2weight::Float64
    c1::Float64
    backoff::Float64
    owlqn_steps::Int32
    max_backoff::Int32
    l2weight_zero_iter::Int32
    average_window::Float64
    max_average_window::Int64
    learning_method::AbstractString
    ada_epsilon::Float64
    ada_rou::Float64
    do_average_in_cpu::Bool
    delta_add_rate::Float64
    mini_batch_size::Int32
    use_sparse_remote_updater::Bool
    center_parameter_update_method::AbstractString
    shrink_parameter_value::Float64
    adam_beta1::Float64
    adam_beta2::Float64
    adam_epsilon::Float64
    learning_rate_args::AbstractString
    async_lagged_grad_discard_ratio::Float64
    OptimizationConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type OptimizationConfig
const __req_OptimizationConfig = Symbol[:batch_size,:algorithm,:learning_rate]
const __val_OptimizationConfig = Dict(:algorithm => "async_sgd", :num_batches_per_send_parameter => 1, :num_batches_per_get_parameter => 1, :learning_rate_decay_a => 0, :learning_rate_decay_b => 0, :learning_rate_schedule => "constant", :l1weight => 0.1, :l2weight => 0, :c1 => 0.0001, :backoff => 0.5, :owlqn_steps => 10, :max_backoff => 5, :l2weight_zero_iter => 0, :average_window => 0, :max_average_window => 9223372036854775807, :learning_method => "momentum", :ada_epsilon => 1e-06, :ada_rou => 0.95, :do_average_in_cpu => false, :delta_add_rate => 1, :mini_batch_size => 128, :use_sparse_remote_updater => false, :center_parameter_update_method => "average", :shrink_parameter_value => 0, :adam_beta1 => 0.9, :adam_beta2 => 0.999, :adam_epsilon => 1e-08, :async_lagged_grad_discard_ratio => 1.5)
const __fnum_OptimizationConfig = Int[3,4,5,6,7,8,9,27,10,11,12,13,14,15,17,18,19,23,24,26,25,28,29,30,31,32,33,34,35,36,37]
meta(t::Type{OptimizationConfig}) = meta(t, __req_OptimizationConfig, __fnum_OptimizationConfig, __val_OptimizationConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::OptimizationConfig) = ProtoBuf.protohash(v)
isequal(v1::OptimizationConfig, v2::OptimizationConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::OptimizationConfig, v2::OptimizationConfig) = ProtoBuf.protoeq(v1, v2)

type TrainerConfig
    model_config::ModelConfig
    data_config::DataConfig
    opt_config::OptimizationConfig
    test_data_config::DataConfig
    config_files::Array{AbstractString,1}
    save_dir::AbstractString
    init_model_path::AbstractString
    start_pass::Int32
    config_file::AbstractString
    TrainerConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type TrainerConfig
const __req_TrainerConfig = Symbol[:opt_config]
const __val_TrainerConfig = Dict(:save_dir => "./output/model", :start_pass => 0)
meta(t::Type{TrainerConfig}) = meta(t, __req_TrainerConfig, ProtoBuf.DEF_FNUM, __val_TrainerConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::TrainerConfig) = ProtoBuf.protohash(v)
isequal(v1::TrainerConfig, v2::TrainerConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::TrainerConfig, v2::TrainerConfig) = ProtoBuf.protoeq(v1, v2)

export OptimizationConfig, TrainerConfig
