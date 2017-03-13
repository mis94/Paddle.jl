# syntax: proto2
using Compat
using ProtoBuf
import ProtoBuf.meta
import Base: hash, isequal, ==

type ExternalConfig
    layer_names::Array{AbstractString,1}
    input_layer_names::Array{AbstractString,1}
    output_layer_names::Array{AbstractString,1}
    ExternalConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ExternalConfig
hash(v::ExternalConfig) = ProtoBuf.protohash(v)
isequal(v1::ExternalConfig, v2::ExternalConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ExternalConfig, v2::ExternalConfig) = ProtoBuf.protoeq(v1, v2)

type ActivationConfig
    _type::AbstractString
    ActivationConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ActivationConfig
const __req_ActivationConfig = Symbol[:_type]
meta(t::Type{ActivationConfig}) = meta(t, __req_ActivationConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ActivationConfig) = ProtoBuf.protohash(v)
isequal(v1::ActivationConfig, v2::ActivationConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ActivationConfig, v2::ActivationConfig) = ProtoBuf.protoeq(v1, v2)

type ConvConfig
    filter_size::UInt32
    channels::UInt32
    stride::UInt32
    padding::UInt32
    groups::UInt32
    filter_channels::UInt32
    output_x::UInt32
    img_size::UInt32
    caffe_mode::Bool
    filter_size_y::UInt32
    padding_y::UInt32
    stride_y::UInt32
    output_y::UInt32
    img_size_y::UInt32
    ConvConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ConvConfig
const __req_ConvConfig = Symbol[:filter_size,:channels,:stride,:padding,:groups,:filter_channels,:output_x,:img_size,:caffe_mode,:filter_size_y,:padding_y,:stride_y]
const __val_ConvConfig = Dict(:caffe_mode => true)
meta(t::Type{ConvConfig}) = meta(t, __req_ConvConfig, ProtoBuf.DEF_FNUM, __val_ConvConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ConvConfig) = ProtoBuf.protohash(v)
isequal(v1::ConvConfig, v2::ConvConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ConvConfig, v2::ConvConfig) = ProtoBuf.protoeq(v1, v2)

type PoolConfig
    pool_type::AbstractString
    channels::UInt32
    size_x::UInt32
    start::UInt32
    stride::UInt32
    output_x::UInt32
    img_size::UInt32
    padding::UInt32
    size_y::UInt32
    stride_y::UInt32
    output_y::UInt32
    img_size_y::UInt32
    padding_y::UInt32
    PoolConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type PoolConfig
const __req_PoolConfig = Symbol[:pool_type,:channels,:size_x,:stride,:output_x,:img_size]
const __val_PoolConfig = Dict(:stride => 1, :padding => 0)
meta(t::Type{PoolConfig}) = meta(t, __req_PoolConfig, ProtoBuf.DEF_FNUM, __val_PoolConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::PoolConfig) = ProtoBuf.protohash(v)
isequal(v1::PoolConfig, v2::PoolConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::PoolConfig, v2::PoolConfig) = ProtoBuf.protoeq(v1, v2)

type NormConfig
    norm_type::AbstractString
    channels::UInt32
    size::UInt32
    scale::Float64
    pow::Float64
    output_x::UInt32
    img_size::UInt32
    blocked::Bool
    output_y::UInt32
    img_size_y::UInt32
    NormConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type NormConfig
const __req_NormConfig = Symbol[:norm_type,:channels,:size,:scale,:pow,:output_x,:img_size]
meta(t::Type{NormConfig}) = meta(t, __req_NormConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::NormConfig) = ProtoBuf.protohash(v)
isequal(v1::NormConfig, v2::NormConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::NormConfig, v2::NormConfig) = ProtoBuf.protoeq(v1, v2)

type BlockExpandConfig
    channels::UInt32
    stride_x::UInt32
    stride_y::UInt32
    padding_x::UInt32
    padding_y::UInt32
    block_x::UInt32
    block_y::UInt32
    output_x::UInt32
    output_y::UInt32
    img_size_x::UInt32
    img_size_y::UInt32
    BlockExpandConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type BlockExpandConfig
const __req_BlockExpandConfig = Symbol[:channels,:stride_x,:stride_y,:padding_x,:padding_y,:block_x,:block_y,:output_x,:output_y,:img_size_x,:img_size_y]
meta(t::Type{BlockExpandConfig}) = meta(t, __req_BlockExpandConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::BlockExpandConfig) = ProtoBuf.protohash(v)
isequal(v1::BlockExpandConfig, v2::BlockExpandConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::BlockExpandConfig, v2::BlockExpandConfig) = ProtoBuf.protoeq(v1, v2)

type ProjectionConfig
    _type::AbstractString
    name::AbstractString
    input_size::UInt64
    output_size::UInt64
    context_start::Int32
    context_length::Int32
    trainable_padding::Bool
    conv_conf::ConvConfig
    num_filters::Int32
    offset::UInt64
    pool_conf::PoolConfig
    ProjectionConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ProjectionConfig
const __req_ProjectionConfig = Symbol[:_type,:name,:input_size,:output_size]
const __val_ProjectionConfig = Dict(:trainable_padding => false, :offset => 0)
const __fnum_ProjectionConfig = Int[1,2,3,4,5,6,7,8,9,11,12]
meta(t::Type{ProjectionConfig}) = meta(t, __req_ProjectionConfig, __fnum_ProjectionConfig, __val_ProjectionConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ProjectionConfig) = ProtoBuf.protohash(v)
isequal(v1::ProjectionConfig, v2::ProjectionConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ProjectionConfig, v2::ProjectionConfig) = ProtoBuf.protoeq(v1, v2)

type OperatorConfig
    _type::AbstractString
    input_indices::Array{Int32,1}
    input_sizes::Array{UInt64,1}
    output_size::UInt64
    dotmul_scale::Float64
    conv_conf::ConvConfig
    num_filters::Int32
    OperatorConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type OperatorConfig
const __req_OperatorConfig = Symbol[:_type,:output_size]
const __val_OperatorConfig = Dict(:dotmul_scale => 1)
meta(t::Type{OperatorConfig}) = meta(t, __req_OperatorConfig, ProtoBuf.DEF_FNUM, __val_OperatorConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::OperatorConfig) = ProtoBuf.protohash(v)
isequal(v1::OperatorConfig, v2::OperatorConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::OperatorConfig, v2::OperatorConfig) = ProtoBuf.protoeq(v1, v2)

type ImageConfig
    channels::UInt32
    img_size::UInt32
    img_size_y::UInt32
    ImageConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ImageConfig
const __req_ImageConfig = Symbol[:channels,:img_size]
const __fnum_ImageConfig = Int[2,8,9]
meta(t::Type{ImageConfig}) = meta(t, __req_ImageConfig, __fnum_ImageConfig, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ImageConfig) = ProtoBuf.protohash(v)
isequal(v1::ImageConfig, v2::ImageConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ImageConfig, v2::ImageConfig) = ProtoBuf.protoeq(v1, v2)

type MaxOutConfig
    image_conf::ImageConfig
    groups::UInt32
    MaxOutConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type MaxOutConfig
const __req_MaxOutConfig = Symbol[:image_conf,:groups]
meta(t::Type{MaxOutConfig}) = meta(t, __req_MaxOutConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::MaxOutConfig) = ProtoBuf.protohash(v)
isequal(v1::MaxOutConfig, v2::MaxOutConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::MaxOutConfig, v2::MaxOutConfig) = ProtoBuf.protoeq(v1, v2)

type SppConfig
    image_conf::ImageConfig
    pool_type::AbstractString
    pyramid_height::UInt32
    SppConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SppConfig
const __req_SppConfig = Symbol[:image_conf,:pool_type,:pyramid_height]
meta(t::Type{SppConfig}) = meta(t, __req_SppConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SppConfig) = ProtoBuf.protohash(v)
isequal(v1::SppConfig, v2::SppConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::SppConfig, v2::SppConfig) = ProtoBuf.protoeq(v1, v2)

type BilinearInterpConfig
    image_conf::ImageConfig
    out_size_x::UInt32
    out_size_y::UInt32
    BilinearInterpConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type BilinearInterpConfig
const __req_BilinearInterpConfig = Symbol[:image_conf,:out_size_x,:out_size_y]
meta(t::Type{BilinearInterpConfig}) = meta(t, __req_BilinearInterpConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::BilinearInterpConfig) = ProtoBuf.protohash(v)
isequal(v1::BilinearInterpConfig, v2::BilinearInterpConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::BilinearInterpConfig, v2::BilinearInterpConfig) = ProtoBuf.protoeq(v1, v2)

type PriorBoxConfig
    min_size::Array{UInt32,1}
    max_size::Array{UInt32,1}
    aspect_ratio::Array{Float32,1}
    variance::Array{Float32,1}
    PriorBoxConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type PriorBoxConfig
hash(v::PriorBoxConfig) = ProtoBuf.protohash(v)
isequal(v1::PriorBoxConfig, v2::PriorBoxConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::PriorBoxConfig, v2::PriorBoxConfig) = ProtoBuf.protoeq(v1, v2)

type PadConfig
    image_conf::ImageConfig
    pad_c::Array{UInt32,1}
    pad_h::Array{UInt32,1}
    pad_w::Array{UInt32,1}
    PadConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type PadConfig
const __req_PadConfig = Symbol[:image_conf]
meta(t::Type{PadConfig}) = meta(t, __req_PadConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::PadConfig) = ProtoBuf.protohash(v)
isequal(v1::PadConfig, v2::PadConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::PadConfig, v2::PadConfig) = ProtoBuf.protoeq(v1, v2)

type LayerInputConfig
    input_layer_name::AbstractString
    input_parameter_name::AbstractString
    conv_conf::ConvConfig
    pool_conf::PoolConfig
    norm_conf::NormConfig
    proj_conf::ProjectionConfig
    block_expand_conf::BlockExpandConfig
    image_conf::ImageConfig
    input_layer_argument::AbstractString
    bilinear_interp_conf::BilinearInterpConfig
    maxout_conf::MaxOutConfig
    spp_conf::SppConfig
    priorbox_conf::PriorBoxConfig
    pad_conf::PadConfig
    LayerInputConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type LayerInputConfig
const __req_LayerInputConfig = Symbol[:input_layer_name]
meta(t::Type{LayerInputConfig}) = meta(t, __req_LayerInputConfig, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::LayerInputConfig) = ProtoBuf.protohash(v)
isequal(v1::LayerInputConfig, v2::LayerInputConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::LayerInputConfig, v2::LayerInputConfig) = ProtoBuf.protoeq(v1, v2)

type LayerConfig
    name::AbstractString
    _type::AbstractString
    size::UInt64
    active_type::AbstractString
    inputs::Array{LayerInputConfig,1}
    bias_parameter_name::AbstractString
    num_filters::UInt32
    shared_biases::Bool
    partial_sum::UInt32
    drop_rate::Float64
    num_classes::UInt32
    device::Int32
    reversed::Bool
    active_gate_type::AbstractString
    active_state_type::AbstractString
    num_neg_samples::Int32
    neg_sampling_dist::Array{Float64,1}
    output_max_index::Bool
    softmax_selfnorm_alpha::Float64
    directions::Array{Bool,1}
    norm_by_times::Bool
    coeff::Float64
    average_strategy::AbstractString
    error_clipping_threshold::Float64
    operator_confs::Array{OperatorConfig,1}
    NDCG_num::Int32
    max_sort_size::Int32
    slope::Float64
    intercept::Float64
    cos_scale::Float64
    data_norm_strategy::AbstractString
    bos_id::UInt32
    eos_id::UInt32
    beam_size::UInt32
    select_first::Bool
    trans_type::AbstractString
    selective_fc_pass_generation::Bool
    has_selected_colums::Bool
    selective_fc_full_mul_ratio::Float64
    selective_fc_parallel_plain_mul_thread_num::UInt32
    use_global_stats::Bool
    moving_average_fraction::Float64
    bias_size::UInt32
    user_arg::AbstractString
    height::UInt64
    width::UInt64
    blank::UInt32
    LayerConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type LayerConfig
const __req_LayerConfig = Symbol[:name,:_type]
const __val_LayerConfig = Dict(:shared_biases => false, :device => -1, :reversed => false, :num_neg_samples => 10, :output_max_index => false, :softmax_selfnorm_alpha => 0.1, :coeff => 1, :error_clipping_threshold => 0, :select_first => false, :trans_type => "non-seq", :selective_fc_pass_generation => false, :has_selected_colums => true, :selective_fc_full_mul_ratio => 0.02, :selective_fc_parallel_plain_mul_thread_num => 0, :moving_average_fraction => 0.9, :bias_size => 0, :blank => 0)
const __fnum_LayerConfig = Int[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,21,24,25,26,27,28,29,30,31,32,33,34,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52]
const __pack_LayerConfig = Symbol[:neg_sampling_dist]
meta(t::Type{LayerConfig}) = meta(t, __req_LayerConfig, __fnum_LayerConfig, __val_LayerConfig, true, __pack_LayerConfig, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::LayerConfig) = ProtoBuf.protohash(v)
isequal(v1::LayerConfig, v2::LayerConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::LayerConfig, v2::LayerConfig) = ProtoBuf.protoeq(v1, v2)

type EvaluatorConfig
    name::AbstractString
    _type::AbstractString
    input_layers::Array{AbstractString,1}
    chunk_scheme::AbstractString
    num_chunk_types::Int32
    classification_threshold::Float64
    positive_label::Int32
    dict_file::AbstractString
    result_file::AbstractString
    num_results::Int32
    delimited::Bool
    excluded_chunk_types::Array{Int32,1}
    EvaluatorConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type EvaluatorConfig
const __req_EvaluatorConfig = Symbol[:name,:_type]
const __val_EvaluatorConfig = Dict(:classification_threshold => 0.5, :positive_label => -1, :num_results => 1, :delimited => true)
meta(t::Type{EvaluatorConfig}) = meta(t, __req_EvaluatorConfig, ProtoBuf.DEF_FNUM, __val_EvaluatorConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::EvaluatorConfig) = ProtoBuf.protohash(v)
isequal(v1::EvaluatorConfig, v2::EvaluatorConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::EvaluatorConfig, v2::EvaluatorConfig) = ProtoBuf.protoeq(v1, v2)

type LinkConfig
    layer_name::AbstractString
    link_name::AbstractString
    has_subseq::Bool
    LinkConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type LinkConfig
const __req_LinkConfig = Symbol[:layer_name,:link_name]
const __val_LinkConfig = Dict(:has_subseq => false)
meta(t::Type{LinkConfig}) = meta(t, __req_LinkConfig, ProtoBuf.DEF_FNUM, __val_LinkConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::LinkConfig) = ProtoBuf.protohash(v)
isequal(v1::LinkConfig, v2::LinkConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::LinkConfig, v2::LinkConfig) = ProtoBuf.protoeq(v1, v2)

type MemoryConfig
    layer_name::AbstractString
    link_name::AbstractString
    boot_layer_name::AbstractString
    boot_bias_parameter_name::AbstractString
    boot_bias_active_type::AbstractString
    boot_with_const_id::UInt32
    is_sequence::Bool
    MemoryConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type MemoryConfig
const __req_MemoryConfig = Symbol[:layer_name,:link_name]
const __val_MemoryConfig = Dict(:is_sequence => false)
const __fnum_MemoryConfig = Int[1,2,3,4,5,7,6]
meta(t::Type{MemoryConfig}) = meta(t, __req_MemoryConfig, __fnum_MemoryConfig, __val_MemoryConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::MemoryConfig) = ProtoBuf.protohash(v)
isequal(v1::MemoryConfig, v2::MemoryConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::MemoryConfig, v2::MemoryConfig) = ProtoBuf.protoeq(v1, v2)

type GeneratorConfig
    max_num_frames::UInt32
    eos_layer_name::AbstractString
    num_results_per_sample::Int32
    beam_size::Int32
    log_prob::Bool
    GeneratorConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type GeneratorConfig
const __req_GeneratorConfig = Symbol[:max_num_frames,:eos_layer_name]
const __val_GeneratorConfig = Dict(:num_results_per_sample => 1, :beam_size => 1, :log_prob => true)
meta(t::Type{GeneratorConfig}) = meta(t, __req_GeneratorConfig, ProtoBuf.DEF_FNUM, __val_GeneratorConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::GeneratorConfig) = ProtoBuf.protohash(v)
isequal(v1::GeneratorConfig, v2::GeneratorConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::GeneratorConfig, v2::GeneratorConfig) = ProtoBuf.protoeq(v1, v2)

type SubModelConfig
    name::AbstractString
    layer_names::Array{AbstractString,1}
    input_layer_names::Array{AbstractString,1}
    output_layer_names::Array{AbstractString,1}
    evaluator_names::Array{AbstractString,1}
    is_recurrent_layer_group::Bool
    reversed::Bool
    memories::Array{MemoryConfig,1}
    in_links::Array{LinkConfig,1}
    out_links::Array{LinkConfig,1}
    generator::GeneratorConfig
    target_inlinkid::Int32
    SubModelConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type SubModelConfig
const __req_SubModelConfig = Symbol[:name]
const __val_SubModelConfig = Dict(:is_recurrent_layer_group => false, :reversed => false)
meta(t::Type{SubModelConfig}) = meta(t, __req_SubModelConfig, ProtoBuf.DEF_FNUM, __val_SubModelConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::SubModelConfig) = ProtoBuf.protohash(v)
isequal(v1::SubModelConfig, v2::SubModelConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::SubModelConfig, v2::SubModelConfig) = ProtoBuf.protoeq(v1, v2)

type ModelConfig
    _type::AbstractString
    layers::Array{LayerConfig,1}
    parameters::Array{ParameterConfig,1}
    input_layer_names::Array{AbstractString,1}
    output_layer_names::Array{AbstractString,1}
    evaluators::Array{EvaluatorConfig,1}
    sub_models::Array{SubModelConfig,1}
    external_config::ExternalConfig
    ModelConfig(; kwargs...) = (o=new(); fillunset(o); isempty(kwargs) || ProtoBuf._protobuild(o, kwargs); o)
end #type ModelConfig
const __req_ModelConfig = Symbol[:_type]
const __val_ModelConfig = Dict(:_type => "nn")
const __fnum_ModelConfig = Int[1,2,3,4,5,6,8,9]
meta(t::Type{ModelConfig}) = meta(t, __req_ModelConfig, __fnum_ModelConfig, __val_ModelConfig, true, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
hash(v::ModelConfig) = ProtoBuf.protohash(v)
isequal(v1::ModelConfig, v2::ModelConfig) = ProtoBuf.protoisequal(v1, v2)
==(v1::ModelConfig, v2::ModelConfig) = ProtoBuf.protoeq(v1, v2)

export ExternalConfig, ActivationConfig, ConvConfig, PoolConfig, SppConfig, NormConfig, BlockExpandConfig, MaxOutConfig, ProjectionConfig, OperatorConfig, BilinearInterpConfig, ImageConfig, PriorBoxConfig, PadConfig, LayerInputConfig, LayerConfig, EvaluatorConfig, LinkConfig, MemoryConfig, GeneratorConfig, SubModelConfig, ModelConfig
