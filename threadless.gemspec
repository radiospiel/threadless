# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{threadless}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["pboy"]
  s.date = %q{2009-12-12}
  s.description = %q{run_later without threads}
  s.email = %q{eno-pboy@open-lab.org}
  s.extra_rdoc_files = ["README.rdoc", "lib/threadless.rb"]
  s.files = ["README.rdoc", "Rakefile", "lib/threadless.rb", "Manifest", "threadless.gemspec"]
  s.homepage = %q{http://github.com/pboy/threadless}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Threadless", "--main", "README.mdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{threadless}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{run_later without threads}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
