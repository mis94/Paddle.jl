# evaluators file
function evaluator_base(
        input,
        etype;
        label=nothing,
        weight=nothing,
        name=nothing,
        chunk_scheme=nothing,
        num_chunk_types=nothing,
        classification_threshold=nothing,
        positive_label=nothing,
        dict_file=nothing,
        result_file=nothing,
        num_results=nothing,
        delimited=nothing,
        top_k=nothing,
        excluded_chunk_types=nothing)

    @assert classification_threshold == nothing || isa( classification_threshold, AbstractFloat)
    @assert positive_label == nothing || isa(positive_label, Int)
    @assert num_results == nothing ||isa(num_results, Int)
    @assert top_k == nothing || isa(top_k, Int)
    if !isa(input, Array)
        input = [input]
    end

    if label != nothing
        append!(input, label)
    end

    if weight != nothing
        append!(input, weight)
    end

end

function classification_error_evaluator(
                                input,
                                label;
                                name=nothing,
                                weight=nothing,
                                top_k=nothing,
                                threshold=nothing)
     evaluator_base(
        input,
        "classification_error",
        name=name,
        label=label,
        weight=weight,
        top_k=top_k,
        classification_threshold=threshold)
end
classification_error_evaluator(1, 1)