# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

### Build app:

`docker-compose build`

### Prepare DB:

`docker-compose run app bundle exec rake db:create`

`docker-compose run app bundle exec rake db:migrate`

`docker-compose run app bundle exec rake db:seed`

### Run app

`docker-compose up`

### Test

`docker-compose run -e "RAILS_ENV=test" app bundle exec rake db:migrate`

`docker-compose run -e "RAILS_ENV=test" app bundle exec rspec`
