# Transforming a graph By adding and removing nodes and edges.

using UUIDs

export transform!, applyRule!, transformingGraph!

"""
    transform!(graph, addarcs, removearcs)

Remove the `removearcs` from `graph` then
add the `addarcs` to `graph`, then 
"""
function transform!(graph, addarcs, removearcs)
    (e -> remove_edge!(graph, e)).(removearcs)
    (e -> add_edge!(graph, e)).(addarcs)
    graph
end


"""
    applyRule!(graph, rule)

Apply `rule` to each node of graph and modify the graph's edges
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


"""
NonlocalReturn is a type of exception that allows us to use `throw`
and `catch` to implement nonlocal return to a more distant stack
frame.

Usage:
```
begin
    exittag = NonlocalReturn()
    # An example recursive function which might need to return
    # to this context from across many stack frames:
    function f()
        if rand(1:5) == 1
            throw(exitrtag)
        end
        f()
        f()
    end
    try
	f()
    catch e
	if e != exittag
	    rethrow(e)
	end
    end
    # f has done a non-local return
end
```
"""
struct NonlocalReturn <: Exception
    uid

    function NonlocalReturn()
        new(UUIDs.uuid1())
    end
end

function Base.showerror(io::IO, e::NonlocalReturn)
    print(io, "NonlocalReturn not caught!")
end


"""
    transformingGraph!(f)

Calls `f` with three arguments:

  a `check` function of one argument which will perform a 
  non-local return if that argument is false;

  an `add` function which is used to collect edges that should
  be added to a graph;

  a `remove` function used to accumulate edges that should be
  removed from a graph.

`transformingGraph!` returns the accumulated add and remove edge sets
for its caller to act on.  These sets can be passed to `transform!`
along with the graph to perform those modifications on the graph.
See [`applyRule!`](@ref).
"""
function transformingGraph!(f)
    addset = Set()
    removeset = Set()
    exittag = NonlocalReturn()
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

