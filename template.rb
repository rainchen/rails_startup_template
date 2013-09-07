# Gems
# ==================================================

is_lazy = yes?("Use lazy mode(including devise, cancan, bootstrap, font-awesome?")

case ask("Which database?(1. Sqlite 2. Mysql 3. Postgres)")
when "2"
  # https://github.com/brianmario/mysql2
  gem "mysql2"
when "3"
  # https://bitbucket.org/ged/ruby-pg
  gem "pg"
end

# https://github.com/macournoyer/thin
gem "thin"

if use_devise = is_lazy || yes?("Authentication using devise?")
  # For authentication (https://github.com/plataformatec/devise)
  gem "devise"
end

if use_cancan = is_lazy || yes?("Authorization using cancan?")
  # For authorization (https://github.com/ryanb/cancan)
  gem "cancan"
end

case ask("Which template language?(1.erb 2.haml 3. slim)")
when "2"
  # HAML templating language (http://haml.info)
  gem "haml-rails"
when "3"
  # Slim templating language http://slim-lang.com/
  gem "slim-rails"
else
end

# Simple form builder (https://github.com/plataformatec/simple_form)
gem "simple_form"

if use_activeadmin = yes?("Use administration framework active_admin?")
  # https://github.com/gregbell/active_admin
  gem 'activeadmin'
end

gem_group :development do
  # Rspec for tests (https://github.com/rspec/rspec-rails)
  gem "rspec-rails"
  # Guard for automatically launching your specs when files are modified. (https://github.com/guard/guard-rspec)
  gem "guard-rspec"

  # Rails 3 pry initializer
  # https://github.com/rweng/pry-rails
  gem "pry-rails"

  # Pry navigation commands via debugger (formerly ruby-debug)
  # https://github.com/nixme/pry-debugger
  gem "pry-debugger"
end

gem_group :test do
  gem "rspec-rails"
  # Capybara for integration testing (https://github.com/jnicklas/capybara)
  gem "capybara"
  # FactoryGirl instead of Rails fixtures (https://github.com/thoughtbot/factory_girl)
  gem "factory_girl_rails"
end

if !is_lazy && yes?("Need to deploy on Heroku for rails 4?")
  gem_group :production do
    # For Rails 4 deployment on Heroku
    gem "rails_12factor"
  end
end

if use_bootstrap = is_lazy || yes?("Use Twitter bootstrap?")
  # https://github.com/anjlab/bootstrap-rails
  gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails'
end

if use_font_awesome = is_lazy || yes?("Use font-awesome?")
  # https://github.com/bokmann/font-awesome-rails
  gem "font-awesome-rails"
end

# Replace gem source
# ==================================================
if yes?("Use source of taobao?")
  run 'sed -i "" -e "s/https:\/\/rubygems.org/http:\/\/ruby.taobao.org/g" Gemfile'
end

# Bundle installing
run "bundle install"


# Clean up Assets
# ==================================================
# Use SASS extension for application.css
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss"
run "echo >> app/assets/stylesheets/application.css.scss"

# Initialize guard
# ==================================================
run "bundle exec guard init rspec"

if use_devise

  # Initialize Devise
  # ==================================================
  run "rails g devise:install"
  model_name = ask("What's the generated model name?(1. don't generate 2. User 3. Admin Or Customize")
  if model_name != "1"
    model_name =
      case model_name
      when "2" then "User"
      when "3" then "Admin"
      else
      end
    run "rails g devise #{model_name}"
  end

end

if use_cancan
  # Initialize CanCan
  # ==================================================
  run "rails g cancan:ability"
end

if use_activeadmin
  run "rails generate active_admin:install"
end


if use_bootstrap
  run "echo '@import \"twitter/bootstrap\";' >>  app/assets/stylesheets/application.css.scss"
  run "echo '//= require twitter/bootstrap' >>  app/assets/javascripts/application.js"
  run "rails g simple_form:install --bootstrap"
end

if use_font_awesome
  run "echo '@import \"font-awesome\";' >>  app/assets/stylesheets/application.css.scss"
end


run "rake db:migrate"


# Ignore Vim/Emacs swap files, .DS_Store, and more
# ===================================================
run "cat << EOF >> .gitignore
database.yml
*.swp
*~
.DS_Store
EOF"


# Git: Initialize
# ==================================================
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

if yes?("Initialize GitHub repository?")
  git_uri = `git config remote.origin.url`.strip
  unless git_uri.size == 0
    say "Repository already exists:"
    say "#{git_uri}"
  else
    username = ask "What is your GitHub username?"
    run "curl -u #{username} -d '{\"name\":\"#{app_name}\"}' https://api.github.com/user/repos"
    git remote: %Q{ add origin git@github.com:#{username}/#{app_name}.git }
    git push: %Q{ origin master }
  end
end
