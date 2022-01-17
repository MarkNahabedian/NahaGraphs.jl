# Transforming a graph By adding and removing nodes and edges.

using UUIDs

export transform!, applyRule!, transformingGraph!

function transform!(graph::DiGraph, addarcs, removearcs)
    setdiff!(graph.edges, removearcs)
    union!(graph.edges, addarcs)
    graph
end


"""
    applyRule!(graph, rule)
Apply rule to each node of graph and modify the graph's edges
as determined by rule.  Rule is a function that takes the graph
and a node as arguments and returns the set of edges to add and
the set of edges to remove.
"""
function applyRule!(graph, rule)
    nodes(graph) .|>
	(node -> rule(graph, node)) .|>
	(add_remove -> transform!(graph, add_remove...))
    nothing
end


struct NonlocalTransfer <: Exception
    uid

    function NonlocalTransfer()
        new(UUIDs.uuid1())
    end
end

function Base.showerror(io::IO, e::NonlocalTransfer)
    print(io, "NonlocalTransfer not caught!")
end

function transformingGraph!(f)
    addset = Set()
    removeset = Set()
    exittag = NonlocalTransfer()
    add(arc) = push!(addset, arc)
    remove(arc) = push!(removeset, arc)
    function check(condition)
	if !condition
	    throw(exittag)
	end
    end
    try
	f(check, add, remove)
    catch e
	if e != exittag
	    rethrow(e)
	end
    end
    return addset, removeset
end

