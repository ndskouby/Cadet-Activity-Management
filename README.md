Cadet Activity Management

To access the app, click [here](https://cadet-activity-management-7ed1c42c26df.herokuapp.com/).
Code Climate Report: [here](https://codeclimate.com/github/jwonnyleaf/Cadet-Activity-Management).

# Development

## Routine

```
git pull && bundle install && npm install && rails db:migrate
rspec
rails cucumber
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

To read in the corp of cadet's current database, put the `Overhead - Master Cadet Roster.csv` file in `lib/assets/corpsRoster.csv` and run
```
rails runner lib/ingest_roster_file.rb
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

Currently Deployed to Heroku. <br>
[Heroku Dashboard](https://dashboard.heroku.com/apps/cadet-activity-management) - https://dashboard.heroku.com/apps/cadet-activity-management <br>
[Heroku App](https://cadet-activity-management-7ed1c42c26df.herokuapp.com/) - https://cadet-activity-management-7ed1c42c26df.herokuapp.com/ <br>
[Code Climate](https://codeclimate.com/github/jwonnyleaf/Cadet-Activity-Management) - https://codeclimate.com/github/jwonnyleaf/Cadet-Activity-Management

## Heroku setup

Install Heroku CLI https://devcenter.heroku.com/articles/heroku-cli

```
heroku login
heroku git:remote -a cadet-activity-management
```

## Heroku commands

- Logs: `heroku logs --app cadet-activity-management`

- Deploy: `git push heroku <yourbranch>:master`
  - Auto-deploy is enabled for 'main' branch.
- Run a command on a one-off dyno: `heroku run bash --type=worker`


# JavaScript & CSS
- https://stackoverflow.com/questions/36602764/how-to-use-npm-packages-in-rails