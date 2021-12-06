require "dotenv"
Dotenv.load

require "rspec/core/rake_task"

tags = [
  :balances,
  :activity,
  :statement
]

tags.each do |tag|
  desc "Get #{tag}"
  task tag do
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = "--tag #{tag}"
    end
    Rake::Task["spec"].execute
  end
end
