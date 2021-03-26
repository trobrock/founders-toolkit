# frozen_string_literal: true

say 'Add gems'
insert_into_file 'Gemfile', "\ngem 'tailwindcss-rails'\n", after: /^gem 'founders_toolkit'.+$/
insert_into_file 'Gemfile', "\ngem 'hotwire-rails'\n", after: /^gem 'founders_toolkit'.+$/
run 'bin/bundle install'

say 'Install Tailwind CSS'
rails_command 'tailwindcss:install'

say 'Install Hotwire'
rails_command 'hotwire:install'
