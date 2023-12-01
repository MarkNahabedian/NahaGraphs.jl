# NahaGraphs.jl

NahaGraphs provides some rudimentary functionality for building
directed graphs and running GraphViz `dot` to visualize them.

The [`query`](@ref) function provides a simplemined way to search the
graph's edges.

## Generic Graph definitions

```@docs
DiGraph
add_edge!
remove_edge!
nodes
edges
query
```

## Transforming Graphs

This is experimental.

```@docs
applyRule!
```


## Definitions Specific to GraphViz dot

```@docs
dotgraph
dotID
dotnode
dotedge
graph_attributes
node_attributes
edge_attributes
dotescape
diarc
```

