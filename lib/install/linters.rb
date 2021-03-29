# frozen_string_literal: true

source_paths << File.expand_path('templates', __dir__)

say 'Add rubocop'
gem_group :development do
  gem 'rubocop'
end
run 'bin/bundle install'
copy_file '.rubocop.yml', '.rubocop.yml'
