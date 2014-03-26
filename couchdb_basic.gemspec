Gem::Specification.new do |s|
    s.name        = "couchdb_basic"
    s.version     = "0.0.1.beta"
    s.date        = "2014-03-18"
    s.summary     = "A basic couchdb database lib."
    s.description = "A lib for documents database operations."
    s.authors     = ["Diogo Silva", "Bruno Giminiani"]
    s.email       = "diogo@cncflora.jbrj.gov.br"
    s.files       = ["lib/couchdb_basic.rb"]
    s.homepage    = "https://github.com/CNCFlora/couchdb-basic" 
    s.license	  = "Apache License 2.0"
    s.add_runtime_dependency "multi_json"
    s.add_runtime_dependency "rest_client"
    s.add_runtime_dependency "uri-handler"
    s.add_development_dependency "rspec"
end
