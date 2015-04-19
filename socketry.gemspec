# -*- encoding: utf-8 -*-
require File.expand_path("../lib/http/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Zachary Anker"]
  gem.email         = ["zach.anker@gmail.com"]

  gem.description   = <<-DESCRIPTION.strip.gsub(/\s+/, " ")
    A sane wrapper around Ruby's socket library.
    Providing simple primitives for connections and timeouts
    without having to repeatedly re-implement them.
  DESCRIPTION

  gem.summary       = "Easy to use sockets and networking"
  gem.homepage      = "https://github.com/zanker/socketry"
  gem.licenses      = ["MIT"]

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "http"
  gem.require_paths = ["lib"]
  gem.version       = Socketry::VERSION

  gem.add_development_dependency "bundler", "~> 1.0"
end
