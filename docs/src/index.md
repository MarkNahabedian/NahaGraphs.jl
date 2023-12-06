# NahaGraphs.jl

NahaGraphs provides some rudimentary functionality for building
directed graphs, searching them, and and running GraphViz `dot` to
visualize them.

If you have a tree of immutable structs, NahaGraphs can also be used
to construct a DiGraph that mirrors that hierarchy but allows for
reverse lookup.

There is noting clever here.  No indexing.  Searching is linear.
Functionality will be slower for larger graphs.  If you have
suggestions for improvement, please open a discussion or an issue.


## Generic Graph definitions

```@docs
DiGraph
add_edge!
remove_edge!
nodes
edges
query
```

To define your own graph type that delegates to `DiGraph`, see
`test/mygraph.jl`.  You might do this in order to streamline
how nodes and edges are managed for your application.


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

