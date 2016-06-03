module TestConvert
    using Base.Test
    using CategoricalData

    pool = CategoricalPool([1, 2, 3])
    convert(CategoricalPool{Float64}, pool)
    convert(CategoricalPool, pool)
    convert(CategoricalPool{Float64}, pool)
    convert(CategoricalPool, pool)

    nv1 = NominalValue(1, pool)
    nv2 = NominalValue(2, pool)
    nv3 = NominalValue(3, pool)

    convert(Int32, nv1)
    convert(Int32, nv2)
    convert(Int32, nv3)

    convert(UInt8, nv1)
    convert(UInt8, nv2)
    convert(UInt8, nv3)

    opool = CategoricalPool([1, 2, 3], [3, 2, 1])
    convert(CategoricalPool{Float64}, opool)
    convert(CategoricalPool, opool)
    convert(CategoricalPool{Float64}, opool)
    convert(CategoricalPool, opool)

    ov1 = OrdinalValue(1, opool)
    ov2 = OrdinalValue(2, opool)
    ov3 = OrdinalValue(3, opool)

    convert(Int32, ov1)
    convert(Int32, ov2)
    convert(Int32, ov3)

    convert(UInt8, ov1)
    convert(UInt8, ov2)
    convert(UInt8, ov3)
end
