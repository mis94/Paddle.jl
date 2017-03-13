# syntax: proto2
using Compat
using ProtoBuf
import ProtoBuf.meta
import Base: hash, isequal, ==

type FileGroupConf
    queue_capacity::UInt32
    load_file_count::Int32
    load_thread_num::Int32
    FileGroupConf(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type FileGroupConf
const __val_FileGroupConf = Dict(:queue_capacity => 1, :load_file_count => 1, :load_thread_num => 1)
meta(t::Type{FileGroupConf}) = meta(t, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, __val_FileGroupConf, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::FileGroupConf) = ProtoBuf.protohash(v)
isequal(v1::FileGroupConf, v2::FileGroupConf) = ProtoBuf.protoisequal(v1, v2)
==(v1::FileGroupConf, v2::FileGroupConf) = ProtoBuf.protoeq(v1, v2)

type DataConfig
    _type::AbstractString
    files::AbstractString
    feat_dim::Int32
    slot_dims::Array{Int32,1}
    context_len::Int32
    buffer_capacity::UInt64
    train_sample_num::Int64
    file_load_num::Int32
    async_load_data::Bool
    for_test::Bool
    file_group_conf::FileGroupConf
    float_slot_dims::Array{Int32,1}
    constant_slots::Array{Float64,1}
    load_data_module::AbstractString
    load_data_object::AbstractString
    load_data_args::AbstractString
    sub_data_configs::Array{DataConfig,1}
    data_ratio::Int32
    is_main_data::Bool
    usage_ratio::Float64
    DataConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type DataConfig
const __req_DataConfig = Symbol[:_type]
const __val_DataConfig = Dict(:train_sample_num => -1, :file_load_num => -1, :async_load_data => false, :for_test => false, :is_main_data => true, :usage_ratio => 1)
const __fnum_DataConfig = Int[1,3,4,5,6,7,8,9,12,14,15,16,20,21,22,23,24,25,26,27]
meta(t::Type{DataConfig}) = meta(t, __req_DataConfig, __fnum_DataConfig, __val_DataConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::DataConfig) = ProtoBuf.protohash(v)
isequal(v1::DataConfig, v2::DataConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::DataConfig, v2::DataConfig) = ProtoBuf.protoeq(v1, v2)

export FileGroupConf, DataConfig
