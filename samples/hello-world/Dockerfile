FROM icr.io/appcafe/websphere-traditional
COPY app.ear /work/config/app.ear
COPY install_app.py /work/config/install_app.py
COPY was-config.props /work/config/was-config.props
RUN env JVM_EXTRA_CMD_ARGS=-Xnoloa /work/configure.sh
