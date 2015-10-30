#!/usr/bin/julia -i
using Gadfly, DataFrames
set_default_plot_format(:svg)
set_default_plot_size(32cm, 20cm)
filelist = readdir()
xcsv = filter(x -> ismatch(r"^x.*\.csv", x), filelist)
dfs = [readtable(x) for x in xcsv]
xdf = reduce(vcat, dfs)
ycsv = filter(x -> ismatch(r"^y.*\.csv", x), filelist)
dfs = [readtable(x) for x in ycsv]
ydf = reduce(vcat, dfs)
