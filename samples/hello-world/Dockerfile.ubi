FROM ibmcom/websphere-traditional:latest-ubi
COPY app.ear /work/config/app.ear
COPY install_app.py /work/config/install_app.py
COPY was-config.props /work/config/was-config.props
RUN /work/configure.sh
