#!/usr/bin/julia 
using Gadfly, DataFrames
set_default_plot_format(:svg)
set_default_plot_size(32cm, 20cm)
filelist = readdir()
xcsv = filter(x -> ismatch(r"^x.*\.csv", x), filelist)
dfs = [readtable(x) for x in xcsv]
xdf = reduce(vcat, dfs)
#zcsv = filter(x -> ismatch(r"^z.*\.csv", x), filelist)
#dfs = [readtable(x) for x in zcsv]
#zdf = reduce(vcat, dfs)
acsv = filter(x -> ismatch(r"^a.*\.csv", x), filelist)
dfs = [readtable(x) for x in acsv]
adf = reduce(vcat, dfs)
#kcsv = filter(x -> ismatch(r"^low_noise\/.*\.csv", x), filelist)
#dfs = [readtable(x) for x in kcsv]
#kdf = reduce(vcat, dfs)
#scsv = filter(x -> ismatch(r"^s.*\.csv", x), filelist)
#dfs = [readtable(x) for x in scsv]
#sdf = reduce(vcat, dfs)

a = adf[ adf[:dqf] .> 0, :]
a = a[ a[:range] .< 500, :]
x = xdf[ xdf[:dqf] .> 0, :]
x = x[ x[:range] .< 500, :]
#k = kdf[ kdf[:dqf] .> 0, :]
#k = k[ k[:range] .< 500, :]
#s = sdf[ sdf[:dqf] .> 0, :]
#s = s[ s[:range] .< 500, :]

function bucketplot(df, bsize)
	df[:bucket] = bsize * div( df[:distance], bsize )
	return plot(df, x=:bucket, y=:range, Geom.boxplot)
end

#draw(PGF("accurate_all.pgf", 25cm, 16cm, true, texfonts=true), bucketplot(a, 2))
#draw(PGF("buckets.pgf", 25cm, 16cm, true, texfonts=true), bucketplot(a, 20))
#draw(SVG("accurate_all.svg", 16cm, 10cm), bucketplot(a, 2))
