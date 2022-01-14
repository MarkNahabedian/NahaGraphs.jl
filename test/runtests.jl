using NahaGraphs
using Test
using Logging

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

@testset "DiGraph as Dict" begin
    g = DiGraph()
    add_edge!(g, :a => 1)
    add_edge!(g, :b => 2)
    add_edge!(g, :c => 3)
    add_edge!(g, :c => 31)
    @test haskey(g, :b)
    @test !haskey(g, :x)
    @test g[:b] == Set(2)
    @test g[:c] == Set([3, 31])
end

@testset "transform" begin
    g = DiGraph()
    nodes = [:a, :b, :c]
    for from in nodes, to in nodes
        add_edge!(g, from, to)
    end
    @test length(edges(g)) == 9
    # Replace self-edges with an arc through node :x:
    # Don't modify edges until iteration is complete:
    add = Set()
    remove = Set()
    for edge in edges(g)
        if edge.first == edge.second
            push!(add, edge.first => :x)
            push!(add, :x => edge.second)
            push!(remove, edge)
        end
    end
    transform!(g, add, remove)
    #test nodes(g) == Set([:a, :b, :c, :x])
    @test length(edges(g)) == 12
end

@testset "transformingGraph! and applyRule!" begin
    g = DiGraph()
    nodes = [:a, :b, :c]
    for from in nodes, to in nodes
        add_edge!(g, from, to)
    end
    @test length(edges(g)) == 9
    function rule(g, node)
        transformingGraph!() do check, add, remove
            for edge in query(g, node, node)
                add(edge.first => :x)
                add(:x => edge.second)
                remove(edge)
            end
        end
    end
    applyRule!(g, rule)
    #test nodes(g) == Set([:a, :b, :c, :x])
    @test length(edges(g)) == 12
end

