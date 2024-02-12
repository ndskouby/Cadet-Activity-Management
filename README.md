Cadet Activity Management

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
