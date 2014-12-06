PY3=python3.4
PY3_VENV=./.venv-py3
PY3_VENV_BIN=$(PY3_VENV)/bin/$(PY3)
PY3_SESSION_SRC=$(PY3_VENV)/lib/python3.4/site-packages/IPython/kernel/zmq/session.py
PY3_PATCHED=patches/py3patched

$(PY3_VENV_BIN):
	@$(PY3) -m venv $(PY3_VENV)

$(PY3_PATCHED):
	patch $(PY3_SESSION_SRC) < patches/ierlang.patch
	touch $(PY3_PATCHED)

py3deps: $(PY3_VENV_BIN)
	@. $(PY3_VENV)/bin/activate && \
	pip3 install -r requirements.txt
	@make $(PY3_PATCHED)

py3shell-base:
	@echo "Starting IErlang Console..."
	. $(PY3_VENV)/bin/activate && \
	ERL_LIBS=$(ERLLIBS) \
	ipython2 console \
	--KernelManager.kernel_cmd=$(OPT_KERN_MGR_CMD) \
	--Session.key="" \
	--Session.keyfile=""

py3shell-no-deps:
	@rebar compile skip_deps=true
	@make py3shell-base

py3shell: py3deps compile py3shell-base

py3demo-base:
	@echo "Starting IErlang Notebook Demo..."
	@. $(PY3_VENV)/bin/activate && \
	ERL_LIBS=$(ERLLIBS) \
	ipython3 notebook $(IERLANG_DEMO) \
	--KernelManager.kernel_cmd=$(OPT_KERN_MGR_CMD) \
	--Session.key="" \
	--Session.keyfile=""

py3demo-no-deps:
	@rebar compile skip_deps=true
	@make py3demo-base

py3demo: py3deps compile py3demo-base

py3notebook: IERLANG_DEMO=notebooks
py3notebook: py3deps compile py3demo-base

py3clean:
	rm -rf $(PY3_VENV) $(PY3_PATCHED)
