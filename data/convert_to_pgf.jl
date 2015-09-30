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
		"--pgf", "-p"
			help="output filename for pgf"
			arg_type = String	
		"--sgv", "-s"
		  help="output filename for svg"
			arg_type = String
	end

	return parse_args(args_settings)
end

function main()
	parsed_args = parseComandline()
	s = parsed_args["csv"]
	df = readtable(s)
	df = df[ df[:dqf] .> 0, :]
	p = plot(df, x="dqf", y="range")
	if haskey(parsed_args,"pgf")
		pgf=parsed_args["pgf"]
		draw(PGF(pgf, 10cm, 10cm, true),p)
	end
	if haskey(parsed_args,"svg")
		svg=parsed_args["svg"]
		draw(SVG(svg, 10cm, 10cm),p)
	end
end

main()
