# Test wrapping a DiGraph to specialize behavior.

struct MyGraph
    graph::DiGraph

    MyGraph() = new(DiGraph())
end

# Delegate:

NahaGraphs.edges(g::MyGraph) = edges(g.graph)
NahaGraphs.nodes(g::MyGraph) = nodes(g.graph)
NahaGraphs.add_edge!(g::MyGraph, edge) = add_edge!(g.graph, edge)
NahaGraphs.remove_edge!(g::MyGraph, edge) = remove_edge!(g.graph, edge)
NahaGraphs.query(g::MyGraph, from, to) = query(g.graph, from, to)

# Delegation for Dict support:
Base.keys(g::MyGraph) = keys(g.graph)
Base.values(g::MyGraph) = values(g.graph)
Base.haskey(g::MyGraph, key) = haskey(g.graph, key)
Base.getindex(g::MyGraph, key) = getindex(g.graph, key)

