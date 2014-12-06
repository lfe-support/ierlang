PY2=python2.7
PY2_VENV=./.venv-py2
PY2_VENV_BIN=$(PY2_VENV)/bin/$(PY2)
PY2_SESSION_SRC=$(PY2_VENV)/lib/python2.7/site-packages/IPython/kernel/zmq/session.py
PY2_PATCHED=patches/py2patched

$(PY2_VENV_BIN):
	@virtualenv --python=$(PY2) $(PY2_VENV)

$(PY2_PATCHED):
	patch $(PY2_SESSION_SRC) < patches/ierlang.patch
	touch $(PY2_PATCHED)

py2deps: $(PY2_VENV_BIN)
	@. $(PY2_VENV)/bin/activate && \
	pip install -r requirements.txt
	@make $(PY2_PATCHED)

py2shell-base:
	@echo "Starting IErlang Console..."
	. $(PY2_VENV)/bin/activate && \
	ERL_LIBS=$(ERLLIBS) \
	ipython2 console \
	--KernelManager.kernel_cmd=$(OPT_KERN_MGR_CMD) \
	--Session.key="" \
	--Session.keyfile=""

py2shell-no-deps:
	@rebar compile skip_deps=true
	@make py2shell-base

py2shell: py2deps compile py2shell-base

py2demo-base:
	@echo "Starting IErlang Notebook Demo..."
	@. $(PY2_VENV)/bin/activate && \
	ERL_LIBS=$(ERLLIBS) \
	ipython2 notebook $(IERLANG_DEMO) \
	--KernelManager.kernel_cmd=$(OPT_KERN_MGR_CMD) \
	--Session.key="" \
	--Session.keyfile=""

py2demo-no-deps:
	@rebar compile skip_deps=true
	@make py2demo-base

py2demo: py2deps compile py2demo-base

py2notebook: IERLANG_DEMO=notebooks
py2notebook: py2deps compile py2demo-base

py2clean:
	rm -rf $(PY2_VENV) $(PY2_PATCHED)
