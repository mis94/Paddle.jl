# syntax: proto2
using Compat
using ProtoBuf
import ProtoBuf.meta
import Base: hash, isequal, ==

type __enum_ParameterUpdateMode <: ProtoEnum
    PSERVER_UPDATE_MODE_SET_PARAM::Int32
    PSERVER_UPDATE_MODE_SET_PARAM_ZERO::Int32
    PSERVER_UPDATE_MODE_ASYNC_SGD::Int32
    PSERVER_UPDATE_MODE_ADD_GRADIENT::Int32
    PSERVER_UPDATE_MODE_AVERAGE_PARAMETER::Int32
    PSERVER_UPDATE_MODE_GET_PARAM::Int32
    PSERVER_UPDATE_MODE_GET_PARAM_SPARSE::Int32
    __enum_ParameterUpdateMode() = new(0,1,2,3,4,5,6)
end #type __enum_ParameterUpdateMode
const ParameterUpdateMode = __enum_ParameterUpdateMode()

type __enum_PServerStatus <: ProtoEnum
    PSERVER_STATUS_NOT_SET::Int32
    PSERVER_STATUS_PARAMETER_READY::Int32
    __enum_PServerStatus() = new(0,1)
end #type __enum_PServerStatus
const PServerStatus = __enum_PServerStatus()

type __enum_BatchStatus <: ProtoEnum
    BATCH_START::Int32
    BATCH_ON::Int32
    BATCH_FINISH::Int32
    BATCH_START_AND_FINISH::Int32
    __enum_BatchStatus() = new(0,1,2,3)
end #type __enum_BatchStatus
const BatchStatus = __enum_BatchStatus()

type __enum_SyncObject <: ProtoEnum
    SYNC_DEFAULT::Int32
    SYNC_DATA::Int32
    __enum_SyncObject() = new(0,1)
end #type __enum_SyncObject
const SyncObject = __enum_SyncObject()

type __enum_MatrixVectorOperation <: ProtoEnum
    PSERVER_OP_utu::Int32
    PSERVER_OP_utv::Int32
    PSERVER_OP_au::Int32
    PSERVER_OP_au_bv::Int32
    PSERVER_OP_aAx_bu::Int32
    PSERVER_OP_SGD::Int32
    PSERVER_OP_RESET::Int32
    PSERVER_OP_COPY::Int32
    PSERVER_OP_au_bv_cw::Int32
    PSERVER_OP_MAKE_STEEPEST_DESC_DIR::Int32
    PSERVER_OP_FIX_DIR_SIGNS::Int32
    PSERVER_OP_DIR_DERIV::Int32
    PSERVER_OP_FIX_OMEGA_SIGNS::Int32
    PSERVER_OP_COST::Int32
    PSERVER_OP_START_PASS::Int32
    PSERVER_OP_FINISH_PASS::Int32
    PSERVER_OP_RANDOMIZE::Int32
    PSERVER_OP_APPLY::Int32
    __enum_MatrixVectorOperation() = new(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)
end #type __enum_MatrixVectorOperation
const MatrixVectorOperation = __enum_MatrixVectorOperation()

type __enum_DataUpdateMode <: ProtoEnum
    DATA_UPDATE_MODE_SET_OWN::Int32
    DATA_UPDATE_MODE_GET_ALL::Int32
    DATA_UPDATE_MODE_SET_REF::Int32
    DATA_UPDATE_MODE_GET_REF::Int32
    DATA_UPDATE_MODE_SET_REF_LABEL::Int32
    DATA_UPDATE_MODE_GET_REF_LABEL::Int32
    DATA_UPDATE_MODE_SET_REF_GRAD::Int32
    DATA_UPDATE_MODE_GET_REF_GRAD::Int32
    __enum_DataUpdateMode() = new(0,1,2,3,4,5,6,7)
end #type __enum_DataUpdateMode
const DataUpdateMode = __enum_DataUpdateMode()

type __enum_SendDataType <: ProtoEnum
    DATA_REF::Int32
    DATA_REFLABEL::Int32
    DATA_REFGRAD::Int32
    DATA_REDUCE_SUM::Int32
    __enum_SendDataType() = new(0,1,2,3)
end #type __enum_SendDataType
const SendDataType = __enum_SendDataType()

type __enum_TransDataType <: ProtoEnum
    TRANS_INT32::Int32
    TRANS_UINT32_T::Int32
    TRANS_INT64_T::Int32
    TRANS_UINT64_T::Int32
    TRANS_FLOAT::Int32
    TRANS_DOUBLE::Int32
    __enum_TransDataType() = new(0,1,2,3,5,6)
end #type __enum_TransDataType
const TransDataType = __enum_TransDataType()

type ParameterBlock
    para_id::UInt64
    block_id::UInt64
    begin_pos::UInt64
    block_size::UInt64
    ParameterBlock(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ParameterBlock
const __req_ParameterBlock = Symbol[:para_id,:block_id,:begin_pos,:block_size]
meta(t::Type{ParameterBlock}) = meta(t, __req_ParameterBlock, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ParameterBlock) = ProtoBuf.protohash(v)
isequal(v1::ParameterBlock, v2::ParameterBlock) = ProtoBuf.protoisequal(v1, v2)
==(v1::ParameterBlock, v2::ParameterBlock) = ProtoBuf.protoeq(v1, v2)

type SendParameterRequest
    update_mode::Int32
    blocks::Array{ParameterBlock,1}
    send_back_parameter::Bool
    num_samples::Int64
    cost::Float64
    batch_status::Int32
    trainer_id::Int32
    send_back_parameter_type::Int32
    forwardbackward_time::UInt64
    SendParameterRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SendParameterRequest
const __req_SendParameterRequest = Symbol[:update_mode,:send_back_parameter,:batch_status]
const __val_SendParameterRequest = Dict(:send_back_parameter_type => 0)
meta(t::Type{SendParameterRequest}) = meta(t, __req_SendParameterRequest, ProtoBuf.DEF_FNUM, __val_SendParameterRequest, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SendParameterRequest) = ProtoBuf.protohash(v)
isequal(v1::SendParameterRequest, v2::SendParameterRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::SendParameterRequest, v2::SendParameterRequest) = ProtoBuf.protoeq(v1, v2)

type WaitPassStartRequest
    WaitPassStartRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type WaitPassStartRequest
hash(v::WaitPassStartRequest) = ProtoBuf.protohash(v)
isequal(v1::WaitPassStartRequest, v2::WaitPassStartRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::WaitPassStartRequest, v2::WaitPassStartRequest) = ProtoBuf.protoeq(v1, v2)

type WaitPassStartResponse
    WaitPassStartResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type WaitPassStartResponse
hash(v::WaitPassStartResponse) = ProtoBuf.protohash(v)
isequal(v1::WaitPassStartResponse, v2::WaitPassStartResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::WaitPassStartResponse, v2::WaitPassStartResponse) = ProtoBuf.protoeq(v1, v2)

type WaitPassFinishRequest
    WaitPassFinishRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type WaitPassFinishRequest
hash(v::WaitPassFinishRequest) = ProtoBuf.protohash(v)
isequal(v1::WaitPassFinishRequest, v2::WaitPassFinishRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::WaitPassFinishRequest, v2::WaitPassFinishRequest) = ProtoBuf.protoeq(v1, v2)

type WaitPassFinishResponse
    WaitPassFinishResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type WaitPassFinishResponse
hash(v::WaitPassFinishResponse) = ProtoBuf.protohash(v)
isequal(v1::WaitPassFinishResponse, v2::WaitPassFinishResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::WaitPassFinishResponse, v2::WaitPassFinishResponse) = ProtoBuf.protoeq(v1, v2)

type SynchronizeRequest
    sync_object_id::Int32
    trainer_id::Int32
    SynchronizeRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SynchronizeRequest
const __req_SynchronizeRequest = Symbol[:sync_object_id]
const __val_SynchronizeRequest = Dict(:sync_object_id => SyncObject.SYNC_DEFAULT)
meta(t::Type{SynchronizeRequest}) = meta(t, __req_SynchronizeRequest, ProtoBuf.DEF_FNUM, __val_SynchronizeRequest, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SynchronizeRequest) = ProtoBuf.protohash(v)
isequal(v1::SynchronizeRequest, v2::SynchronizeRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::SynchronizeRequest, v2::SynchronizeRequest) = ProtoBuf.protoeq(v1, v2)

type SynchronizeResponse
    SynchronizeResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SynchronizeResponse
hash(v::SynchronizeResponse) = ProtoBuf.protohash(v)
isequal(v1::SynchronizeResponse, v2::SynchronizeResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::SynchronizeResponse, v2::SynchronizeResponse) = ProtoBuf.protoeq(v1, v2)

type SendParameterResponse
    blocks::Array{ParameterBlock,1}
    SendParameterResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SendParameterResponse
hash(v::SendParameterResponse) = ProtoBuf.protohash(v)
isequal(v1::SendParameterResponse, v2::SendParameterResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::SendParameterResponse, v2::SendParameterResponse) = ProtoBuf.protoeq(v1, v2)

type SetConfigRequest
    param_configs::Array{ParameterConfig,1}
    opt_config::OptimizationConfig
    save_dir::AbstractString
    server_id::Int32
    is_sparse_server::Bool
    SetConfigRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SetConfigRequest
const __req_SetConfigRequest = Symbol[:opt_config,:save_dir,:server_id,:is_sparse_server]
const __fnum_SetConfigRequest = Int[1,2,4,5,6]
meta(t::Type{SetConfigRequest}) = meta(t, __req_SetConfigRequest, __fnum_SetConfigRequest, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SetConfigRequest) = ProtoBuf.protohash(v)
isequal(v1::SetConfigRequest, v2::SetConfigRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::SetConfigRequest, v2::SetConfigRequest) = ProtoBuf.protoeq(v1, v2)

type SetConfigResponse
    SetConfigResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SetConfigResponse
hash(v::SetConfigResponse) = ProtoBuf.protohash(v)
isequal(v1::SetConfigResponse, v2::SetConfigResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::SetConfigResponse, v2::SetConfigResponse) = ProtoBuf.protoeq(v1, v2)

type GetStatusRequest
    GetStatusRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type GetStatusRequest
hash(v::GetStatusRequest) = ProtoBuf.protohash(v)
isequal(v1::GetStatusRequest, v2::GetStatusRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::GetStatusRequest, v2::GetStatusRequest) = ProtoBuf.protoeq(v1, v2)

type GetStatusResponse
    status::Int32
    GetStatusResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type GetStatusResponse
const __req_GetStatusResponse = Symbol[:status]
meta(t::Type{GetStatusResponse}) = meta(t, __req_GetStatusResponse, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::GetStatusResponse) = ProtoBuf.protohash(v)
isequal(v1::GetStatusResponse, v2::GetStatusResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::GetStatusResponse, v2::GetStatusResponse) = ProtoBuf.protoeq(v1, v2)

type SetStatusRequest
    status::Int32
    SetStatusRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SetStatusRequest
const __req_SetStatusRequest = Symbol[:status]
meta(t::Type{SetStatusRequest}) = meta(t, __req_SetStatusRequest, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SetStatusRequest) = ProtoBuf.protohash(v)
isequal(v1::SetStatusRequest, v2::SetStatusRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::SetStatusRequest, v2::SetStatusRequest) = ProtoBuf.protoeq(v1, v2)

type SetStatusResponse
    SetStatusResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SetStatusResponse
hash(v::SetStatusResponse) = ProtoBuf.protohash(v)
isequal(v1::SetStatusResponse, v2::SetStatusResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::SetStatusResponse, v2::SetStatusResponse) = ProtoBuf.protoeq(v1, v2)

type CreateVectorRequest
    CreateVectorRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type CreateVectorRequest
hash(v::CreateVectorRequest) = ProtoBuf.protohash(v)
isequal(v1::CreateVectorRequest, v2::CreateVectorRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::CreateVectorRequest, v2::CreateVectorRequest) = ProtoBuf.protoeq(v1, v2)

type CreateVectorResponse
    return_message::AbstractString
    handle::Int64
    CreateVectorResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type CreateVectorResponse
const __req_CreateVectorResponse = Symbol[:handle]
meta(t::Type{CreateVectorResponse}) = meta(t, __req_CreateVectorResponse, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::CreateVectorResponse) = ProtoBuf.protohash(v)
isequal(v1::CreateVectorResponse, v2::CreateVectorResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::CreateVectorResponse, v2::CreateVectorResponse) = ProtoBuf.protoeq(v1, v2)

type ReleaseVectorRequest
    handle::Int64
    ReleaseVectorRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ReleaseVectorRequest
const __req_ReleaseVectorRequest = Symbol[:handle]
meta(t::Type{ReleaseVectorRequest}) = meta(t, __req_ReleaseVectorRequest, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ReleaseVectorRequest) = ProtoBuf.protohash(v)
isequal(v1::ReleaseVectorRequest, v2::ReleaseVectorRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::ReleaseVectorRequest, v2::ReleaseVectorRequest) = ProtoBuf.protoeq(v1, v2)

type ReleaseVectorResponse
    return_message::AbstractString
    ReleaseVectorResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ReleaseVectorResponse
hash(v::ReleaseVectorResponse) = ProtoBuf.protohash(v)
isequal(v1::ReleaseVectorResponse, v2::ReleaseVectorResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::ReleaseVectorResponse, v2::ReleaseVectorResponse) = ProtoBuf.protoeq(v1, v2)

type CreateMatrixRequest
    num_cols::Int32
    CreateMatrixRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type CreateMatrixRequest
const __req_CreateMatrixRequest = Symbol[:num_cols]
meta(t::Type{CreateMatrixRequest}) = meta(t, __req_CreateMatrixRequest, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::CreateMatrixRequest) = ProtoBuf.protohash(v)
isequal(v1::CreateMatrixRequest, v2::CreateMatrixRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::CreateMatrixRequest, v2::CreateMatrixRequest) = ProtoBuf.protoeq(v1, v2)

type CreateMatrixResponse
    return_message::AbstractString
    handle::Int64
    CreateMatrixResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type CreateMatrixResponse
const __req_CreateMatrixResponse = Symbol[:handle]
meta(t::Type{CreateMatrixResponse}) = meta(t, __req_CreateMatrixResponse, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::CreateMatrixResponse) = ProtoBuf.protohash(v)
isequal(v1::CreateMatrixResponse, v2::CreateMatrixResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::CreateMatrixResponse, v2::CreateMatrixResponse) = ProtoBuf.protoeq(v1, v2)

type ReleaseMatrixRequest
    handle::Int64
    ReleaseMatrixRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ReleaseMatrixRequest
const __req_ReleaseMatrixRequest = Symbol[:handle]
meta(t::Type{ReleaseMatrixRequest}) = meta(t, __req_ReleaseMatrixRequest, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ReleaseMatrixRequest) = ProtoBuf.protohash(v)
isequal(v1::ReleaseMatrixRequest, v2::ReleaseMatrixRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::ReleaseMatrixRequest, v2::ReleaseMatrixRequest) = ProtoBuf.protoeq(v1, v2)

type ReleaseMatrixResponse
    return_message::AbstractString
    ReleaseMatrixResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ReleaseMatrixResponse
hash(v::ReleaseMatrixResponse) = ProtoBuf.protohash(v)
isequal(v1::ReleaseMatrixResponse, v2::ReleaseMatrixResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::ReleaseMatrixResponse, v2::ReleaseMatrixResponse) = ProtoBuf.protoeq(v1, v2)

type ProtoVector
    dim::Int64
    values::Array{Float64,1}
    ProtoVector(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ProtoVector
const __req_ProtoVector = Symbol[:dim]
const __pack_ProtoVector = Symbol[:values]
meta(t::Type{ProtoVector}) = meta(t, __req_ProtoVector, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, __pack_ProtoVector, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ProtoVector) = ProtoBuf.protohash(v)
isequal(v1::ProtoVector, v2::ProtoVector) = ProtoBuf.protoisequal(v1, v2)
==(v1::ProtoVector, v2::ProtoVector) = ProtoBuf.protoeq(v1, v2)

type ProtoMatrix
    num_rows::Int64
    num_cols::Int64
    values::Array{Float64,1}
    ProtoMatrix(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ProtoMatrix
const __req_ProtoMatrix = Symbol[:num_rows,:num_cols]
const __pack_ProtoMatrix = Symbol[:values]
meta(t::Type{ProtoMatrix}) = meta(t, __req_ProtoMatrix, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, __pack_ProtoMatrix, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ProtoMatrix) = ProtoBuf.protohash(v)
isequal(v1::ProtoMatrix, v2::ProtoMatrix) = ProtoBuf.protoisequal(v1, v2)
==(v1::ProtoMatrix, v2::ProtoMatrix) = ProtoBuf.protoeq(v1, v2)

type Operation
    operation::Int32
    pvectors::Array{Int64,1}
    pmatrices::Array{Int64,1}
    scalars::Array{Float64,1}
    vectors::Array{ProtoVector,1}
    matrices::Array{ProtoMatrix,1}
    Operation(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type Operation
const __req_Operation = Symbol[:operation]
meta(t::Type{Operation}) = meta(t, __req_Operation, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::Operation) = ProtoBuf.protohash(v)
isequal(v1::Operation, v2::Operation) = ProtoBuf.protoisequal(v1, v2)
==(v1::Operation, v2::Operation) = ProtoBuf.protoeq(v1, v2)

type OperationResult
    return_message::AbstractString
    scalars::Array{Float64,1}
    vectors::Array{ProtoVector,1}
    matrices::Array{ProtoMatrix,1}
    OperationResult(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type OperationResult
hash(v::OperationResult) = ProtoBuf.protohash(v)
isequal(v1::OperationResult, v2::OperationResult) = ProtoBuf.protoisequal(v1, v2)
==(v1::OperationResult, v2::OperationResult) = ProtoBuf.protoeq(v1, v2)

type DoOperationRequest
    operations::Array{Operation,1}
    wait_for_gradient::Bool
    send_back_parameter::Bool
    release_pass::Bool
    DoOperationRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type DoOperationRequest
const __req_DoOperationRequest = Symbol[:wait_for_gradient,:send_back_parameter,:release_pass]
meta(t::Type{DoOperationRequest}) = meta(t, __req_DoOperationRequest, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::DoOperationRequest) = ProtoBuf.protohash(v)
isequal(v1::DoOperationRequest, v2::DoOperationRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::DoOperationRequest, v2::DoOperationRequest) = ProtoBuf.protoeq(v1, v2)

type DoOperationResponse
    return_message::AbstractString
    results::Array{OperationResult,1}
    pass_finish::Bool
    DoOperationResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type DoOperationResponse
const __req_DoOperationResponse = Symbol[:pass_finish]
meta(t::Type{DoOperationResponse}) = meta(t, __req_DoOperationResponse, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::DoOperationResponse) = ProtoBuf.protohash(v)
isequal(v1::DoOperationResponse, v2::DoOperationResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::DoOperationResponse, v2::DoOperationResponse) = ProtoBuf.protoeq(v1, v2)

type LoadValueRequest
    dir_name::AbstractString
    LoadValueRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type LoadValueRequest
const __req_LoadValueRequest = Symbol[:dir_name]
meta(t::Type{LoadValueRequest}) = meta(t, __req_LoadValueRequest, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::LoadValueRequest) = ProtoBuf.protohash(v)
isequal(v1::LoadValueRequest, v2::LoadValueRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::LoadValueRequest, v2::LoadValueRequest) = ProtoBuf.protoeq(v1, v2)

type LoadValueResponse
    return_message::AbstractString
    LoadValueResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type LoadValueResponse
hash(v::LoadValueResponse) = ProtoBuf.protohash(v)
isequal(v1::LoadValueResponse, v2::LoadValueResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::LoadValueResponse, v2::LoadValueResponse) = ProtoBuf.protoeq(v1, v2)

type SaveValueRequest
    dir_name::AbstractString
    SaveValueRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SaveValueRequest
const __req_SaveValueRequest = Symbol[:dir_name]
meta(t::Type{SaveValueRequest}) = meta(t, __req_SaveValueRequest, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SaveValueRequest) = ProtoBuf.protohash(v)
isequal(v1::SaveValueRequest, v2::SaveValueRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::SaveValueRequest, v2::SaveValueRequest) = ProtoBuf.protoeq(v1, v2)

type SaveValueResponse
    return_message::AbstractString
    SaveValueResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SaveValueResponse
hash(v::SaveValueResponse) = ProtoBuf.protohash(v)
isequal(v1::SaveValueResponse, v2::SaveValueResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::SaveValueResponse, v2::SaveValueResponse) = ProtoBuf.protoeq(v1, v2)

type DataBlock
    total_size::UInt64
    data_size::Int32
    data_type::Int32
    DataBlock(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type DataBlock
const __req_DataBlock = Symbol[:total_size,:data_size]
const __val_DataBlock = Dict(:data_type => TransDataType.TRANS_DOUBLE)
meta(t::Type{DataBlock}) = meta(t, __req_DataBlock, ProtoBuf.DEF_FNUM, __val_DataBlock, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::DataBlock) = ProtoBuf.protohash(v)
isequal(v1::DataBlock, v2::DataBlock) = ProtoBuf.protoisequal(v1, v2)
==(v1::DataBlock, v2::DataBlock) = ProtoBuf.protoeq(v1, v2)

type SendDataRequest
    _type::Int32
    update_mode::Int32
    blocks::Array{DataBlock,1}
    client_id::UInt64
    server_id::UInt64
    SendDataRequest(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SendDataRequest
const __req_SendDataRequest = Symbol[:_type,:update_mode,:client_id,:server_id]
meta(t::Type{SendDataRequest}) = meta(t, __req_SendDataRequest, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SendDataRequest) = ProtoBuf.protohash(v)
isequal(v1::SendDataRequest, v2::SendDataRequest) = ProtoBuf.protoisequal(v1, v2)
==(v1::SendDataRequest, v2::SendDataRequest) = ProtoBuf.protoeq(v1, v2)

type SendDataResponse
    _type::Int32
    blocks::Array{DataBlock,1}
    server_id::UInt64
    SendDataResponse(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SendDataResponse
const __req_SendDataResponse = Symbol[:_type,:server_id]
meta(t::Type{SendDataResponse}) = meta(t, __req_SendDataResponse, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SendDataResponse) = ProtoBuf.protohash(v)
isequal(v1::SendDataResponse, v2::SendDataResponse) = ProtoBuf.protoisequal(v1, v2)
==(v1::SendDataResponse, v2::SendDataResponse) = ProtoBuf.protoeq(v1, v2)

export ParameterUpdateMode, PServerStatus, BatchStatus, SyncObject, MatrixVectorOperation, DataUpdateMode, SendDataType, TransDataType, ParameterBlock, SendParameterRequest, WaitPassStartRequest, WaitPassStartResponse, WaitPassFinishRequest, WaitPassFinishResponse, SynchronizeRequest, SynchronizeResponse, SendParameterResponse, SetConfigRequest, SetConfigResponse, GetStatusRequest, GetStatusResponse, SetStatusRequest, SetStatusResponse, CreateVectorRequest, CreateVectorResponse, ReleaseVectorRequest, ReleaseVectorResponse, CreateMatrixRequest, CreateMatrixResponse, ReleaseMatrixRequest, ReleaseMatrixResponse, ProtoVector, ProtoMatrix, Operation, OperationResult, DoOperationRequest, DoOperationResponse, LoadValueRequest, LoadValueResponse, SaveValueRequest, SaveValueResponse, DataBlock, SendDataRequest, SendDataResponse
