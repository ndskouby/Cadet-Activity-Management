Cadet Activity Management

To access the app, click [here](https://cadet-activity-management-7ed1c42c26df.herokuapp.com/).

# Dev setup guide
## Database
```
sudo apt install postgresql
sudo service postgresql start
sudo -u postgres -i
ALTER ROLE "ubuntu" WITH LOGIN;
```
...restart terminal...
```
rake db:create
bin/rails db:migrate
```

## Repository

```
git clone git@github.com:jwonnyleaf/Cadet-Activity-Management.git
git checkout dev
git pull
sudo apt install libpq-dev
bundle install
```
## Running
```
./bin/rails server
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
