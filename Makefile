# Unofficial Makefile
#
# Derived from https://github.com/lemire/testingRNG/blob/master/practrand/Makefile

.SUFFIXES:
#
.SUFFIXES: .cpp .o .c .h


.PHONY: clean
PROCESSOR:=$(shell uname -m)
ifeq ($(PROCESSOR), aarch64)
OPTIFLAG =
else
OPTIFLAG = -march=native
endif

CXX = clang++

CFLAGS = -fPIC -std=c99 -O3 $(OPTIFLAG) -Wall -Wextra -Wshadow -Wno-implicit-function-declaration
CXXFLAGS = -fPIC -std=c++14 -O3 $(OPTIFLAG) -Iinclude -pthread

LIB_SRCS = $(wildcard src/*.cpp src/RNGs/*.cpp src/RNGs/other/*.cpp)
LIB_OBJS = $(filter %.o,$(LIB_SRCS:.cpp=.o))

all: RNG_test

libPractRand.a: $(LIB_OBJS)
	ar rcs $@ $^

RNG_test: tools/RNG_test.cpp libPractRand.a
	$(CXX) $(CXXFLAGS) $^ -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(LIB_OBJS) RNG_test libPractRand.a
