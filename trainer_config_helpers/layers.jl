# layers file

type LayerType
    # layer type enumerations
    DATA::AbstractString
    is_layer_type::Function

    function LayerType()
        this = new()

        this.DATA = "data"

        this.is_layer_type = function(type_name)
            println(type_name)
        end

        return this
    end
end


layerType = LayerType()

#println(typeof(layerType))
#println(layerType.DATA)
#layerType.is_layer_type("I hope this is printed")