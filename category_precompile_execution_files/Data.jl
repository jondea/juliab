using CSV
using DataFrames
CSV.read(joinpath(@__DIR__,"sample.csv"), DataFrame)
