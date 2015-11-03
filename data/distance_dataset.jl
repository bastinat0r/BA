#!/usr/bin/julia -i
using Gadfly, DataFrames
set_default_plot_format(:svg)
set_default_plot_size(32cm, 20cm)
filelist = readdir()
xcsv = filter(x -> ismatch(r"^x.*\.csv", x), filelist)
dfs = [readtable(x) for x in xcsv]
xdf = reduce(vcat, dfs)
zcsv = filter(x -> ismatch(r"^z.*\.csv", x), filelist)
dfs = [readtable(x) for x in zcsv]
zdf = reduce(vcat, dfs)
acsv = filter(x -> ismatch(r"^a.*\.csv", x), filelist)
dfs = [readtable(x) for x in acsv]
adf = reduce(vcat, dfs)
