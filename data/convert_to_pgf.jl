#!/usr/bin/julia
using Gadfly
using DataFrames
using ArgParse


function parseComandline()
	args_settings = ArgParseSettings()
	@add_arg_table args_settings begin
		"--csv", "-c"
			help="csv file to be parsed"
			arg_type = String
			required = true
		"--outfile", "-o"
			help="output filename"
			arg_type = String	
	end

	return parse_args(args_settings)
end

function main()
	parsed_args = parseComandline()
	println(parsed_args)
	s = parsed_args["csv"]
	df = readtable(s)
	df = df[ df[:dqf] .> 0, :]
	p = plot(df, x=["dqf"], y=["range"])
	outfile=parsed_args["outfile"]
	draw(PGF(outfile, 10cm, 10cm, true),p)
end

main()
