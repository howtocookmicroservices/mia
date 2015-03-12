FROM ruby:2.0.0-p643
MAINTAINER Alex Kurkin <akurkin@stelladot.com>

RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
ONBUILD COPY id_dsa /root/.ssh/

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add bitbucket's known host
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts
RUN apt-get update && apt-get install -y build-essential nodejs mysql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Install consul-template
ENV CT_URL https://github.com/hashicorp/consul-template/releases/download/v0.1.0/consul-template_0.1.0_linux_amd64.tar.gz
RUN curl -L $CT_URL | tar -C /usr/local/bin --strip-components 1 -zxf -

RUN mkdir -p /web/service

ENV GEM_HOME /web/rubygems/2.0.0-p643
ENV BUNDLE_PATH /web/rubygems/2.0.0-p643

ENV PATH /web/rubygems/2.0.0-p643/bin:$PATH

WORKDIR /web/service

# ONBUILD ADD Gemfile /web/service/
# ONBUILD ADD Gemfile.lock /web/service/

# ONBUILD RUN bundle install

# EXPOSE 3010

ONBUILD ADD . /web/service/

CMD ["rails", "server"]% 