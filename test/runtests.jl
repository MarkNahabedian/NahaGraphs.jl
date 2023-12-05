using NahaGraphs
using Test
using Logging


function unless_ci(f)
    if !haskey(ENV, "GITHUB_ACTIONS")
        f()
    end
end

@testset "DiGraph" begin
    g = DiGraph()
    add_edge!(g, :a, :a1)
    add_edge!(g, :a, :a2)
    add_edge!(g, :a1, :b)
    add_edge!(g, :a2, :b)
    @test keys(g) == Set([:a, :a1, :a2])
    @test values(g) == Set([:a1, :a2, :b])
    @test nodes(g) == Set([:a, :b, :a1, :a2])
    @test query(g, Symbol, Symbol) == edges(g)
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

function transform_test(graph_type)
    g = graph_type()
    nodes = [:a, :b, :c]
    for from in nodes, to in nodes
        add_edge!(g, from, to)
    end
    @test length(edges(g)) == 9
    function rule(g, node)
        # Replace all self-edges with edges to and from the new node
        # :x:
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

@testset "transformingGraph! and applyRule!" begin
    transform_test(DiGraph)
end


include("mygraph.jl")

@testset "transform wrapped DiGraph" begin
    transform_test(MyGraph)
end

@testset "generic dot" begin
    # Just test that we can write a Dot file without error.  If Dot is
    # available, run it on that file as a validation step.
    g = DiGraph()
    nodes = [:a, :b, :c]
    for from in nodes, to in nodes
        if from == to
            add_edge!(g, from, :x)
            add_edge!(g, :x, to)
        else
            add_edge!(g, from, to)
        end
    end
    dotfile = joinpath(@__DIR__, "generic_dot_test.dot")
    dotgraph(dotfile, g, nothing)
    try
        rundot(dotfile)
    catch e
        @error "Running dot failed:", e
    end
end

@testset "dark mode dot style" begin
    g = DiGraph()
    nodes = [:a, :b, :c]
    for from in nodes, to in nodes
        if from == to
            add_edge!(g, from, :x)
            add_edge!(g, :x, to)
        else
            add_edge!(g, from, to)
        end
    end
    dotfile = joinpath(@__DIR__, "dotstyle_test.dot")
    @info dotfile
    rm(dotfile; force=true)
    dotgraph(dotfile, g, DotStyleWhiteOnBlack())
    try
        rundot(dotfile)
    catch e
        @error "Running dot failed:", e
    end
end

@testset "rundot output file type" begin
    g = DiGraph()
    nodes = [:a, :b, :c]
    for from in nodes, to in nodes
        add_edge!(g, from, to)
    end
    svgfile = joinpath(@__DIR__, "dotgraph_output_file_type_test.svg")
    @info svgfile
    rm(svgfile; force=true)
    dotgraph(svgfile, g, DotStyleWhiteOnBlack)
    @test isfile(svgfile)
end

