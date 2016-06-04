module TestShow
    using Base.Test
    using CategoricalData

    pool = NominalPool(["c", "b", "a"])

    opool = OrdinalPool(["c", "b", "a"], ["a", "b", "c"])

    nv1 = NominalValue(1, pool)
    nv2 = NominalValue(2, pool)
    nv3 = NominalValue(3, pool)

    ov1 = OrdinalValue(1, opool)
    ov2 = OrdinalValue(2, opool)
    ov3 = OrdinalValue(3, opool)

    @test string(pool) == "CategoricalData.NominalPool{String}([\"a\",\"b\",\"c\"])"
    @test string(opool) == "CategoricalData.OrdinalPool{String}([\"a\",\"b\",\"c\"])"

    @test string(nv1) == "CategoricalData.NominalValue{String} \"c\""
    @test string(nv2) == "CategoricalData.NominalValue{String} \"b\""
    @test string(nv3) == "CategoricalData.NominalValue{String} \"a\""

    @test string(ov1) == "CategoricalData.OrdinalValue{String} \"c\" (3/3)"
    @test string(ov2) == "CategoricalData.OrdinalValue{String} \"b\" (2/3)"
    @test string(ov3) == "CategoricalData.OrdinalValue{String} \"a\" (1/3)"

    b = IOBuffer()
    showcompact(b, nv1)
    @test takebuf_string(b) == "\"c\""
    showcompact(b, nv2)
    @test takebuf_string(b) == "\"b\""
    showcompact(b, nv3)
    @test takebuf_string(b) == "\"a\""

    showcompact(b, ov1)
    @test takebuf_string(b) == "\"c\""
    showcompact(b, ov2)
    @test takebuf_string(b) == "\"b\""
    showcompact(b, ov3)
    @test takebuf_string(b) == "\"a\""
end
