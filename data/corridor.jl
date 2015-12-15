#!/usr/bin/julia 
using Gadfly, DataFrames

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

function plot_corridor(df, confidence, min_samples)
	x = compute_conf_intervalls(df, confidence)
	return plot(x[x[:samples] .> min_samples,:],
	layer(x=:range, y=:range, Geom.line),
	layer(x=:range, ymin=:lower, ymax=:upper, Geom.ribbon, Theme(default_color=color("green"))),
	Guide.xlabel("range"),
	Guide.ylabel("distance"))
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
