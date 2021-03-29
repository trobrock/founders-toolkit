# frozen_string_literal: true

source_paths << File.expand_path('templates', __dir__)

say 'Creating Current'
copy_file 'current.rb', 'app/models/current.rb'
