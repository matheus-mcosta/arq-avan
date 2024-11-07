CXX = g++
CXXFLAGS = -std=c++11
PAPI_PATH = $(PWD)/../papi/install
INCLUDES = -I$(PAPI_PATH)/include
LDFLAGS = -L$(PAPI_PATH)/lib
LIBS = $(PAPI_PATH)/lib/libpapi.a -lpapi

TARGET = main
SRCS = main.cpp papito.cpp
OBJS = $(SRCS:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(OBJS) $(LDFLAGS) $(LIBS) -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

generate_data:
	python data_gen.py

test: $(TARGET)
	./$(TARGET) "data.csv"

bench: $(TARGET)
	./bench.sh $(TARGET)
	
.PHONY: all clean
