
using PyCall

@pyimport py_paddle.swig_paddle as api

abstract IScanner

type SparseBinaryScanner <: IScanner
    input_types
    pos
    __rows__
    __cols__
    __height__
    __nnz__
    __value__

    function SparseBinaryScanner(input_type, pos)
        this = new()
        this.input_types = input_types
        this.pos = pos
        this.__rows__ = [0]
        this.__cols__ = []
        this.__height__ = 0
        this.__nnz__ = 0
        this.__value__ = []
        return this
    end

    function scan(self, dat)
        this.extend_cols(dat)
        push!(this.__rows__, len(self.__cols__))
        this.__height__ = this.__height__ + 1
    end

    function extend_cols(self, dat)
        append!(this.__cols__, dat)
    end

    function finish_scan(self, argument)
        m = api.Matrix.createSparse(this.__height__,
                                            this.input_type.dim,
                                            len(this.__cols__),
                                            len(this.__value__) == 0)
        m.sparseCopyFrom(this.__rows__, this.__cols__, this.__value__)
        argument.setSlotValue(this.pos, m)
    end
end

type IndexScanner
    input_types
    pos
    __ids__

    function IndexScanner(input_type, pos)
        this = new()
        this.input_types = input_types
        this.pos = pos
        this.__ids__ = []

        return this
    end

    function scan(dat)
        push!(this.__ids__, dat)
    end

    function finish_scan(argument)
        ids = api.IVector.create(this.__ids__)
        argument.setSlotIds(self.pos, ids)
    
end


type DataProviderConverter

    input_types

	function DataProviderConverter(input_types)

        this = new()
        this.input_types = input_types
        return this
	end

    function convert(dat; argument=nothing)
        if argument == nothing:
            argument = api.Arguments.createArguments(0)
        end

        argument.resize(len(this.input_types))

        scanner = []
        i = 0
        for each_type in this.input_types
            temp = DataProviderConverter.create_scanner(i, each_type)
            push!(scanner, temp)
            i = i + 1
        end

        for each_sample in dat
            for (each_step, scanner) in zip(each_sample, scanners):
                scanner.scan(each_step)
            end
        end

        for scanner in scanners:
            scanner.finish_scan(argument)
        end

        return argument
    end

    function create_scanner(i, each):
        retv = nothing
        if each.type == JLDataProvider2.Dense
            retv = DenseScanner(each, i)
        elseif each.type == JLDataProvider2.Index
            retv = IndexScanner(each, i)
        elseif each.type == JLDataProvider2.SparseNonValue
            retv = SparseBinaryScanner(each, i)
        elseif each.type == JLDataProvider2.SparseValue
            retv = SparseFloatScanner(each, i)
        end

        if each.seq_type == JLDataProvider2.SUB_SEQUENCE

            tempFn = function(a,p,seq)
                a.setSlotSubSequenceStartPositions(p, seq)
            end
            retv = SequenceScanner( each, i, retv, tempFn)
        end

        if each.seq_type in [JLDataProvider2.SUB_SEQUENCE, JLDataProvider2.SEQUENCE]
            
            tempFn = function(a,p,seq)
                a.setSlotSequenceStartPositions(p, seq)
            end

            retv = SequenceScanner(each, i, retv, tempFn)
        end
        return retv
    end
end