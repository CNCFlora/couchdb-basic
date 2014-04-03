#couchdb-basic

##Example of use couchdb\_basic gem.

Below, follow the step-by-step how to create, edit, delete and view couchdb documents. Before the example itself, please follow the prerequisites to run the example.

###Install ruby, couchdb and the gem.
`sudo apt-get install ruby couchdb`
`sudo service couchdb start`
`gem install couchdb\_basic`

##Create a database instance in Futon Couchdb. In the example, there is a "database\_test".

Example code:

```
  1 require "couchdb_basic"
  2 
  3 #  Create a instance of database.
  4 db = Couchdb.new "http://localhost:5984/database_test"
  5 
  6 #  JSON document of example.
  7 doc = {
  8     :name=>"foo",
  9     :lastname=>"bar",
 10     :age=>99
 11 }
 12 
 13 #  Insert document.
 14 doc = db.create(doc)
 15 puts doc[:lastname]
 16 
 17 #  Recover document
 18 doc = db.get( doc[:_id] )
 19 doc[:lastname] = "Avancini"
 20 
 21 #  Update document
 22 doc = db.update(doc)
 23 puts "doc[:lastname] = #{db.get( doc[:_id] )[:lastname]}" 
 24 
 25 docs = []
 26 
 27 (0..5).each do |i|
 28     doc = {}
 29     doc[:key] = "value#{i}"
 30     i = i + 1 
 31     docs.push( doc )
 32 end
 33 
 34 #  Bulk insert and get all documents.
 35 db.create_bulk( docs )
 36 teste = db.get_all()
 37 puts "docs = #{docs}"
```

##License

Apache License 2.0

