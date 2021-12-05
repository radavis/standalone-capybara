require "dotenv"
Dotenv.load

require 'rspec/core/rake_task'

namespace :port_forwarding do
  desc "Enable port forwarding"
  task :enable do
    RSpec::Core::RakeTask.new do |t|
      t.pattern = "features/enable_port_forwarding.rb"
    end
    Rake::Task["spec"].execute
  end

  desc "Disable port forwarding"
  task :disable do
    RSpec::Core::RakeTask.new do |t|
      t.pattern = "features/disable_port_forwarding.rb"
    end
    Rake::Task["spec"].execute
  end
end
