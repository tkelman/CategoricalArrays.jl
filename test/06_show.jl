module TestShow
    using Base.Test
    using CategoricalData

    pool = CategoricalPool(["c", "b", "a"])

    opool = CategoricalPool(["c", "b", "a"], ["a", "b", "c"])

    nv1 = OrdinalValue(1, pool)
    nv2 = OrdinalValue(2, pool)
    nv3 = OrdinalValue(3, pool)

    ov1 = OrdinalValue(1, opool)
    ov2 = OrdinalValue(2, opool)
    ov3 = OrdinalValue(3, opool)

    @test string(pool) == "CategoricalPool{String}([\"a\",\"b\",\"c\"])"
    @test string(opool) == "CategoricalPool{String}([\"a\",\"b\",\"c\"])"

    @test string(nv1) == "OrdinalValue{String} \"c\" (3/3)"
    @test string(nv2) == "OrdinalValue{String} \"b\" (2/3)"
    @test string(nv3) == "OrdinalValue{String} \"a\" (1/3)"

    @test string(ov1) == "OrdinalValue{String} \"c\" (3/3)"
    @test string(ov2) == "OrdinalValue{String} \"b\" (2/3)"
    @test string(ov3) == "OrdinalValue{String} \"a\" (1/3)"

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
