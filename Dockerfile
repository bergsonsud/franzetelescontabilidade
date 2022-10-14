
FROM ruby:2.7.1
ENV BUNDLER_VERSION=2.1.4

RUN apt-get update -qq && apt-get install -yq --no-install-recommends curl

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt -y install nodejs
RUN node --version

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    build-essential \        
    yarn \
    apt-utils \
    gnupg2 \
    less \
    git \
    libpq-dev \
    postgresql-client \   
    imagemagick \
    libmagickcore-dev \
    libmagickwand-dev \    
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN gem install bundler -v 2.1.4


ENV RAILS_RELATIVE_URL_ROOT=/franzetelescontabilidade


WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./ 

RUN npm install @popperjs/core --save
RUN rake assets:precompile

EXPOSE 3000 3035



ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
