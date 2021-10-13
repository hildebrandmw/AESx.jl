module AESx

# deps
import SIMD

# implementation
include("intrinsics.jl")
include("utils.jl")
include("aes128.jl")

function aes128(
    data::SIMD.Vec{16,UInt8},
    white::SIMD.Vec{16,UInt8},
    keys::NTuple{10,SIMD.Vec{16,UInt8}},
)
    # We want this to be inlined to try to keep `keys` in registers.
    Base.@_inline_meta
    data = xor(data, white)
    for i in Base.OneTo(9)
        data = aesenc(data, @inbounds(keys[i]))
    end
    return aesenclast(data, @inbounds(keys[10]))
end

end
