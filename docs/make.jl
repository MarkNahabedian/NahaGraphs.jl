using Pkg
Pkg.add("Documenter")

using Documenter
using NahaGraphs

# Temporary hack:
push!(LOAD_PATH,"../src/")

makedocs(;
         modules=[NahaGraphs],
         format=Documenter.HTML(),
         pages=[
             "Home" => "index.md",
         ],
         sitename="NahaGraphs.jl",
         authors="Mark Nahabedian"
)

deploydocs(;
           repo="github.com/MarkNahabedian/NahaGraphs.jl",
           devbranch="master",
)
