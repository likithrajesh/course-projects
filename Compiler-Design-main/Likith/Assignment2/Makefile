CXX   = g++-8
EXE = iplC
CXXDEBUG = -g -Wall
CXXSTD = -std=c++11


.PHONY: all
all: parser lexer 	
	$(CXX) $(CXXDEBUG) -o iplC driver.cpp type.cpp parser.o scanner.o 

parser: parser.yy scanner.hh
	bison -d -v $<
	$(CXX) $(CXXDEBUG) -c parser.tab.cc -o parser.o 

lexer: scanner.l scanner.hh parser.tab.hh parser.tab.cc	
	flex++ --outfile=scanner.yy.cc  $<
	$(CXX)  $(CXXDEBUG) -c scanner.yy.cc -o scanner.o

clean: 	
	rm -f *.o
	rm -f parser.hh
	rm -f stack.hh
	rm -f parser.tab.hh
	rm -f position.hh
	rm -f iplC
	rm -f *.output
	rm -f *.cc
	rm -f *.o
	rm -f *.dot
	rm -f *.h