# frozen_string_literal: true

def run_install_template(path)
  system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path(
    "../install/#{path}.rb", __dir__
  )}"
end

namespace :founders_toolkit do
  desc 'Install Founders Toolkit'
  task :install do
    run_install_template 'gems'
  end
end
