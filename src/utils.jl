function leftshift(x::T) where {T<:SIMD.Vec}
    return reinterpret(T, leftshift(reinterpret(SIMD.Vec{4,UInt32}, x)))
end

function leftshift(x::SIMD.Vec{4,UInt32})
    return SIMD.Vec{4,UInt32}((zero(UInt32), x[1], x[2], x[3]))
end

