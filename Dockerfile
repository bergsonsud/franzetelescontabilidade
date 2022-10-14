FROM ruby:2.7.1
ENV BUNDLER_VERSION=2.1.4

RUN apt-get update -qq && apt-get install -yq --no-install-recommends curl

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    build-essential \        
    nodejs \
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
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN gem install bundler -v 2.1.4

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./ 

EXPOSE 3000 3035



ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]