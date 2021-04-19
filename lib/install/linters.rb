# frozen_string_literal: true

source_paths << File.expand_path('templates', __dir__)

say 'Add rubocop'
gem_group :development do
  gem 'rubocop'
end
run 'bin/bundle install'
copy_file '.rubocop.yml', '.rubocop.yml'

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
