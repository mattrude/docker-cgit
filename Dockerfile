FROM ubuntu:16.04
MAINTAINER OEMS <oscaremu@gmaiil.com>

# Step 1
RUN apt update && \
    apt install -y curl wget supervisor xz-utils build-essential autoconf automake libtool libssl-dev highlight python-markdown nginx openssh-server
# Step 2
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV CGIT_VERSION 1.0
ENV MD5_CHECKSUM 1dbd155da1c4adc89703fb1faf249dff
# Step 3
RUN mkdir -p /root/cgit \
    && cd /root/cgit \
    && wget "https://git.zx2c4.com/cgit/snapshot/cgit-$CGIT_VERSION.tar.xz" -O cgit-$CGIT_VERSION.tar.xz \
    && echo "$MD5_CHECKSUM cgit-$CGIT_VERSION.tar.xz" | md5sum -c -  \
    && tar xf "cgit-$CGIT_VERSION.tar.xz" \
    && cd "cgit-$CGIT_VERSION" \
    && make get-git && make && make install \
    && sed -i '118 s/^/#/' /usr/local/lib/cgit/filters/syntax-highlighting.sh \
    && echo 'exec highlight --force --inline-css -f -I -O xhtml -S "$EXTENSION" 2>/dev/null' >> /usr/local/lib/cgit/filters/syntax-highlighting.sh

ADD cgitrc /etc/cgitrc
