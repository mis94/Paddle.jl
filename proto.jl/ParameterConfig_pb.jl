# syntax: proto2
using Compat
using ProtoBuf
import ProtoBuf.meta
import Base: hash, isequal, ==

type __enum_ParameterInitStrategy <: ProtoEnum
    PARAMETER_INIT_NORMAL::Int32
    PARAMETER_INIT_UNIFORM::Int32
    __enum_ParameterInitStrategy() = new(0,1)
end #type __enum_ParameterInitStrategy
const ParameterInitStrategy = __enum_ParameterInitStrategy()

type ParameterUpdaterHookConfig
    _type::AbstractString
    purning_mask_filename::AbstractString
    ParameterUpdaterHookConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ParameterUpdaterHookConfig
const __req_ParameterUpdaterHookConfig = Symbol[:_type]
meta(t::Type{ParameterUpdaterHookConfig}) = meta(t, __req_ParameterUpdaterHookConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ParameterUpdaterHookConfig) = ProtoBuf.protohash(v)
isequal(v1::ParameterUpdaterHookConfig, v2::ParameterUpdaterHookConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ParameterUpdaterHookConfig, v2::ParameterUpdaterHookConfig) = ProtoBuf.protoeq(v1, v2)

type ParameterConfig
    name::AbstractString
    size::UInt64
    learning_rate::Float64
    momentum::Float64
    initial_mean::Float64
    initial_std::Float64
    decay_rate::Float64
    decay_rate_l1::Float64
    dims::Array{UInt64,1}
    device::Int32
    initial_strategy::Int32
    initial_smart::Bool
    num_batches_regularization::Int32
    is_sparse::Bool
    format::AbstractString
    sparse_remote_update::Bool
    gradient_clipping_threshold::Float64
    is_static::Bool
    para_id::UInt64
    update_hooks::Array{ParameterUpdaterHookConfig,1}
    need_compact::Bool
    sparse_update::Bool
    is_shared::Bool
    parameter_block_size::UInt64
    ParameterConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ParameterConfig
const __req_ParameterConfig = Symbol[:name,:size]
const __val_ParameterConfig = Dict(:learning_rate => 1, :momentum => 0, :initial_mean => 0, :initial_std => 0.01, :decay_rate => 0, :decay_rate_l1 => 0, :device => -1, :initial_strategy => 0, :initial_smart => false, :num_batches_regularization => 1, :is_sparse => false, :sparse_remote_update => false, :gradient_clipping_threshold => 0, :is_static => false, :need_compact => false, :sparse_update => false, :is_shared => false, :parameter_block_size => 0)
meta(t::Type{ParameterConfig}) = meta(t, __req_ParameterConfig, ProtoBuf.DEF_FNUM, __val_ParameterConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ParameterConfig) = ProtoBuf.protohash(v)
isequal(v1::ParameterConfig, v2::ParameterConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ParameterConfig, v2::ParameterConfig) = ProtoBuf.protoeq(v1, v2)

export ParameterInitStrategy, ParameterUpdaterHookConfig, ParameterConfig
