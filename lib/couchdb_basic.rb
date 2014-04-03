
require 'json'
require 'uri'
require 'net/http'

def http_get(uri)
    JSON.parse(Net::HTTP.get(URI(uri)), :symbolize_names=>true)
end

def http_delete(uri)
    uri = URI.parse(uri)
    header = {'Content-Type'=> 'application/json'}
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Delete.new(uri.request_uri, header)
    response = http.request(request)
    JSON.parse(response.body, :symbolize_names=>true)
end

def http_post(uri,doc) 
    uri = URI.parse(uri)
    header = {'Content-Type'=> 'application/json'}
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = doc.to_json
    response = http.request(request)
    JSON.parse(response.body,:symbolize_names=>true)
end

class Couchdb

    def initialize(url)
        @url = url
    end

    def _get(url="")
        http_get "#{@url}#{url}"
    end

    def _post(data,bulk=false)
        begin
            url = @url
            if bulk
              url = "#{url}/_bulk_docs"
            end
            r = http_post(url,data)
        rescue Net::HTTPBadRequest => e
            puts e.response.to_str
            r = nil
        end
        r
    end

    def db()
        _get()
    end

    def create(doc)
        r = _post(doc)
        doc[:_id]  = r[:id]
        doc[:_rev] = r[:rev]
        doc
    end

    def create_bulk(docs)
        docs = {:docs=>docs}
        _post(docs,true)    
    end

    def update(doc)
        r = _post(doc)
        doc[:_rev] = r[:rev]
        doc
    end

    def get(id)
        doc = _get "/#{URI.escape(id)}"
        if doc[:error] 
            nil
        else
            doc
        end
    end

    def delete(doc)
        r = http_delete "#{@url}/#{URI.escape( doc[:_id] )}?rev=#{doc[:_rev]}"
        nil
    end

    def view(design,view,args={})
        url = "/_design/#{design}/_view/#{view}?"
        args.keys.each { |k| 
            url << "&#{k}=#{URI.escape(args[k].to_json)}"
        }
        _get(url)[:rows]
    end

    def get_all(args={})
        url = "/_all_docs?include_docs=true"
        args.keys.each { |k| 
            url << "&#{k}=#{URI.escape(args[k].to_json)}"
        }
        _get(url)[:rows].map {|row| row[:doc]}
    end

end

