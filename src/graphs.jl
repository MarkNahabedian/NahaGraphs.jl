
export DiGraph, add_edge!, remove_edge!, nodes, edges, query

struct DiGraph
    edges::Set{Pair{}}

    DiGraph() = new(Set{Pair}())
end

function DiGraph(graph::DiGraph)
    new_graph = DiGraph()
    for e in edges(graph)
        add_edge!(new_graph, e.first => e.second)
    end
    new_graph
end


"""
    add_edge!(graph, from, to)
    add_edge!(::DiGraph, ::Pair)
Add an edge to the DiGraph going between the specified nodes.
The graph is returned.
"""
function add_edge! end

function add_edge!(graph, from, to)
    add_edge!(graph, from => to)
    graph
end

function add_edge!(graph::DiGraph, edge::Pair)
    push!(graph.edges, edge)
    graph
end


"""
    remove_edge!(graph, from, to)
    remove_edge!(::DiGraph, ::Pair)
Remove the edge of the DiGraph going between the specified nodes.
The graph is returned.
"""
function remove_edge! end

function remove_edge!(graph::DiGraph, edge::Pair)::DiGraph
    delete!(graph.edges, edge)
    graph
end

function remove_edge!(graph, from, to)
    remove_edge!(graph, from => to)
    graph
end


# Dict interface:
Base.keys(graph::DiGraph) = Set([p.first for p in graph.edges])
Base.values(graph::DiGraph) = Set([p.second for p in graph.edges])

function Base.haskey(graph::DiGraph, key)::Bool
    !isempty(filter(edge -> edge.first == key, graph.edges))
end

function Base.getindex(graph::DiGraph, key)::Set
    Set((p -> p.second).(filter(p -> p.first == key, graph.edges)))
end


nodes(graph::DiGraph) = union(keys(graph), values(graph))

edges(graph::DiGraph) = graph.edges


"""
    query(::DiGraph, from, to)
Return the `Set` of edges that match the query.
`from` and `to` can be objects or types, so, for example,
`query(graph, Number, :a)` returns all of the edges that
go from any `Number` to the `Symbol` `:a`.
"""
function query(graph::DiGraph, from, to)::Set
    function querytest(elt, val)
        if val isa Type
            elt isa val
        else
            elt == val
        end
    end
    filter(p -> querytest(p.first, from) && querytest(p.second, to),
           graph.edges)
end

