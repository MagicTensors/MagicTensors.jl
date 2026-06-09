using MagicTensors
using Documenter

DocMeta.setdocmeta!(MagicTensors, :DocTestSetup, :(using MagicTensors); recursive=true)

filenames = Dict(
    "README.md"=>"index.md",
    "CONTRIBUTING.md"=>"CONTRIBUTING.md",
    "REFERENCES.md"=>"REFERENCES.md"
)

for (src, trg) in filenames
    cp(joinpath(@__DIR__, "..", src),
        joinpath(@__DIR__, "src", trg);
        force=true)
end

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
