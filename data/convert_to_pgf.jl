using Gadfly
using DataFrames

print ARGS
df = readtable(ARGS[0]+".csv")
df = df[ df[:dqf] .> 0, :]
p = plot(df, x=["dqf"], y=["range"])
draw(PGF(ARGS[0]+".pgf", 10cm 10cm, true),p)
