# Project Setup Checklist
Here's a Rails/React/Redux setup checklist. It should only serve as a reminder.
Ask a TA if you don't understand _why_ you're configuring something on this
list.

* [ ] `rails new`
  * Add `--database=postgresql` if using Postgres.
  * Add `--skip-turbolinks` to skip the turbolinks gem.
* [ ] Update your `Gemfile`.
  * `better_errors`
  * `binding_of_caller`
  * `pry-rails`
  * `annotate`
* [ ] `bundle install`
* [ ] `git init`
  * Update your `.gitignore`.
    * `node_modules/`
    * `bundle.js`
    * `bundle.js.map`
* [ ] `git remote add` the proper remote.
  * `git push -u` the remote.
* [ ] `npm init --yes` to create a package.json file with the default setup.
* [ ] Create a frontend folder at the root of your project with an entry file inside of it.
* [ ] `npm install --save`
  * `webpack`
  * `react`
  * `react-dom`
  * `react-router`
  * `redux`
  * `react-redux`
  * `babel-core`
  * `babel-loader`
  * `babel-preset-react`
  * `babel-preset-es2015`
* [ ] Create a `webpack.config.js` file.
  * The entry point should be in frontend, e.g. `entry: 'frontend/index.jsx'`.
  * The output path should be `'app/assets/javascripts'`.
  * Configure your `module.loaders` to use Babel transpilation for:
    * JSX
    * ES6
  * Include `devtool: 'source-map'`.
* [ ] `git commit` again (Verify that your `.gitignore` works).
  * `git push` your skeleton.


# Rails Setup

There are several things you **must** do when beginning every Rails
app for the near future.

First off, check your rails version. In this course, we will be
using Rails `~>4.2.0` (greater than or equal to 4.2.0 but less than
4.3). Check to see if you have a proper version by running:

```
rails -v
```

If you don't have a new enough version of Rails, run:

```
gem install rails -v '~> 4.2.0'
```

Now that you have Rails installed and ready, start your project
with the following command:

```
rails new MyProjectName --database=postgresql
```

If you have Rails 5 installed, you can start a Rails 4 project
using the following command:

```
rails _4.2.7_ new MyProjectName --database=postgresql
```

## Use Common Debugging Gems

You want to use `better_errors` and `binding_of_caller`, which will
make it much easier to see what is going on in your Rails app. You
also want to use `pry-rails`, which will provide a nicer console than
IRB when you run `rails console`. Lastly, you can use the
`quiet_assets` gem, which will reduce excessive logging of requests
for CSS/JavaScript files, making it easier for you to read your Rails
logs:

```ruby
# Add to Gemfile
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'quiet_assets'
end
```

**Note:** You should always place these gems in the `development` group. Rails
supports three environments by default: development, test, and production.
Development is what it runs in on your localhost. Test is what it runs in when
you run RSpec tests. Production is what it will run in on Heroku or other hosts
that make your app available to the Internet. You *never* want gems like
`better_errors` or `binding_of_caller` running in production. In addition to
loading unnecessary code, these gems will constitute a huge security hole if
their features are exposed to the Internet. So whenever you install a new gem,
think carefully about which environment(s) it is applicable to.
