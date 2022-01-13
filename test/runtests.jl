using NahaGraphs
using Test

@testset "DiGraph" begin
    g = DiGraph()
    add_edge!(g, :a, :a1)
    add_edge!(g, :a, :a2)
    add_edge!(g, :a1, :b)
    add_edge!(g, :a2, :b)
    @test keys(g) == Set([:a, :a1, :a2])
    @test values(g) == Set([:a1, :a2, :b])
    @test nodes(g) == Set([:a, :b, :a1, :a2])
    @test query(g, Symbol, Symbol) == g.edges
    @test query(g, :a, Any) == Set([:a => :a1, :a => :a2])
    @test query(g, Any, :b) == Set([:a1 => :b, :a2 => :b])
    remove_edge!(g, :a2 => :b)
    @test query(g, Any, :b) == Set([:a1 => :b])
end
