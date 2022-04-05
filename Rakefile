require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc "Validate all files match their respective schemas"
task schema: ["schema:links"]

namespace :schema do
  desc "Validate links are well-formed"
  task :links do
    require_relative "lib/links"
    links_csv = File.expand_path("data/links.csv", __dir__)
    links = Links.from_csv(links_csv)

    invalid_links = links.all_links.reject(&:valid?)
    unless invalid_links.empty?
      invalid_attributes = invalid_links.map(&:attributes)
      raise "Not all of the links were well-formed according to their schema: #{invalid_attributes.join("\n- ")}"
    end
  end
end

task default: ["spec", "rubocop:auto_correct", "schema"]

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
  sh("cp -a helpers/redirects/sc.html #{publish_dir}")
  sh("cp -a helpers/redirects/sc #{publish_dir}")
  sh("cp -a helpers/redirects/border.html #{publish_dir}/Border.html")
  sh("cp -a helpers/redirects/border #{publish_dir}/Border")
  sh("cp -a helpers/redirects/apim.html #{publish_dir}")
  sh("cp -a helpers/redirects/apim #{publish_dir}")
  sh("cp -a helpers/redirects/graphql.html #{publish_dir}")
  sh("cp -a helpers/redirects/graphql #{publish_dir}")
  sh("git -C #{publish_dir} add --all")
  sh("git -C #{publish_dir} commit -m 'Publish #{rev}'") do |ok, _|
    if ok
      sh("git -C #{publish_dir} push")
    else
      puts "Nothing to commit, skipping push"
    end
  end
end

desc "Validate the built site is well-formed, according to HTML Proofer"
task :htmlproofer do
  require "html-proofer"
  HTMLProofer.check_directory("build/", disable_external: true, url_ignore: %w[#]).run
end
