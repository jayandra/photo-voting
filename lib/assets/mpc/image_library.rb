require "httparty"

module MPC

  class Image
    attr_accessor :contest_id, :id, :owner, :title, :flickr_id, :url

    def initialize(image_hash)
      @contest_id = image_hash["contest_id"] if image_hash.has_key?("contest_id")
      @id         = image_hash["id"]  if image_hash.has_key?("id")

      @owner      = image_hash["owner"] if image_hash.has_key?("owner")
      @title      = image_hash["title"]  if image_hash.has_key?("title")

      @flickr_id  = image_hash["flickr_id"]  if image_hash.has_key?("flickr_id")
      @url      = image_hash["url"]  if image_hash.has_key?("url")
    end
  end

  class ImageLibrary
    include HTTParty

    BASE_URL = 'http://pv.pop.umn.edu/'

    def initialize(key)
      @api_key = key
    end

    # retrieve overall contest status
    def status
      response = JSON.parse( self.class.get("#{BASE_URL}/contest/#{@api_key}") )
    end

    # retrieve information about the contest images
    def images
      response = JSON.parse( self.class.get("#{BASE_URL}/contest/#{@api_key}/images") )
    end

    # retrieve information about a round
    def current_round
      response = JSON.parse( self.class.get("#{BASE_URL}/contest/#{@api_key}/round") )
    end

    # retrieve information about round round_number
    def round(round_number)
      response = JSON.parse( self.class.get("#{BASE_URL}/contest/#{@api_key}/round/#{round_number}") )
    end

    # posting storing voting results for a round
    # POST "body" content payload must be formatted as multipart form data
    def post_round(round, post_content)
      response = HTTParty.post("#{BASE_URL}/contest/#{@api_key}/round/#{round}", :body => {"data" => post_content} )
    end

    # contest Initialization
    def post_reset(tags = nil)
      response = HTTParty.post("#{BASE_URL}/contest/#{@api_key}/reset", query: {tags: tags} )
    end

    # contest Finalization
    def post_finalize
      response = HTTParty.post("#{BASE_URL}/contest/#{@api_key}/done")
    end

    # Takes an array of images hash, and returns an array of Image objects
    # images_array : "images" array from response of status() / images() method calls
    def grab_image(images_array)
      return_images = Array.new

      images_array.each do |image_hash|
        if(image_hash.has_key?("image"))
          return_images << Image.new(image_hash["image"])
        else
          return_images << Image.new(image_hash)
        end
      end

      return_images
    end
  end

end