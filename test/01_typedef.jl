module TestTypeDef
    using Base.Test
    using CategoricalData

    @test CategoricalData.RefType === UInt

    for (P, V) in ((NominalPool, NominalValue), (OrdinalPool, OrdinalValue))
        pool = P(
            [
                "a",
                "b",
                "c"
            ],
            Dict(
                "a" => convert(CategoricalData.RefType, 1),
                "b" => convert(CategoricalData.RefType, 2),
                "c" => convert(CategoricalData.RefType, 3),
            )
        )

        @test isa(pool, P)

        @test isa(pool.index, Vector)
        @test length(pool.index) == 3
        @test pool.index[1] == "a"
        @test pool.index[2] == "b"
        @test pool.index[3] == "c"

        @test isa(pool.invindex, Dict)
        @test length(pool.invindex) == 3
        @test pool.invindex["a"] === convert(CategoricalData.RefType, 1)
        @test pool.invindex["b"] === convert(CategoricalData.RefType, 2)
        @test pool.invindex["c"] === convert(CategoricalData.RefType, 3)

        @test isa(pool.order, Vector{CategoricalData.RefType})
        @test length(pool.order) == 3
        @test pool.order[1] === convert(CategoricalData.RefType, 1)
        @test pool.order[2] === convert(CategoricalData.RefType, 2)
        @test pool.order[3] === convert(CategoricalData.RefType, 3)

        # TODO: Need constructors that take in arbitrary integers
        for i in 1:3
            x = V(convert(CategoricalData.RefType, i), pool)

            @test isa(x, V)

            @test isa(x.level, CategoricalData.RefType)
            @test x.level === convert(CategoricalData.RefType, i)

            @test isa(x.pool, P)
            @test x.pool === pool
        end

        opool = P(
            [
                "a",
                "b",
                "c"
            ],
            Dict(
                "a" => convert(CategoricalData.RefType, 1),
                "b" => convert(CategoricalData.RefType, 2),
                "c" => convert(CategoricalData.RefType, 3),
            ),
            [
                convert(CategoricalData.RefType, 3),
                convert(CategoricalData.RefType, 2),
                convert(CategoricalData.RefType, 1),
            ]
        )

        @test isa(opool, P)

        @test isa(opool.index, Vector)
        @test length(opool.index) == 3
        @test opool.index[1] == "a"
        @test opool.index[2] == "b"
        @test opool.index[3] == "c"

        @test isa(opool.invindex, Dict)
        @test length(opool.invindex) == 3
        @test opool.invindex["a"] === convert(CategoricalData.RefType, 1)
        @test opool.invindex["b"] === convert(CategoricalData.RefType, 2)
        @test opool.invindex["c"] === convert(CategoricalData.RefType, 3)

        @test isa(opool.order, Vector{CategoricalData.RefType})
        @test length(opool.order) == 3
        @test opool.order[1] === convert(CategoricalData.RefType, 3)
        @test opool.order[2] === convert(CategoricalData.RefType, 2)
        @test opool.order[3] === convert(CategoricalData.RefType, 1)

        for i in 1:3
            y = V(convert(CategoricalData.RefType, i), opool)

            @test isa(y, V)

            @test isa(y.level, CategoricalData.RefType)
            @test y.level === convert(CategoricalData.RefType, i)

            @test isa(y.pool, P)
            @test y.pool === opool
        end
    end
end
