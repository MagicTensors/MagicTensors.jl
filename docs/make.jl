using MagicTensors
using Documenter

DocMeta.setdocmeta!(MagicTensors, :DocTestSetup, :(using MagicTensors); recursive=true)

filenames = Dict(
    joinpath(@__DIR__, "..","README.md")=>joinpath(@__DIR__, "src", "index.md"),
    joinpath(@__DIR__, "..","CONTRIBUTING.md")=>joinpath(@__DIR__, "src","CONTRIBUTING.md"),
    joinpath(@__DIR__, "..","REFERENCES.md")=>joinpath(@__DIR__, "src","REFERENCES.md"),
    joinpath(@__DIR__, "graphics","logo.svg")=>joinpath(@__DIR__, "src","assets","logo.svg"),
    joinpath(@__DIR__, "graphics","favicon.ico")=>joinpath(@__DIR__, "src","assets","favicon.ico"),
)

for (src, trg) in filenames
    cp(src,trg; force=true)
end


makedocs(;
    modules=[MagicTensors],
    authors="Gerald E. Fux",
    sitename="MagicTensors.jl",
    format=Documenter.HTML(;
        canonical="https://gefux.github.io/MagicTensors.jl",
        edit_link="main",
        assets = ["assets/favicon.ico"]
    ),
    pages = [
        "Home" => "index.md",
        "MagicTensors" => "core.md",
        "MagicTensors.Circuit" => "circuit.md",
        "Tutorials" => "tutorials.md",
        "Full API" => "api.md",
        "Contributing" => "CONTRIBUTING.md",
        "References" => "REFERENCES.md",
    ],
)

deploydocs(;
    repo="github.com/gefux/MagicTensors.jl",
    devbranch="main",
)
