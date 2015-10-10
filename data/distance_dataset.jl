#!/usr/bin/julia -i
using Gadfly, DataFrames
filelist = readdir()
xcsv = filter(x -> ismatch(r"^x.*\.csv", x), filelist)
dfs = [readtable(x) for x in xcsv]
df = reduce(vcat, dfs)
df = df[ df[:dqf] .> 0, :]
df = df[ df[:range] .< 10000, :]
set_default_plot_format(:svg)
set_default_plot_size(32cm, 20cm)
