#=======================================================================================================================
#A simple RESTful HTTP class put together for this Rehydration script.
#Future versions will most likely use an external PtREST object, common to all PowerTrack ruby clients.
class PtRESTful
    require "net/https"     #HTTP gem.
    require "uri"

    attr_accessor :url, :uri, :user_name, :password_encoded, :headers, :data,
                  :account_name, :publisher, :label

    def initialize(url=nil, user_name=nil, password_encoded=nil, headers=nil)
        if not url.nil?
            @url = url
        end

        if not user_name.nil?
            @user_name = user_name
        end

        if not password_encoded.nil?
            @password_encoded = password_encoded
            @password = Base64.decode64(@password_encoded)
        end

        if not headers.nil?
            @headers = headers
        end
    end

    def url=(value)
        @url = value
        @uri = URI.parse(@url)
    end

    def password_encoded=(value)
        @password_encoded=value
        if not @password_encoded.nil? then
            @password = Base64.decode64(@password_encoded)
        end
    end

    #Helper function for building URLs.


    #TODO: implement a method that has product passed in.
    def getURL(product,account_name=nil,label=nil)

    end


    def getHistoricalURL(account_name=nil)
        @url = "https://historical.gnip.com:443/accounts/" #Root url for Historical PowerTrack API.

        if account_name.nil? then #using object account_name attribute.
            if @account_name.nil?
                p "No account name set.  Can not set url."
            else
                @url = @url + "#{@account_name}/jobs.json"
            end
        else #account_name passed in, so use that...
            @url = @url + "#{account_name}/jobs.json"
        end
    end

    def getRehydrationURL(account_name=nil)
        @url = "https://rehydration.gnip.com/accounts/"  #Root url for Rehydration PowerTrack.

        if account_name.nil? then #using object account_name attribute.
            if @account_name.nil?
                p "No account name set.  Can not set url."
            else
                @url = @url + "#{@account_name}/publishers/#{@publisher}/rehydration/activities.json"
            end
        else #account_name passed in, so use that...
            @url = @url + "#{account_name}/publishers/#{@publisher}/rehydration/activities.json"
        end
    end


    def getSearchURL(account_name=nil,label=nil)

        @url = "https://search.gnip.com/accounts/"  #Root url for Search PowerTrack.

        if account_name.nil? then #user not passing in anything...
            if @account_name.nil?
                p "No account name set.  Can not set url."
                return @url #albeit incomplete.
            end
            @url = @url + "#{@account_name}/search/"
        else
            @url = @url + "#{account_name}/search/"
        end


        if label.nil? then #user not passing in anything...
            if @label.nil?
                p "No stream label (like 'prod' or 'dev') set.  Can not set url."
                return @url  #albeit incomplete.
            end
            @url = @url + "#{@label}.json"
        else
            @url = @url + "#{label}.json"
        end

        return @url
    end


    def getSearchCountURL(account_name=nil,label=nil)

        @url = "https://search.gnip.com/accounts/"  #Root url for Search PowerTrack.

        if account_name.nil? then #user not passing in anything...
            if @account_name.nil?
                p "No account name set.  Can not set url."
                return @url #albeit incomplete.
            end
            @url = @url + "#{@account_name}/search/"
        else
            @url = @url + "#{account_name}/search/"
        end


        if label.nil? then #user not passing in anything...
            if @label.nil?
                p "No stream label (like 'prod' or 'dev') set.  Can not set url."
                return @url  #albeit incomplete.
            end
            @url = @url + "#{@label}/counts.json"
        else
            @url = @url + "#{label}/counts.json"
        end

        return @url
    end




    #Fundamental REST API methods:
    def POST(data=nil)

        if not data.nil? #if request data passed in, use it.
            @data = data
        end

        uri = URI(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)
        request.body = @data
        request.basic_auth(@user_name, @password)
        response = http.request(request)
        return response
    end

    def PUT(data=nil)

        if not data.nil? #if request data passed in, use it.
            @data = data
        end

        uri = URI(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Put.new(uri.path)
        request.body = @data
        request.basic_auth(@user_name, @password)
        response = http.request(request)
        return response
    end

    def GET(params=nil)
        uri = URI(@url)

        #params are passed in as a hash.
        #Example: params["max"] = 100, params["since_date"] = 20130321000000
        if not params.nil?
            uri.query = URI.encode_www_form(params)
        end

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth(@user_name, @password)

        response = http.request(request)
        return response
    end

    def DELETE(data=nil)
        if not data.nil?
            @data = data
        end

        uri = URI(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Delete.new(uri.path)
        request.body = @data
        request.basic_auth(@user_name, @password)
        response = http.request(request)
        return response
    end
end #PtREST class.

