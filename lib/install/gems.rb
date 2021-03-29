# frozen_string_literal: true

say 'Add gems'
gem 'hotwire-rails'
gem 'tailwindcss-rails'
run 'bin/bundle install'

say 'Install Tailwind CSS'
rails_command 'tailwindcss:install'

say 'Install Hotwire'
rails_command 'hotwire:install'
