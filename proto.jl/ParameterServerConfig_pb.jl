# syntax: proto2
using Compat
using ProtoBuf
import ProtoBuf.meta
import Base: hash, isequal, ==

type ParameterClientConfig
    trainer_id::Int32
    ParameterClientConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ParameterClientConfig
const __req_ParameterClientConfig = Symbol[:trainer_id]
meta(t::Type{ParameterClientConfig}) = meta(t, __req_ParameterClientConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ParameterClientConfig) = ProtoBuf.protohash(v)
isequal(v1::ParameterClientConfig, v2::ParameterClientConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ParameterClientConfig, v2::ParameterClientConfig) = ProtoBuf.protoeq(v1, v2)

type ParameterServerConfig
    ports_num::Int32
    ports_num_for_sparse::Int32
    nics::AbstractString
    rdma_tcp::AbstractString
    port::Int32
    num_gradient_servers::Int32
    pserver_num_threads::Int32
    async_lagged_ratio_min::Float64
    async_lagged_ratio_default::Float64
    ParameterServerConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ParameterServerConfig
const __req_ParameterServerConfig = Symbol[:ports_num,:ports_num_for_sparse,:nics,:rdma_tcp,:port,:num_gradient_servers,:pserver_num_threads,:async_lagged_ratio_min,:async_lagged_ratio_default]
const __val_ParameterServerConfig = Dict(:ports_num => 1, :ports_num_for_sparse => 0, :nics => "xgbe0,xgbe1", :rdma_tcp => "tcp", :port => 20134, :num_gradient_servers => 1, :pserver_num_threads => 1, :async_lagged_ratio_min => 1, :async_lagged_ratio_default => 1.5)
meta(t::Type{ParameterServerConfig}) = meta(t, __req_ParameterServerConfig, ProtoBuf.DEF_FNUM, __val_ParameterServerConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ParameterServerConfig) = ProtoBuf.protohash(v)
isequal(v1::ParameterServerConfig, v2::ParameterServerConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ParameterServerConfig, v2::ParameterServerConfig) = ProtoBuf.protoeq(v1, v2)

export ParameterClientConfig, ParameterServerConfig
