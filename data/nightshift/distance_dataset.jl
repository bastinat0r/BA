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
	df[:bucket] = bsize * div( df[:distance], bsize ) + bsize / 2
	return plot(df, x=:bucket, y=:range, Geom.boxplot)
end

function compute_conf_intervalls(df, confidence)
	lower = ((1 - confidence) / 2)
	upper = confidence + lower
	ret = DataFrame(range = [], lower=[],upper=[],samples=[])
	for r in eachrow(df)
		if(!(r[:range] in ret[:range]))
			push!(ret, [
				r[:range],
				quantile(df[ df[:range] .== r[:range],:][:distance], lower),
				quantile(df[ df[:range] .== r[:range],:][:distance], upper),
				size(df[ df[:range] .== r[:range],:],1)
			])
		end
	end
	return ret
end

function plot_corridor(df, confidence)
	x = compute_conf_intervalls(df, confidence)
	return plot(x, layer(x=:range, y=:lower, Geom.point, Geom.line, Theme(default_color=color("green"))), layer(x=:range, y=:upper, Geom.point, Geom.line, Theme(default_color=color("red"))), layer(x=:range, y=:samples, Geom.line))
end
