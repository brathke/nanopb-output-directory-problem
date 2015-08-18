# protoc-output-dir-problem
This project demonstrates a problem I'm experiencing with the Google protocol buffers compiler.

I have a number of .proto files organized in a number of directories which are expected to be loaded into a root directory 'protofiles'. 

```
(master)$ tree -L 3
.
├── Makefile
├── protofiles
│   ├── Base
│   │   └── Base.proto
│   ├── CategoryA
│   │   └── MessageA1.proto
│   ├── CategoryB
│   │   └── MessageB1.proto
│   └── CategoryC
│       └── MessageC1.proto
└── README.md
```

The .proto files import other files with paths relative to the root directory. For example, Base.proto:

```
(master)$ cat protofiles/Base/Base.proto 
syntax = "proto2";

import "CategoryA/MessageA1.proto";
import "CategoryB/MessageB1.proto";
import "CategoryC/MessageC1.proto";

message Base {
    oneof type {
        MessageA1 messageA1 = 1;
        MessageB1 messageB1 = 2;
        MessageC1 messageC1 = 3;
    }
}
```

When compiling these .proto files I set the include path to the root .proto directory, 'protofiles', as shown in the following makefile:

```
(master)$ cat Makefile 
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
	# TODO: clean doesn't work, files end up in unexpected directory
	rm -f $(OUTFILES_CC)
	rm -f $(OUTFILES_H)
```

When I 'make all' I do not get the expected results: the output files in the same location as their .proto counterpart. Instead a new directory is created within each subdirectory off of the protofiles root directory:
```
(master)$ make all
/usr/local/bin/protoc -Iprotofiles --cpp_out=protofiles/Base/ protofiles/Base/Base.proto
/usr/local/bin/protoc -Iprotofiles --cpp_out=protofiles/CategoryA/ protofiles/CategoryA/MessageA1.proto
/usr/local/bin/protoc -Iprotofiles --cpp_out=protofiles/CategoryB/ protofiles/CategoryB/MessageB1.proto
/usr/local/bin/protoc -Iprotofiles --cpp_out=protofiles/CategoryC/ protofiles/CategoryC/MessageC1.proto
(master)$ tree
.
├── Makefile
├── protofiles
│   ├── Base
│   │   ├── Base  <-------------------------- ? 
│   │   │   ├── Base.pb.cc
│   │   │   └── Base.pb.h
│   │   └── Base.proto
│   ├── CategoryA
│   │   ├── CategoryA  <-------------------------- ? 
│   │   │   ├── MessageA1.pb.cc
│   │   │   └── MessageA1.pb.h
│   │   └── MessageA1.proto
│   ├── CategoryB
│   │   ├── CategoryB  <-------------------------- ? 
│   │   │   ├── MessageB1.pb.cc
│   │   │   └── MessageB1.pb.h
│   │   └── MessageB1.proto
│   └── CategoryC
│       ├── CategoryC  <-------------------------- ? 
│       │   ├── MessageC1.pb.cc
│       │   └── MessageC1.pb.h
│       └── MessageC1.proto
└── README.md

9 directories, 14 files
(master)$
```

Is this expected behavior?

