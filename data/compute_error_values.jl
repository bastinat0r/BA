#!/usr/bin/julia
using DataFrames

println("mean range & range variance &  mean dqf \\\\")
for x in ARGS
	println(x)
	df = readtable(x)
	df = df[ df[:dqf] .> 0, :]
	println("$(mean(df[:range])) & $(var(df[:range])) & $(mean(df[:range])) \\\\")
end
