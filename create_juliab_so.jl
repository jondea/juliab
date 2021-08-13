import REPL
using REPL.TerminalMenus

println("No juliab.so found, follow instructions to create")

all_categories = Dict(
    "Plotting" => ["Plots"],
    "DataScience" => ["CSV","DataFrames"]
)
all_category_names = collect(keys(all_categories))

all_packages = ["Plots", "CSV", "DataFrames"]

category_menu = MultiSelectMenu(all_category_names)

chosen_category_indices = request("Select the categories you care about:", category_menu)

chosen_category_names = all_category_names[collect(chosen_category_indices)]

chosen_category_packages = String[]
for category in chosen_category_names
    append!(chosen_category_packages, all_categories[category])
end
unique!(chosen_category_packages)

category_menu = MultiSelectMenu(all_packages)
for (i, package) in enumerate(category_menu.options)
    if package in chosen_category_packages
        push!(category_menu.selected, i)
    end
end
chosen_packages = request("Select the categories you care about:", category_menu)

chosen_package_names = all_packages[collect(chosen_packages)]

@show(chosen_category_names)
@show(chosen_package_names)

packages = Symbol.(chosen_package_names)
package_precompile_execution_files=["package_precompile_execution_files/$(p).jl" for p in chosen_package_names]
category_precompile_execution_files=["category_precompile_execution_files/$(p).jl" for p in chosen_category_names]

precompile_execution_files = vcat(package_precompile_execution_files, category_precompile_execution_files)

if isempty(packages)
    error("No packages specified, no point building .so file. Just use julia instead")
end

import Pkg

println("Adding packages: ", join(chosen_package_names, ", "))

Pkg.add(chosen_package_names)

using PackageCompiler

println("Compiling")

create_sysimage(packages, sysimage_path="juliab.so", precompile_execution_file=precompile_execution_files)
