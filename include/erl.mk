ifeq ($(shell which erl),)
$(error Can't find Erlang executable 'erl')
exit 1
endif
ifeq ($(shell which rebar),)
$(error Can't find required rebar script')
exit 1
endif

ESCRIPT=$(shell which escript)
IPY_KERN=$(shell pwd)/bin/start_kernel
DEP_LIBS1=$(shell pwd)/deps/erlzmq:$(shell pwd)/deps/mochiweb
DEP_LIBS=$(DEP_LIBS1):$(shell pwd)/deps/sandbox:$(shell pwd)/deps/uuid
IERLANG_LIB=$(shell pwd)
ERLLIBS=$(ERL_LIBS):$(DEP_LIBS):$(IERLANG_LIB)

compile:
	@echo "Compiling IErlang..."
	@rebar get-deps
	@rebar compile

erl:
	ERL_LIBS=$(ERLLIBS) erl

erlclean:
	rebar clean
