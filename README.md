Cadet Activity Management

To access the app, click [here](https://cadet-activity-management-7ed1c42c26df.herokuapp.com/).
Code Climate Report: [here](https://codeclimate.com/github/jwonnyleaf/Cadet-Activity-Management).

# Development

## Routine

```
git pull && bundle install && npm install && rails db:migrate
rspec
rails cucumber
rubocop
rails server
```

## Dev setup guide

### First time setup

```
sudo apt update && sudo apt upgrade -y && sudo apt install libpq-dev -y
git clone git@github.com:jwonnyleaf/Cadet-Activity-Management.git
git checkout dev
git pull
bundle install
npm install
```

Next, follow
1. Setup Google OAuth On Google's End
2. Add OAuth ID and Secret to Rails Credentials
3. Database
4. To run & test, see Routine (above)


### Setup Google OAuth On Google's End

Courtesy: Course Resources - [Google-Auth-Ruby-By-JD](https://github.com/tamu-edu-students/Google-Auth-Ruby-By-JD.git)

This section walks you through setting up Google OAuth for your application in the Google Developer Console. This is required for validating aunthentication over tamu.edu domain:

#### Step 1: Create a New Project in Google Developer Console
1. Go to the [Google Developer Console](https://console.developers.google.com/).
1. Select or create a project for your application, giving it a name like "Google-OAuth-Rails."

#### Step 2: Set Up OAuth Consent Screen
1. In your project, navigate to "APIs & Services" and click on "OAuth consent screen."
1. Set the user type to "Internal" for only @tamu.edu accounts.
1. Fill out the required information on the consent screen. You need to provide the app name, user support email, and developer contact information.
1. Save your changes.

#### Step 3: Add Scopes
1. Add `userinfo.email` and `userinfo.profile`
1. Click "Save and Continue."

#### (Optional) Step 4: Add Test Users
You can add test users who are allowed to log in to your application. This means that only the email addresses you add here can access your application.
If you choose to add test users, do so on this page and click "Save and Continue."

#### Step 5: Create OAuth Client ID
1. On the dashboard, click on "Credentials," then "Create Credentials."
1. Select "OAuth client ID" and choose "Web application" as the application type.
1. Give your application a name.
1. Under "Authorized redirect URIs," add the following:
   * `http://localhost:3000/auth/google_oauth2/callback`
   * `http://127.0.0.1:3000/auth/google_oauth2/callback`
1. Click "Create."
1. You will receive a client ID and client secret. **Save this information.**
1. Ensure that your client ID is enabled.

By following these steps, you have set up the necessary configurations in the Google Developer Console to enable Google OAuth for your application. This allows your app to authenticate users using their Google accounts.

### Add OAuth ID and Secret to Rails Credentials

#### Edit the Credentials

```bash
  EDITOR=nano rails credentials:edit
```

Note: if the previous step fails, you may need to delete `config/credentials.yml.enc` and `config/master.key`.

The credentials file will open in the editor.

Add your Google OAuth credentials to the file in the following format. Make sure to maintain the correct indentation and spacing as shown. There should be 2 spaces before `client_id` and `client_secret`, and a space after the colon:

```yaml
   google:
     client_id: your_client_id
     client_secret: your_client_secret
```

*Note: Replace `your_client_id` and `your_client_secret` with your own Google OAuth credentials. Do not include any quotes around the actual credentials.*

After adding your credentials, save the changes and exit the editor.

Now, your Google OAuth credentials are securely stored in the Rails credentials file and your application will be able to use them for authentication. Make sure to keep your credentials safe and secret.

### Database

```
sudo apt install postgresql
sudo service postgresql start
sudo -u postgres -i
psql
CREATE USER yourusername SUPERUSER;
ALTER ROLE "yourusername" WITH LOGIN;
exit # exit postgresql terminal
exit # exit bash terminal for user postgres
rake db:create # This will fail if you haven't set up credentials
bin/rails db:migrate
bin/rails db:seed
```

OPTIONAL: To read in the corp of cadet's current database, put the `Overhead - Master Cadet Roster.csv` file in `lib/assets/corpsRoster.csv` and run
```
rails runner lib/ingest_roster_file.rb
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

# First-time deployment
Create a new app.
1. Create a new app
2. Install the Heroku Postgres add-on
3. Add heroku/nodejs buildpack
4. Add heroku/ruby buildpack
5. Set rails master key https://stackoverflow.com/questions/62011541/using-credentials-yml-with-rails-and-heroku and make sure Google Oauth can redirect to the Heroku deployment address
6. `git push heroku <yourbranch>:master`

# Contact Information
If you have inquiries please reach out to the primary contact:
 - Johnny Le jwonnyleaf@tamu.edu (Project Manager)