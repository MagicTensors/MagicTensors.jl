using MagicTensors
using Documenter

DocMeta.setdocmeta!(MagicTensors, :DocTestSetup, :(using MagicTensors); recursive=true)

cp(joinpath(@__DIR__, "..", "CONTRIBUTING.md"),
   joinpath(@__DIR__, "src", "CONTRIBUTING.md");
   force=true)
cp(joinpath(@__DIR__, "..", "REFERENCES.md"),
   joinpath(@__DIR__, "src", "REFERENCES.md");
   force=true)

makedocs(;
    modules=[MagicTensors],
    authors="Gerald E. Fux",
    sitename="MagicTensors.jl",
    format=Documenter.HTML(;
        canonical="https://gefux.github.io/MagicTensors.jl",
        edit_link="main",
        assets=String[],
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
