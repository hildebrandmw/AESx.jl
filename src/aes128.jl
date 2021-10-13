struct AES128 end

function _key_expand(::AES128, x::SIMD.Vec{4,UInt32}, key::SIMD.Vec{4,UInt32})
    Base.@_inline_meta
    fourback = SIMD.Vec{4,UInt32}(x[4])
    shifted = leftshift(key)
    key = xor(key, shifted)
    shifted = leftshift(key)
    key = xor(key, shifted)
    shifted = leftshift(key)
    key = xor(key, shifted, fourback)
    return key
end

function key_expand(aes::AES128, k1::SIMD.Vec{4,UInt32})
    # round 1
    # round 2
    tmp = aeskeygenassist(k1, Val(0x01))
    k2 = _key_expand(aes, tmp, k1)
    # round 3
    tmp = aeskeygenassist(k2, Val(0x02))
    k3 = _key_expand(aes, tmp, k2)
    # round 4
    tmp = aeskeygenassist(k3, Val(0x04))
    k4 = _key_expand(aes, tmp, k3)
    # round 5
    tmp = aeskeygenassist(k4, Val(0x08))
    k5 = _key_expand(aes, tmp, k4)
    # round 6
    tmp = aeskeygenassist(k5, Val(0x10))
    k6 = _key_expand(aes, tmp, k5)
    # round 7
    tmp = aeskeygenassist(k6, Val(0x20))
    k7 = _key_expand(aes, tmp, k6)
    # round 8
    tmp = aeskeygenassist(k7, Val(0x40))
    k8 = _key_expand(aes, tmp, k7)
    # round 9
    tmp = aeskeygenassist(k8, Val(0x80))
    k9 = _key_expand(aes, tmp, k8)
    # round 10
    tmp = aeskeygenassist(k9, Val(0x1b))
    k10 = _key_expand(aes, tmp, k9)
    # round 11
    tmp = aeskeygenassist(k10, Val(0x36))
    k11 = _key_expand(aes, tmp, k10)
    return (k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11)
end
