PGF := $(patsubst %.csv,%.pgf, $(wildcard *.csv))
CSV := $(wildcard *.csv)

all: $(PGF)

$(PGF): %.pgf : %.csv
	./convert_to_pgf.jl -c $< -p $@ -s $*.svg
	sed -i '/^\\fontspec/d' $@ 

clean:
	rm *.pgf
	rm *.svg
