for fn in [:aesenc, :aesenclast, :aesdec, :aesdeclast]
    str = """
    declare <2 x i64> @llvm.x86.aesni.$fn(<2 x i64>, <2 x i64>)

    define <16 x i8> @entry(<16 x i8>, <16 x i8>) alwaysinline {
    top:
        %a0 = bitcast <16 x i8> %0 to <2 x i64>
        %a1 = bitcast <16 x i8> %1 to <2 x i64>
        %val = tail call <2 x i64> @llvm.x86.aesni.$fn(<2 x i64> %a0, <2 x i64> %a1)
        %casted = bitcast <2 x i64> %val to <16 x i8>
        ret <16 x i8> %casted
    }
    """

    @eval function $fn(a::SIMD.Vec{16,UInt8}, b::SIMD.Vec{16,UInt8})
        Base.@_inline_meta
        x = Base.llvmcall(
            ($str, "entry"),
            SIMD.LVec{16,UInt8},
            Tuple{SIMD.LVec{16,UInt8},SIMD.LVec{16,UInt8}},
            a.data,
            b.data,
        )
        return SIMD.Vec(x)
    end
end

function aesimc(a::SIMD.Vec{16,UInt8})
    str = """
    declare <2 x i64> @llvm.x86.aesni.aesimc(<2 x i64>)

    define <16 x i8> @entry(<16 x i8>) alwaysinline {
    top:
        %a0 = bitcast <16 x i8> %0 to <2 x i64>
        %val = tail call <2 x i64> @llvm.x86.aesni.aesimc(<2 x i64> %a0)
        %casted = bitcast <2 x i64> %val to <16 x i8>
        ret <16 x i8> %casted
    }
    """
    Base.@_inline_meta
    x = Base.llvmcall(
        (str, "entry"),
        SIMD.LVec{16,UInt8},
        Tuple{SIMD.LVec{16,UInt8}},
        a.data,
    )
    return SIMD.Vec(x)
end

function aeskeygenassist(a::SIMD.Vec{4,UInt32}, ::Val{N}) where {N}
    return reinterpret(
        SIMD.Vec{4,UInt32},
        aeskeygenassist(reinterpret(SIMD.Vec{16,UInt8}, a), Val{N}()),
    )
end
@generated function aeskeygenassist(a::SIMD.Vec{16,UInt8}, ::Val{N}) where {N}
    str = """
    declare <2 x i64> @llvm.x86.aesni.aeskeygenassist(<2 x i64>, i8)
    define <16 x i8> @entry(<16 x i8>, i8) alwaysinline {
    top:
        %a0 = bitcast <16 x i8> %0 to <2 x i64>
        %val = tail call <2 x i64> @llvm.x86.aesni.aeskeygenassist(<2 x i64> %a0, i8 $N)
        %casted = bitcast <2 x i64> %val to <16 x i8>
        ret <16 x i8> %casted
    }
    """
    return quote
        Base.@_inline_meta
        x = Base.llvmcall(
            ($str, "entry"),
            SIMD.LVec{16,UInt8},
            Tuple{SIMD.LVec{16,UInt8}},
            a.data,
        )
        return SIMD.Vec(x)
    end
end

