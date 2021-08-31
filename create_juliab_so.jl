import REPL
using REPL.TerminalMenus

println("No juliab.so found, follow instructions to create")

categories_to_packages = Dict(
    "Plotting" => ["Plots"],
    "DataScience" => ["CSV", "DataFrames"]
)
all_packages = ["Plots", "CSV", "DataFrames"]

# Show menu with the categories
all_category_names = collect(keys(categories_to_packages))
category_menu = MultiSelectMenu(all_category_names)
chosen_category_indices = request("Select the categories you care about:", category_menu)
chosen_category_names = all_category_names[collect(chosen_category_indices)]

# Collect all the packages from selected categories
chosen_category_packages = String[]
for category in chosen_category_names
    append!(chosen_category_packages, categories_to_packages[category])
end
unique!(chosen_category_packages)

# Preselect packages from the categories
category_menu = MultiSelectMenu(all_packages)
for (i, package) in enumerate(category_menu.options)
    if package in chosen_category_packages
        push!(category_menu.selected, i)
    end
end

# Show menu for packages
chosen_package_indices = request("For finer grain control, select individual packages you care about, or just continue:", category_menu)
chosen_package_names = all_packages[collect(chosen_package_indices)]

package_precompile_execution_files=["package_precompile_execution_files/$(p).jl" for p in chosen_package_names]
category_precompile_execution_files=["category_precompile_execution_files/$(p).jl" for p in chosen_category_names]

precompile_execution_files = vcat(package_precompile_execution_files, category_precompile_execution_files)

if isempty(chosen_package_names)
    error("No packages specified, no point building .so file. Just use julia instead")
end

import Pkg
println("Adding packages: ", join(chosen_package_names, ", "))
Pkg.add(chosen_package_names)

Pkg.add("PackageCompiler")
using PackageCompiler
println("Compiling")
chosen_packages = Symbol.(chosen_package_names)
create_sysimage(chosen_packages, sysimage_path="juliab.so", precompile_execution_file=precompile_execution_files)
