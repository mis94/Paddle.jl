using PyCall
include("JlDataProvider.jl")

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

    scan::Function
    extend_cols::Function
    finish_scan::Function

    function SparseBinaryScanner(input_types, pos)
        this = new()
        this.input_types = input_types
        this.pos = pos
        this.__rows__ = []
        push!(this.__rows__, 0)
        this.__cols__ = []
        this.__height__ = 0
        this.__nnz__ = 0
        this.__value__ = []

        this.scan = function (dat)
            this.extend_cols(dat)
            push!(this.__rows__, length(this.__cols__))
            this.__height__ = this.__height__ + 1

        end

        this.extend_cols = function (dat)
            append!(this.__cols__, dat)
        end

        this.finish_scan = function (argument)

            #println("_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+")
            #println(this.__height__)
            #println(this.input_types.dim)
            #println(length(this.__cols__))
            #println(this.__value__)
            #println(length(this.__value__) == 0)
            #println("_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+")
            
            m = api.Matrix[:createSparse](this.__height__,
                                                this.input_types.dim,
                                                length(this.__cols__),
                                                length(this.__value__) == 0)


            m[:sparseCopyFrom](this.__rows__, this.__cols__, this.__value__)
            argument[:setSlotValue](this.pos, m)
        end
        return this
    end
end

type IndexScanner
    input_types
    pos
    __ids__

    scan::Function
    finish_scan::Function


    function IndexScanner(input_types, pos)
        this = new()
        this.input_types = input_types
        this.pos = pos
        this.__ids__ = []

        this.scan = function(dat)
            append!(this.__ids__, dat)
        end

        this.finish_scan = function (argument)
            ids = api.IVector[:create](this.__ids__)
            argument[:setSlotIds](this.pos, ids)
        end

        return this
    end
    
end


type DataProviderConverter

    input_types
    convert::Function
    create_scanner::Function

	function DataProviderConverter(input_types)

        this = new()
        this.input_types = input_types
        this.convert = function(dat, argument=nothing)

            if argument == nothing
                argument = api.Arguments[:createArguments](0)
            end

            argument[:resize](length(this.input_types))


            scanners = []
            i = 0
            for each_type in this.input_types
                temp = this.create_scanner(i, each_type)
                push!(scanners, temp)
                i = i + 1
            end

            #println(typeof(dat[1][1]))
            #println(typeof(dat[1][1][1]))

            for each_sample in dat
                for (each_step, scanner) in zip(each_sample, scanners)
                    scanner.scan(each_step)
                end
            end

            for scanner in scanners
                scanner.finish_scan(argument)
            end

            return argument
        end

        this.create_scanner = function create_scanner(i, each)
            retv = nothing
            if each._type == Dense
                retv = DenseScanner(each, i)
            elseif each._type == Index
                retv = IndexScanner(each, i)
            elseif each._type == SparseNonValue
                retv = SparseBinaryScanner(each, i)
            elseif each._type == SparseValue
                retv = SparseFloatScanner(each, i)
            end

            if each.seq_type == SUB_SEQUENCE

                tempFn = function(a,p,seq)
                    a[:setSlotSubSequenceStartPositions](p, seq)
                end
                retv = SequenceScanner( each, i, retv, tempFn)
            end

            if each.seq_type in [SUB_SEQUENCE, SEQUENCE]
                
                tempFn = function(a,p,seq)
                    a[:setSlotSequenceStartPositions](p, seq)
                end

                retv = SequenceScanner(each, i, retv, tempFn)
            end
            return retv
        end

        return this
    end
end