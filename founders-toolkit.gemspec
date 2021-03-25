# frozen_string_literal: true

require_relative 'lib/founders_toolkit/version'

Gem::Specification.new do |spec|
  spec.name          = 'founders-toolkit'
  spec.version       = FoundersToolkit::VERSION
  spec.authors       = ['Trae Robrock', 'Andrew Katz']
  spec.email         = ['trobrock@gmail.com', 'andrew.katz@hey.com']

  spec.summary       = 'Founders Toolkit for Rails'
  spec.description   = 'Founders Toolkit for Rails'
  spec.homepage      = 'https://github.com/trobrock/founders-toolkit'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/trobrock/founders-toolkit.git'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '~> 6.1'
  spec.add_dependency 'activesupport', '~> 6.1'
  spec.add_dependency 'bcrypt', '~> 3.1.7'
  spec.add_dependency 'email_validator'
end
