require_relative '../lib/couchdb_basic'
require 'rspec'

describe "CouchDB abstraction layer" do

    before(:each) do
        @url = "http://192.168.50.23:5984/test"
        @couch = Couchdb.new @url
    end

    after(:each) do
        docs = @couch.get_all
        docs.each { |doc| @couch.delete(doc) }
    end

    it "Connect to database" do
        db = Couchdb.new @url
        expect(db.db()[:db_name]).to eq('test')
    end


    it "Can CRUD on database" do
        doc = @couch.create ( {:metadata => {:type => "assessment"}, :foo => "bar"} )
        expect(doc[:_rev]).not_to eq(nil)

        re_doc = @couch.get(doc[:_id])
        expect(re_doc[:foo]).to eq('bar')

        re_doc[:foo] = "baz"
        @couch.update re_doc

        re_doc = @couch.get ( doc[:_id] )
        expect(re_doc[:foo]).to eq('baz')

        @couch.delete re_doc

        re_doc = @couch.get doc[:_id]
        expect(re_doc).to be_nil 
    end


    it "Can get all documents" do
      @couch.create( { :foo=>"foo1", :bar=>"bar1" } )
      @couch.create( { :foo=>"foo2", :bar=>"bar2" } )
      expect( @couch.get_all().length  ).to eq(2)
    end

    it "Can get all documents with skipe and limit parameters." do
        hash = []
        (0..14).each do |t|
            hash.push( @couch.create( { :foo=>"foo#{t}",:bar=>"bar#{t}" } ) )
        end

        array = @couch.get_all( { :skip=>5,:limit=>5 } )
        expect( array ).to include( 
                { :_id=>hash[5][:_id],:_rev=>hash[5][:_rev],:foo=>"foo5",:bar=>"bar5" }, 
                { :_id=>hash[6][:_id],:_rev=>hash[6][:_rev],:foo=>"foo6",:bar=>"bar6" },
                { :_id=>hash[7][:_id],:_rev=>hash[7][:_rev],:foo=>"foo7",:bar=>"bar7" },
                { :_id=>hash[8][:_id],:_rev=>hash[8][:_rev],:foo=>"foo8",:bar=>"bar8" },
                { :_id=>hash[9][:_id],:_rev=>hash[9][:_rev],:foo=>"foo9",:bar=>"bar9" }
        )
    end

    it "Can insert bulk on database" do
      docs = [ {:foo => "foo1", :bar => "bar1"}, {:foo => "foo2", :bar => "bar2"} ]
      @couch.create_bulk(docs)
      expect( @couch.get_all().length ).to eq(2)
    end


    it "Can query views" do
        begin
            design  = {:_id => "_design/test", 
                       :views => {:by_type => {:map => "function(doc) { emit(doc.metadata.type,doc); }"}}};
            @couch.create(design)
        rescue RestClient::Conflict
            print "view already exists"
        end

        doc = @couch.create({:metadata => {:type => "assessment"}, :foo => "bar"})

        assessments = @couch.view('test','by_type')
        expect(assessments.length).to eq(1)

        assessments = @couch.view('test','by_type',{:key=>"assessment"})
        expect(assessments.length).to eq(1)

        assessments = @couch.view('test','by_type',{:key=>"nope"})
        expect(assessments.length).to eq(0)
    end

end


