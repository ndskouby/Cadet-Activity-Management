# https://stackoverflow.com/questions/36602764/how-to-use-npm-packages-in-rails
system 'npm install' if Rails.env.development? || Rails.env.test?
