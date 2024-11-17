FROM debian

RUN apt update \
    && apt install -y git git-lfs build-essential wget cmake \
    libboost-program-options-dev clang-15 clang-format-15 mc

RUN mkdir xmorphy

RUN wget -O tf.tar.gz https://github.com/tensorflow/tensorflow/archive/refs/tags/v2.16.2.tar.gz
RUN mkdir tf \
    && tar -xf tf.tar.gz -C /tf

RUN git clone https://github.com/dmitrys99/xmorphy2.git -b web-console /xmorphy/xmorphy2
#RUN wget https://github.com/alesapin/XMorphy/archive/refs/heads/master.zip
RUN git clone https://github.com/alesapin/XMorphy.git /xmorphy/xmorphy \
    && cd xmorphy/xmorphy && git lfs pull
#RUN apt install unzip
#RUN unzip master.zip
#RUN mv XMorphy-master /xmorphy/xmorphy

#RUN cp -r /xmorphy/xmorphy/src /xmorphy/xmorphy2/
#RUN cp -r /xmorphy/xmorphy/programs /xmorphy/xmorphy2/
RUN cp -r /xmorphy/xmorphy/data /xmorphy/xmorphy2/

RUN mkdir /xmorphy/xmorphy2/build
RUN cd /xmorphy/xmorphy2/build \
    && cmake -DTENSORFLOW_SOURCE_DIR=/tf/tensorflow-2.16.2 -DABSL_PROPAGATE_CXX_STD=ON \
    -DCIVETWEB_ENABLE_CXX=ON -DCIVETWEB_SERVE_NO_FILES=ON -DCIVETWEB_ENABLE_IPV6=OFF \
    -DCIVETWEB_ENABLE_LUA=OFF -DCIVETWEB_BUILD_TESTING=OFF ..

RUN cd /xmorphy/xmorphy2/build && make -j8
