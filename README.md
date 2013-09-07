# Rails Startup template

This is a template I use for my new Ruby on Rails applications. **Pull requests are welcome.**

Also check out [Startup Readings](https://github.com/dennybritz/startupreadings).

## How to Use

```bash
rails new [app_name] -m https://raw.github.com/tony612/rails_startup_template/master/template.rb
```

### Specify rails version

```bash
rails _3.2.14_ new [app_name] -m https://raw.github.com/tony612/rails_startup_template/master/template.rb
```


## What it does

1. Adds the following gems:
  - (Optional) [mysql2](https://github.com/brianmario/mysql2)
  - (Optional) [pg](https://bitbucket.org/ged/ruby-pg)
  - [thin](https://github.com/macournoyer/thin)
  - (Optional) [Devise](https://github.com/ryanb/cancan): Devise is a flexible authentication solution for Rails based on Warden.
  - (Optional) [CanCan](https://github.com/ryanb/cancan): CanCan is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access.
  - (Optional) [haml-rails](http://haml.info): HAML is a beautiful templating language. I prefer it over ERB.
  - (Optional) [slim-rails](http://slim-lang.com/)
  - [simple_form](https://github.com/plataformatec/simple_form): SimpleForm makes it easy to build complex form using simple markup.
  - [activeadmin](https://github.com/gregbell/active_admin)
  - [rspec-rails](https://github.com/rspec/rspec-rails): Rspec is a testing tool for test-driven and behavior-driven development. It makes writing specs more enjoyable.
  - [guard-rspec](https://github.com/guard/guard-rspec): Guard for automatically launching your specs when files are modified.
  - (test environment) [capybara](https://github.com/jnicklas/capybara): I use Capybara to write integration tests and simulate user behavior.
  - (test environment) [factory_girl_rails](https://github.com/thoughtbot/factory_girl): FactoryGirl provdes a flexible alternative to Rails fixtures.
  - (production environment) [rails_12factor](https://devcenter.heroku.com/articles/rails-integration-gems): This is needed for deploying Rails 4 applications on [Heroku](http://heroku.com).
  - (Optional) [anjlab-bootstrap-rails](https://github.com/anjlab/bootstrap-rails).
  - (Optional) [font-awesome-rails](https://github.com/bokmann/font-awesome-rails).

2. Lazy mode. Set some gems which are optional originally default, including devise, cancan, bootstrap, font-awesome

3. Enable replacing gem source with [taobao](http://ruby.taobao.org/).

4. Cleans up assets by renaming `application.css` to `application.css.scss` and removing the `include_tree` directives. It's better design to import and require things manually. For example, `@import 'bootstrap';`

5. bundle install

6. Initialize some gems: guard, devise, cancan, activeadmin, bootstrap, fontawesome

7. Initializes a new git repository with an initial commit.

8. Optionally create a github repository.

**Note!!**

There is a bug for active_admin, refer this to solve it: (http://stackoverflow.com/questions/16844411/rails-active-admin-deployment-couldnt-find-file-jquery-ui)

And active_admin doesn't support rails4 for the moment.

## TODO

1. Add version specifiers for gems
