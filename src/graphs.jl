
export DiGraph, add_edge!, remove_edge!, nodes, edges, query

struct DiGraph
    edges::Set{Pair{}}

    DiGraph() = new(Set{Pair}())
end


"""
    add_edge!(::DiGraph, from, to)
    add_edge!(::DiGraph, ::Pair)
Add an edge to the DiGraph going between the specified nodes.
"""
function add_edge! end

function add_edge!(graph::DiGraph, from, to)::DiGraph
    push!(graph.edges, Pair(from, to))
    graph
end

function add_edge!(graph::DiGraph, edge::Pair)::DiGraph
    add_edge!(graph, edge.first, edge.second)
end


"""
    remove_edge!(::DiGraph, from, to)
    remove_edge!(::DiGraph, ::Pair)
Remove the edge of the DiGraph going between the specified nodes.
"""
function remove_edge! end

function remove_edge!(graph::DiGraph, edge::Pair)::DiGraph
    delete!(graph.edges, edge)
    graph
end

function remove_edge!(graph::DiGraph, from, to)::DiGraph
    remove_edge!(graph, from => to)
    graph
end


# Dict interface:
Base.keys(graph::DiGraph) = Set([p.first for p in graph.edges])
Base.values(graph::DiGraph) = Set([p.second for p in graph.edges])

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

