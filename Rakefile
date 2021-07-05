require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: ["spec", "rubocop:auto_correct"]

desc "Build site"
task :build do
  sh "bundle exec middleman build --clean --bail"
end

desc "Publish build to Github pages"
task :publish do
  require "tmpdir"

  rev = `git rev-parse --short HEAD`.chomp
  puts rev

  publish_dir = ENV.fetch("CLONED_GH_PAGES_DIR") do
    tmp_dir = Dir.mktmpdir("publish-api-catalogue")
    repo_url = `git config --get remote.origin.url`.chomp
    sh("git clone --single-branch --branch gh-pages #{repo_url} #{tmp_dir}")
    tmp_dir
  end

  sh("rsync -a --delete --exclude .git --exclude CNAME build/ #{publish_dir}")
  # Copy redirect files from helpers folder to deal with the gh-p push
  sh("cp -a helpers/redirects/ #{publish_dir}")

  if ok
    sh("git -C #{publish_dir} push")
  else
    puts "Nothing to commit, skipping push"
  end
end
# end
