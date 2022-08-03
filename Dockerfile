# Orignally copied from https://gitlab.checkrhq.net/decisions/clearinghouse/-/blob/master/Dockerfile
FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm yarn
RUN mkdir /app

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

ADD . /app
