using FEMeshes
using Documenter

DocMeta.setdocmeta!(FEMeshes, :DocTestSetup, :(using FEMeshes); recursive=true)

makedocs(;
    modules=[FEMeshes],
    authors="Jean-François Barthélémy",
    repo="https://github.com/jfbarthelemy/FEMeshes.jl/blob/{commit}{path}#{line}",
    sitename="FEMeshes.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jfbarthelemy.github.io/FEMeshes.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jfbarthelemy/FEMeshes.jl",
    devbranch="main",
)
