FROM ruby:2.4-alpine

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /srv/app

RUN apk add --update alpine-sdk

COPY . .
# RUN gem install rake -v 12.3.1 --no-doc
RUN bundle install --deployment
RUN rake build

EXPOSE 3000
CMD /usr/local/bin/bundle exec rake server

