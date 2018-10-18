FROM ruby:slim
MAINTAINER paul.kitt@innoz.de

RUN apt-get update -qq && apt-get install -y \
	gnupg2 \
	curl
ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_8.x |  bash -
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    supervisor \
    yarn \
    libfontconfig \
    nodejs


RUN mkdir /innosurvey
WORKDIR /innosurvey

#ADD Gemfile /innosurvey/Gemfile
#ADD Gemfile.lock /innosurvey/Gemfile.lock
ADD ./ /innosurvey/
RUN bundle install
#ADD package.json /innosurvey/package.json
RUN yarn 
RUN yarn global add phantomjs-prebuilt
