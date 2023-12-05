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

See the "transformingGraph! and applyRule!" testset for an example.

```@docs
applyRule!
transformingGraph!
NahaGraphs.NonlocalReturn
transform!
```


## Definitions Specific to GraphViz dot

See the "rundot output file type" testset for an example of how to
construct a graph and render it in SVG.

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

