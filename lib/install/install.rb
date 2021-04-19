# frozen_string_literal: true

source_paths << File.expand_path('templates', __dir__)

say 'Copy the files'
copy_file 'current.rb', 'app/models/current.rb'
copy_file 'Procfile'
copy_file '.rubocop.yml'
copy_file 'Brewfile'
run 'brew bundle'

say 'Add gems'
gem 'hotwire-rails'
gem 'tailwindcss-rails'
gem 'resque'
gem 'resque-scheduler'
gem_group :development do
  gem 'foreman'
  gem 'rubocop'
end
run 'bin/bundle install'

say 'Install Tailwind CSS'
rails_command 'tailwindcss:install'

say 'Install Hotwire'
rails_command 'hotwire:install'

say 'Add Standard'
run 'yarn add --dev standardjs @babel/eslint-parser'

package_json = JSON.parse(File.read('package.json'))
package_json['standard'] = {
  "globals": %w(
    fetch
    FormData
    CustomEvent
    IntersectionObserver
  ),
  "parser": '@babel/eslint-parser'
}
package_json['babel'] = {
  "presets": [
    './node_modules/@rails/webpacker/package/babel/preset.js'
  ]
}
File.open('package.json', 'w') do |file|
  file.write(JSON.pretty_generate(package_json))
end
