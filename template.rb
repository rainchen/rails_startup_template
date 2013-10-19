# Rails application template guide: http://guides.rubyonrails.org/rails_application_templates.html

# Helpers
def download(url, save_as)
  %x{curl '#{url}' -o #{save_as} -s}
end

# Replace gem source
# ==================================================
if yes?("Use gem source of taobao?")
  # run 'sed -i "" -e "s/https:\/\/rubygems.org/http:\/\/ruby.taobao.org/g" Gemfile'
  add_source "http://ruby.taobao.org/"
end

# Gems
# ==================================================

# Mandatory gems

# https://github.com/macournoyer/thin
gem "thin"

# Simple form builder (https://github.com/plataformatec/simple_form)
gem "simple_form"

# Easiest way to add multi-environment yaml settings to Rails3
# https://github.com/railsjedi/rails_config
gem "rails_config"

# use "-d" option to set the database, and "-d" option will update the database.yml
# PS: value of "-d" option can be access by options['database']

# case ask("Which database?(1. Sqlite 2. Mysql 3. Postgres)")
# when "2"
#   # https://github.com/brianmario/mysql2
#   gem "mysql2"
# when "3"
#   # https://bitbucket.org/ged/ruby-pg
#   gem "pg"
# end


case ask("Which template language?(1.erb 2.haml 3. slim)")
when "2"
  # HAML templating language (http://haml.info)
  gem "haml-rails"
when "3"
  # Slim templating language http://slim-lang.com/
  gem "slim-rails"
else
  # use erb
end


# Optional gems

is_lazy = yes?("Use lazy mode(including devise, cancan, bootstrap, font-awesome?")

if use_devise = is_lazy || yes?("Authentication using devise?")
  # For authentication (https://github.com/plataformatec/devise)
  gem "devise"
end

if use_cancan = is_lazy || yes?("Authorization using cancan?")
  # For authorization (https://github.com/ryanb/cancan)
  gem "cancan"
end



if use_activeadmin = yes?("Use administration framework active_admin?")
  # https://github.com/gregbell/active_admin
  gem 'activeadmin'

  # There is a bug for active_admin, refer this to solve it: (http://stackoverflow.com/questions/16844411/rails-active-admin-deployment-couldnt-find-file-jquery-ui)
  # jQuery UI for the Rails 3.1+ asset pipeline
  # https://github.com/joliss/jquery-ui-rails
  gem "jquery-ui-rails"
end

if use_bootstrap = is_lazy || yes?("Use Twitter bootstrap?")
  # https://github.com/anjlab/bootstrap-rails
  gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails'
end

if use_font_awesome = is_lazy || yes?("Use font-awesome?")
  # https://github.com/bokmann/font-awesome-rails
  gem "font-awesome-rails"
end

gem_group :development, :test do
  # Rspec for tests (https://github.com/rspec/rspec-rails)
  gem "rspec-rails"
end

gem_group :development do
  # Guard for automatically launching your specs when files are modified. (https://github.com/guard/guard-rspec)
  gem "guard-rspec"

  # debugging tools

  # Rails 3 pry initializer
  # https://github.com/rweng/pry-rails
  gem "pry-rails"

  # Pry navigation commands via debugger (formerly ruby-debug)
  # https://github.com/nixme/pry-debugger
  gem "pry-debugger"

  # gem "debugger" # sometimes pry-debugger will cause "Segmentation fault", then we can use gem "debugger"

  # Provides a better error page for Rails and other Rack apps
  # See https://github.com/charliesome/better_errors
  gem "better_errors"
  # Retrieve the binding of a method's caller. Can also retrieve bindings even further up the stack.
  # See http://github.com/banister/binding_of_caller
  gem "binding_of_caller"

  # Profiling toolkit for Rack applications with Rails integration. Client Side profiling, DB profiling and Server profiling.
  # https://github.com/SamSaffron/MiniProfiler
  gem "rack-mini-profiler"

  # help to kill N+1 queries and unused eager loading
  # https://github.com/flyerhzm/bullet
  # gem "bullet"

  # Deploy with capistrano
  # https://github.com/capistrano/capistrano
  gem "capistrano"
  gem "rvm-capistrano"
end

gem_group :test do
  # Capybara for integration testing (https://github.com/jnicklas/capybara)
  gem "capybara"

  # FactoryGirl instead of Rails fixtures (https://github.com/thoughtbot/factory_girl)
  gem "factory_girl_rails"

  # A library for generating fake data such as names, addresses, and phone numbers.
  # See https://github.com/stympy/faker
  gem 'faker'
end

# if !is_lazy && yes?("Need to deploy on Heroku for rails 4?")
#   gem_group :production do
#     # For Rails 4 deployment on Heroku
#     gem "rails_12factor"
#   end
# end

# Bundle installing
run_bundle


# Clean up Assets
# ==================================================
# Use SASS extension for application.css
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss"
run "echo >> app/assets/stylesheets/application.css.scss"

# Initialize guard
# ==================================================
bundle_command "exec guard init rspec"

# create "#{app_name}_development" and "#{app_name}_test"
rake "db:create"


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

# http://stackoverflow.com/questions/16844411/rails-active-admin-deployment-couldnt-find-file-jquery-ui/18105658#18105658
if use_activeadmin
  file 'app/assets/javascripts/jquery-ui.js', <<-END.gsub(/^ {4}/, '')
    //= require jquery.ui.all
  END

  file 'app/assets/stylesheets/jquery-ui.css', <<-END.gsub(/^ {4}/, '')
    /*
     *= require jquery.ui.all
     */
  END
end


rake "db:migrate"


# Ignore Vim/Emacs swap files, .DS_Store, and more
# ===================================================
# get more gitignore config at https://github.com/github/gitignore
download 'https://raw.github.com/github/gitignore/master/Rails.gitignore', '.gitignore'
run "cat << EOF >> .gitignore
database.yml
*.swp
*~
.DS_Store
EOF"


# create database.yml.example
run "cp config/database.yml config/database.yml.example"

# Git: Initialize
# ==================================================
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

# if yes?("Initialize GitHub repository?")
#   git_uri = `git config remote.origin.url`.strip
#   unless git_uri.size == 0
#     say "Repository already exists:"
#     say "#{git_uri}"
#   else
#     username = ask "What is your GitHub username?"
#     run "curl -u #{username} -d '{\"name\":\"#{app_name}\"}' https://api.github.com/user/repos"
#     git remote: %Q{ add origin git@github.com:#{username}/#{app_name}.git }
#     git push: %Q{ origin master }
#   end
# end
