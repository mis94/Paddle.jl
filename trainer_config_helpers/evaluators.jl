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
        push!(input, label)
    end

    if weight != nothing
        push!(input, weight)
    end
    inputs = [i.name for i in input]
    Evaluator(
          name,
          etype,
          inputs,
          chunk_scheme=chunk_scheme,
          num_chunk_types=num_chunk_types,
          classification_threshold=classification_threshold,
          positive_label=positive_label,
          dict_file=dict_file,
          result_file=result_file,
          delimited=delimited,
          excluded_chunk_types=excluded_chunk_types, )

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
