PROTOC=../nanopb/generator-bin/protoc

PROTOFILES_BASE_DIR=protofiles

PROTOFILES=\
$(PROTOFILES_BASE_DIR)/Base/Base.proto \
$(PROTOFILES_BASE_DIR)/CategoryA/MessageA1.proto \
$(PROTOFILES_BASE_DIR)/CategoryB/MessageB1.proto \
$(PROTOFILES_BASE_DIR)/CategoryC/MessageC1.proto

OUTFILES_C=$(PROTOFILES:.proto=.pb.c)
OUTFILES_CPP=$(PROTOFILES:.proto=.cpp)

all: all_c all_cpp
all_c: $(OUTFILES_C)
all_cpp: $(OUTFILES_CPP)

%.pb.c: %.proto
	$(PROTOC) -I$(PROTOFILES_BASE_DIR) --nanopb_out=$(dir $<) $<

%.cpp: %.proto
	$(PROTOC) -I$(PROTOFILES_BASE_DIR) --cpp_out=$(dir $<) $<

