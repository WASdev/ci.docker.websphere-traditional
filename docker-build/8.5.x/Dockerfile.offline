# build image to extract the tar ball.
FROM ubuntu:16.04 as builder
 ARG WAS_VERSION=9.0.0.10
 ARG WAS_TAR_BALL=was-${WAS_VERSION}.tar.gz
COPY im/${WAS_TAR_BALL} /
RUN tar -xzf "$WAS_TAR_BALL"
# patch wsadmin.sh to avoid error when deploying apps
RUN sed -i 's/-Xms256m/-Xms1024m/g' /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh \
    && sed -i 's/-Xmx256m/-Xmx1024m/g' /opt/IBM/WebSphere/AppServer/bin/wsadmin.sh


# final image that will copy extracted tar ball from builder
FROM ubuntu:16.04
ARG USER=was
ARG GROUP=was


ARG PROFILE_NAME=AppSrv01
ARG CELL_NAME=DefaultCell01
ARG NODE_NAME=DefaultNode01
ARG HOST_NAME=localhost
ARG SERVER_NAME=server1
ARG ADMIN_USER_NAME=wsadmin

COPY scripts/ /work/
COPY licenses /licenses/


RUN apt-get update && apt-get install -y openssl

RUN groupadd $GROUP --gid 0 \
  && useradd $USER -g $GROUP -m --uid 1001 \
  && mkdir /opt/IBM \
  && chmod -R +x /work/* \
  && mkdir /etc/websphere \
  && mkdir /work/config \
  && chown -R $USER:$GROUP /work /opt/IBM /etc/websphere

COPY --chown=1001:0 --from=builder /opt/IBM /opt/IBM

USER $USER

CMD ["/work/create_and_start.sh"]TH=/opt/IBM/WebSphere/AppServer/bin:$PATH \
    PROFILE_NAME=$PROFILE_NAME \
    SERVER_NAME=$SERVER_NAME \
    ADMIN_USER_NAME=$ADMIN_USER_NAME \
    EXTRACT_PORT_FROM_HOST_HEADER=true

RUN /work/create_profile.sh

USER root
RUN ln -s /opt/IBM/WebSphere/AppServer/profiles/${PROFILE_NAME}/logs /logs && chown $USER:$GROUP /logs
USER $USER

CMD ["/work/start_server.sh"]

