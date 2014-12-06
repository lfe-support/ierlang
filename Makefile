ifeq ($(shell which python3.4),)
DEMO=py2demo
DEMO_NO_DEPS=py2demo-no-deps
PYCLEAN=py2clean
NOTEBOOK=py2notebook
else
DEMO=py3demo
DEMO_NO_DEPS=py3demo-no-deps
PYCLEAN=py3clean
NOTEBOOK=py3notebook
endif

include include/py2.mk
include include/py3.mk
include include/erl.mk

IERLANG_DEMO=notebooks/ierlang_demo.ipynb
OPT_KERN_MGR_CMD='["$(ESCRIPT)", "$(IPY_KERN)", "{connection_file}"]'

clean: $(PYCLEAN) erlclean

demo: $(DEMO)

demo-no-deps: $(DEMO_NO_DEPS)

notebook: $(NOTEBOOK)
