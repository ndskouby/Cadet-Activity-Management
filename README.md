Cadet Activity Management

To access the app, click [here](https://cadet-activity-management-7ed1c42c26df.herokuapp.com/).
Code Climate Report: [here](https://codeclimate.com/github/jwonnyleaf/Cadet-Activity-Management).

# Development

## Routine
```
git pull && bundle install && rails db:migrate
rspec
rails server
rubocop
```


## Dev setup guide
### Database
```
sudo apt install postgresql
sudo service postgresql start
sudo -u postgres -i
psql
CREATE USER yourusername SUPERUSER;
ALTER ROLE "yourusername" WITH LOGIN;
```
...restart terminal, and after following repository instructions...
```
rake db:create
bin/rails db:migrate
bin/rails db:seed
```

### Repository

```
git clone git@github.com:jwonnyleaf/Cadet-Activity-Management.git
git checkout dev
git pull
sudo apt update && sudo apt upgrade -y && sudo apt install libpq-dev -y
bundle install
```

# Deployment

Currently Deployed to Heroku. [Heroku Dashboard](https://dashboard.heroku.com/apps/cadet-activity-management)
[Code Climate](https://codeclimate.com/github/jwonnyleaf/Cadet-Activity-Management)

## Deploy
If you are a collaborator in the Heroku app, use following command from local:
```
$ git push heroku <yourbranch>:master
```
* Auto-deploy is enabled for 'main' branch.
