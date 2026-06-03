## Building the Documentation

``` shell
julia --project=docs -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'
julia --project=docs docs/make.jl
```

then start a http python server
``` shell
python3 -m http.server 8000 -d docs/build/
```
and view the documentation page at <http://localhost:8000>.


## Testing and Code Coverage

``` shell
julia --project=@. -e 'using Pkg; Pkg.instantiate()'
julia --project=dev -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'
```

``` shell
julia --project=@. -e 'using Pkg; Pkg.test(coverage=true)'
julia --project=dev -e 'using Coverage; c=process_folder(); open("lcov.info","w") do io; LCOV.write(io,c); end'
find . -name '*.cov' -delete
```

## Julia Style Guide

* Word-wrap in source files at 92 characters.
* Use 4 spaces for indentation, no tabs.
* Use snake_case for function and variable names, use UpperCamelCase for type names.

### Julia File Template
```Julia
# -- Constants -----------------------------------------------------------------------------

# -- Abstract Functions --------------------------------------------------------------------

# -- Abstract Types ------------------------------------------------------------------------

# -- Concrete Structs ----------------------------------------------------------------------

# -- Constructors --------------------------------------------------------------------------

# -- Base Methods --------------------------------------------------------------------------

# -- Interface Methods ---------------------------------------------------------------------

# -- Additional Functions ------------------------------------------------------------------

# -- Extensions ----------------------------------------------------------------------------

# -- Private Functions ---------------------------------------------------------------------

# -- List Entries --------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------

```
