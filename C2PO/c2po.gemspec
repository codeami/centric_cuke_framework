
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'c2po/version'

Gem::Specification.new do |spec|
  spec.name          = 'c2po'
  spec.version       = C2PO::VERSION
  spec.authors       = ['Donavan Stanley']
  spec.email         = ['donavan.stanley@gmail.com']

  spec.summary       = %q{Centric Consulting Page Object}
  spec.description   = %q{Enhancements to PageObject.}
  spec.homepage      = 'https://github.com/centric-automation'
  spec.license       = 'GPL'


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'

  spec.add_dependency 'page-object', '~> 2.2'
  spec.add_dependency 'cpt_hook'    # Not locked yet due to active development

end
