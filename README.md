# NahaGraphs

A simple package for creating and manipulating directed graphs.

The initial code was migrated from PanelCutting.jl.

A `DiGraph` maintains a `Set` of edges.  Each edge is a `Pair` whose
`first` is the *from* node and whose `second` is the *to* node.  Nodes
are arbitrary objects whose only role in a DiGraph is to have
identity.

```
julia> using Pkg

julia> Pkg.add(;url="https://github.com/MarkNahabedian/NahaGraphs.jl")
...

julia> using NahaGraphs

julia> g = DiGraph()
DiGraph(Set{Pair}())

julia> add_edge!(g, :a, 1)
DiGraph(Set(Pair[:a => 1]))

julia> add_edge!(g, :a, :b)
DiGraph(Set(Pair[:a => :b, :a => 1]))

julia> edges(g)
Set{Pair} with 2 elements:
  :a => :b
  :a => 1

julia> nodes(g)
Set{Any} with 3 elements:
  :a
  :b
  1

julia> query(g, :a, Any)
Set{Pair} with 2 elements:
  :a => :b
  :a => 1

```

A `DiGraph` can also be read as a Dict with the from nodes serving as
keys.

To wrap DiGraph in a new struct type for specialized behavior, see the
method delegation example in `test/mygraph.jl`.
