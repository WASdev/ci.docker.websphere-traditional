ENABLE_BASIC_LOGGING="${ENABLE_BASIC_LOGGING:-false}"

if [ "$ENABLE_BASIC_LOGGING" = false ]; then
	/work/run_py_script.sh "/work/configHPEL.py"
fi
