PROTOC = /usr/local/bin/protoc

PROTOFILES_BASE_DIR=protofiles

PROTOFILES=\
$(PROTOFILES_BASE_DIR)/Base/Base.proto \
$(PROTOFILES_BASE_DIR)/CategoryA/MessageA1.proto \
$(PROTOFILES_BASE_DIR)/CategoryB/MessageB1.proto \
$(PROTOFILES_BASE_DIR)/CategoryC/MessageC1.proto

OUTFILES_CC=$(PROTOFILES:.proto=.pb.cc)
OUTFILES_H=$(PROTOFILES:.proto=.pb.h)

all: $(OUTFILES_CC)

%.pb.cc: %.proto
	$(PROTOC) -I$(PROTOFILES_BASE_DIR) --cpp_out=$(dir $<) $<

clean:
	# clean doesn't work, files end up in unexpected directory
	rm -f $(OUTFILES_CC)
	rm -f $(OUTFILES_H)

