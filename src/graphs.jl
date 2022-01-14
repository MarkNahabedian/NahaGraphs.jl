
export DiGraph, add_edge!, remove_edge!, nodes, edges, query

struct DiGraph
    edges::Set{Pair{}}

    DiGraph() = new(Set{Pair}())
end

function add_edge!(graph::DiGraph, from, to)::DiGraph
    push!(graph.edges, Pair(from, to))
    graph
end

function remove_edge!(graph::DiGraph, edge::Pair)::DiGraph
    delete!(graph.edges, edge)
    graph
end


# Dict interface:
Base.keys(graph::DiGraph) = Set([p.first for p in graph.edges])
Base.values(graph::DiGraph) = Set([p.second for p in graph.edges])

function Base.getindex(graph::DiGraph, key)::Set
    (p -> p.second).(filter(p -> p.first == key, graph.edges))
end


nodes(graph::DiGraph) = union(keys(graph), values(graph))

edges(graph::DiGraph) = graph.edges

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

