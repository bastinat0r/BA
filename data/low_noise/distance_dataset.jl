#!/usr/bin/julia 
using Gadfly, DataFrames
set_default_plot_format(:svg)
set_default_plot_size(32cm, 20cm)
filelist = readdir()
acsv = filter(x -> ismatch(r"^.*\.csv", x), filelist)
dfs = [readtable(x) for x in acsv]
adf = reduce(vcat, dfs)
#scsv = filter(x -> ismatch(r"^s.*\.csv", x), filelist)
#dfs = [readtable(x) for x in scsv]
#sdf = reduce(vcat, dfs)

a = adf[ adf[:dqf] .> 0, :]
a = a[ a[:range] .< 500, :]
function bucketplot(df, bsize)
	df[:bucket] = bsize * div( df[:distance], bsize )
	return plot(df, x=:bucket, y=:range, Geom.boxplot)
end
