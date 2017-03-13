# syntax: proto2
using Compat
using ProtoBuf
import ProtoBuf.meta
import Base: hash, isequal, ==

type VectorSlot
    values::Array{Float32,1}
    ids::Array{UInt32,1}
    dims::Array{UInt32,1}
    strs::Array{AbstractString,1}
    VectorSlot(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type VectorSlot
const __pack_VectorSlot = Symbol[:values,:ids,:dims]
meta(t::Type{VectorSlot}) = meta(t, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, __pack_VectorSlot, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::VectorSlot) = ProtoBuf.protohash(v)
isequal(v1::VectorSlot, v2::VectorSlot) = ProtoBuf.protoisequal(v1, v2)
==(v1::VectorSlot, v2::VectorSlot) = ProtoBuf.protoeq(v1, v2)

type SubseqSlot
    slot_id::UInt32
    lens::Array{UInt32,1}
    SubseqSlot(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SubseqSlot
const __req_SubseqSlot = Symbol[:slot_id]
meta(t::Type{SubseqSlot}) = meta(t, __req_SubseqSlot, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SubseqSlot) = ProtoBuf.protohash(v)
isequal(v1::SubseqSlot, v2::SubseqSlot) = ProtoBuf.protoisequal(v1, v2)
==(v1::SubseqSlot, v2::SubseqSlot) = ProtoBuf.protoeq(v1, v2)

type __enum_SlotDef_SlotType <: ProtoEnum
    VECTOR_DENSE::Int32
    VECTOR_SPARSE_NON_VALUE::Int32
    VECTOR_SPARSE_VALUE::Int32
    INDEX::Int32
    VAR_MDIM_DENSE::Int32
    VAR_MDIM_INDEX::Int32
    STRING::Int32
    __enum_SlotDef_SlotType() = new(0,1,2,3,4,5,6)
end #type __enum_SlotDef_SlotType
const SlotDef_SlotType = __enum_SlotDef_SlotType()

type SlotDef
    _type::Int32
    dim::UInt32
    SlotDef(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SlotDef
const __req_SlotDef = Symbol[:_type,:dim]
meta(t::Type{SlotDef}) = meta(t, __req_SlotDef, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SlotDef) = ProtoBuf.protohash(v)
isequal(v1::SlotDef, v2::SlotDef) = ProtoBuf.protoisequal(v1, v2)
==(v1::SlotDef, v2::SlotDef) = ProtoBuf.protoeq(v1, v2)

type DataHeader
    slot_defs::Array{SlotDef,1}
    DataHeader(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type DataHeader
hash(v::DataHeader) = ProtoBuf.protohash(v)
isequal(v1::DataHeader, v2::DataHeader) = ProtoBuf.protoisequal(v1, v2)
==(v1::DataHeader, v2::DataHeader) = ProtoBuf.protoeq(v1, v2)

type DataSample
    is_beginning::Bool
    vector_slots::Array{VectorSlot,1}
    id_slots::Array{UInt32,1}
    var_id_slots::Array{VectorSlot,1}
    subseq_slots::Array{SubseqSlot,1}
    DataSample(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type DataSample
const __val_DataSample = Dict(:is_beginning => true)
const __pack_DataSample = Symbol[:id_slots]
meta(t::Type{DataSample}) = meta(t, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, __val_DataSample, true, __pack_DataSample, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::DataSample) = ProtoBuf.protohash(v)
isequal(v1::DataSample, v2::DataSample) = ProtoBuf.protoisequal(v1, v2)
==(v1::DataSample, v2::DataSample) = ProtoBuf.protoeq(v1, v2)

export VectorSlot, SubseqSlot, SlotDef_SlotType, SlotDef, DataHeader, DataSample
