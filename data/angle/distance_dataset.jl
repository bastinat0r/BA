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
	df[:bucket] = bsize * div( df[:angle], bsize ) + bsize / 2
	return plot(df, x=:bucket, y=:range, Geom.boxplot)
end

function compute_conf_intervalls(df, confidence)
	lower = ((1 - confidence) / 2)
	upper = confidence + lower
	println("comping confidence intervalls from $(lower)-quantile to $(upper)-quantile")
	ret = DataFrame(range = [], lower=[],upper=[],median=[],samples=[])
	for r in eachrow(df)
		if(!(r[:range] in ret[:range]))
			push!(ret, [
				r[:range],
				quantile(df[ df[:range] .== r[:range],:][:distance], lower),
				quantile(df[ df[:range] .== r[:range],:][:distance], upper),
				median(df[ df[:range] .== r[:range],:][:distance]),
				size(df[ df[:range] .== r[:range],:],1)
			])
		end
	end
	return ret
end

function plot_corridor(df, confidence)
	x = compute_conf_intervalls(df, confidence)
	return plot(x[x[:samples] .> 5,:], layer(x=:range, y=:range, Geom.line), layer(x=:range, ymin=:lower, ymax=:upper, Geom.ribbon), layer(x=:range, y=:samples, Geom.line))
end

function test_vector(model, v)
	right = 0
	wrong = 0
	for row in eachrow(v)
		if row[:range] in model[:range]
			if (model[ model[:range] .== row[:range],:][:lower][1] .<= row[:distance] .<= model[ model[:range] .== row[:range],:][:upper][1])
				right += 1
			else
				wrong += 1
			end
		end
	end
	return right / (right + wrong)
end

function test_samples_cross_validation(a, confidence)
	scores = cross_validate(
       inds -> compute_conf_intervalls(a[inds,:], confidence),
       (c, inds) -> test_vector(c, a[inds,:]),
       size(a,1),
       Kfold(size(a,1), 5))
	return scores
end
