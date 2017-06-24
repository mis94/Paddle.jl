NO_SEQUENCE = 0
SEQUENCE = 1
SUB_SEQUENCE = 2

Dense = 0
SparseNonValue = 1
SparseValue = 2
Index = 3

type InputType

    __slots__
    dim
    seq_type
    _type

    function InputType(dim, seq_type, tp)

        this = new()

        this.__slots__ = ["dim", "seq_type", "type"]
        this.dim = dim
        this.seq_type = seq_type
        this._type = tp

        return this
    end
end

function integer_value_sequence(dim)
    return InputType(dim, SEQUENCE, Index)
end

function sparse_binary_vector(dim, seq_type=NO_SEQUENCE)
    return InputType(dim, seq_type, SparseNonValue)
end

function integer_value(dim, seq_type=NO_SEQUENCE)
    return InputType(dim, seq_type, Index)
end