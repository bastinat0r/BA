#!/usr/bin/julia 
using Gadfly, DataFrames
set_default_plot_format(:svg)
set_default_plot_size(32cm, 20cm)

function readfolder(folder)
	filelist = readdir(folder)
	acsv = filter(x -> ismatch(r"^.*\.csv", x), filelist)
	dfs = [readtable("$folder/$x") for x in acsv]
	adf = reduce(vcat, dfs)
end

#scsv = filter(x -> ismatch(r"^s.*\.csv", x), filelist)
#dfs = [readtable(x) for x in scsv]
#sdf = reduce(vcat, dfs)
adf = readfolder("./trianglesym2015-12-11@23:00")
adf = vcat(readfolder("./trianglesym2015-12-12@00:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-12@01:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-12@02:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-12@03:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-12@04:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-12@05:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-13@23:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-14@00:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-14@01:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-14@03:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-14@04:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-14@05:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-16@00:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-16@01:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-16@02:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-16@03:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-16@04:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-16@05:00"), adf)
adf = vcat(readfolder("./trianglesym2015-12-16@06:00"), adf)


a = adf[ adf[:dqf] .> 0, :]
a = a[ a[:range] .< 500, :]
function bucketplot(df, bsize)
	df[:bucket] = bsize * div( df[:distance], bsize ) + bsize / 2
	return plot(df, x=:bucket, y=:range, Geom.boxplot)
end
