# -*- coding: utf-8 -*-
# This class can be used to extract data from Cine Passion scraper
#
# = API Key
# Please watch README file
#
# = Other stuff
# Author::    Nicolas Ledez nicolas (chez) ledez.net
# Copyright:: Copyright (c) 2010 Nicolas Ledez
# License::   Distributes under the same terms as Ruby
#
# == Warranty
# This software is provided "as is" and without any express or implied warranties, including, without limitation, the implied warranties of merchantibility and fitness for a particular purpose.

require 'uri'
require 'net/http'
require 'rexml/document'
include REXML

begin
   require 'cine_passion_config'
rescue LoadError => load_error
   # Define default variables
   SITEURL="http://scraper-cine-passion-demo.ledez.net"
   APIKEY="fake-7945cb-fake"
   
   puts '*'*50
   puts File.join(File.dirname(__FILE__), 'cine_passion_config.rb') + " is missing"
   puts " Please see README to create it"
   puts "currently I use theres values :"
   puts "SITEURL: #{SITEURL}"
   puts "APIKEY; #{APIKEY}"
   puts '*'*50
end

if not (defined? SITEURL || (not SITEURL.nil?))
   raise 'Need to define SITEURL'
end

if not (defined? APIKEY || (not APIKEY.nil?))
   raise 'Need to define APIKEY'
end

class CinePassion
  attr_reader :xml_data, :movies_info, :result_nb, :status, :quota
  
  VERSION = '0.7.0'
  
  # This class does not require parameters
  # First action is reset object
  def initialize
     self.DataReset()
  end
  
  # Reset object (With empty XML xml_data)
  def DataReset()
    @xml_data = ""
  end
  
  # Load XML data from online Cine Passion Scraper
  # Put movie name in parameter
  def DataLoadFromSite(search)
    proxy_host = proxy_port = proxy_user = proxy_password = nil
    if (ENV['http_proxy'])
        uri=URI.parse(ENV['http_proxy'])
        proxy_host = uri.host
        proxy_port = uri.port
        proxy_user,proxy_password = uri.userinfo.split(/:/) if uri.userinfo
    end
    conn = Net::HTTP::Proxy(proxy_host,proxy_port, proxy_user, proxy_password)
    
    query="Title" #|IMDB"
    lang="fr" # / en"
    format="XML"
    api_url="#{SITEURL}/scraper/API/1/Movie.Search/#{query}/#{lang}/#{format}/#{APIKEY}/#{search}"
    
    url = URI.parse(URI.escape(api_url))
        res = conn.start(url.host, url.port) {|http|
        http.get(url.path)
    }
    
    @xml_data = res.body
    self.ScrapAnalyse()
  end
  
  # Load XML data from file
  # Put filename with full path in parameter
  def DataLoadFromFile(filename)
    file = File.new(filename)
    
    @xml_data = file
    self.ScrapAnalyse()
  end
  
  # Explore XML data to extract informations
  # At this time the class get there informations:
  # * Movie -> See ScrapAnalyseOneMovie function
  # * Quota
  #  - authorize
  #  - use
  #  - reset_date
  def ScrapAnalyse()
    @result = {}
    @line = ""
    @result['status'] = 0
    @result_nb = 0
    @quota = {}
    @movies_info = []
    
    doc = Document.new(@xml_data)
    root = doc.root
    
    @movies_info = []
    root.each_element('movie') do |movie|
      @movies_info.push ScrapAnalyseOneMovie(movie)
    end
    @result_nb = @movies_info.count()
    
    if @result_nb == 0
      @status = 0
    elsif @result_nb == 1
      @status = 1
    elsif @result_nb > 1
      @status = 2
    end
    
    quota = root.elements['quota']      
    if not quota.nil?
       @quota['authorize']  = quota.attributes['authorize']
       @quota['use']        = quota.attributes['use']
       @quota['reset_date'] = quota.attributes['reset_date']
    end
    
    @result['quota'] = @quota
    @result['result_nb'] = @result_nb
    @result['line'] = @line
    @result['xml'] = doc.root
    @result['status'] = @status
    @result['movies_info'] = @movies_info
    
    return @result
  end
  
  # * Movie
  #  - id
  #  - id_allocine
  #  - id_imdb
  #  - last_change
  #  - url
  #  - title
  #  - originaltitle
  #  - year
  #  - runtime
  #  - plot
  #  - images
  #  - ratings
  def ScrapAnalyseOneMovie(oneMovieXML)
    movie_info = {}
    
    movie_info['id'] = oneMovieXML.elements['id'].text
    movie_info['id_allocine'] = oneMovieXML.elements['id_allocine'].text
    movie_info['id_imdb'] = oneMovieXML.elements['id_imdb'].text
    movie_info['last_change'] = oneMovieXML.elements['last_change'].text
    movie_info['url'] = oneMovieXML.elements['url'].text
    movie_info['title'] = oneMovieXML.elements['title'].text
    movie_info['originaltitle'] = oneMovieXML.elements['originaltitle'].text
    movie_info['year'] = oneMovieXML.elements['year'].text
    movie_info['runtime'] = oneMovieXML.elements['runtime'].text
    movie_info['plot'] = oneMovieXML.elements['plot'].text
    
    movie_info['images'] = {}
    images = oneMovieXML.elements["images"]
    if not images.nil?
      images.each_element("image") do |image|
         img_id = image.attributes['id']
         img_size = image.attributes['size']
         
         if not movie_info['images'].has_key? img_id
            movie_info['images'][img_id] = {}
         end
         
         movie_info['images'][img_id]['type'] = image.attributes['type']
         if not movie_info['images'][img_id].has_key? img_size
            movie_info['images'][img_id][img_size] = {}
         end
         movie_info['images'][img_id][img_size]['url']    = image.attributes['url']
         movie_info['images'][img_id][img_size]['width']  = image.attributes['width']
         movie_info['images'][img_id][img_size]['height'] = image.attributes['height']
      end
    end
    
    movie_info['ratings'] = {}
    movie_info['ratings']['cinepassion'] = {}
    movie_info['ratings']['allocine'] = {}
    movie_info['ratings']['imdb'] = {}
    ratings = oneMovieXML.elements["ratings"]
    ratings_cinepassion = ratings.elements["rating[@type='cinepassion']"]
    movie_info['ratings']['cinepassion']['votes'] = ratings_cinepassion.attributes['votes']
    movie_info['ratings']['cinepassion']['value'] = ratings_cinepassion.text
    ratings_allocine = ratings.elements["rating[@type='allocine']"]
    movie_info['ratings']['allocine']['votes'] = ratings_allocine.attributes['votes']
    movie_info['ratings']['allocine']['value'] = ratings_allocine.text
    ratings_imdb = ratings.elements["rating[@type='imdb']"]
    movie_info['ratings']['imdb']['votes'] = ratings_imdb.attributes['votes']
    movie_info['ratings']['imdb']['value'] = ratings_imdb.text
    
    nfo_base = "#{SITEURL}/scraper/index.php?id=#{movie_info['id']}&Download=1"
    movie_info['nfo'] = {}
    movie_info['nfo']['Babylon'] = {}
    movie_info['nfo']['Camelot'] = {}
    nfo_babylon = "#{nfo_base}&Version=0"
    movie_info['nfo']['Babylon']['fr'] = "#{nfo_babylon}&Lang=fr&OK=1"
    movie_info['nfo']['Babylon']['en'] = "#{nfo_babylon}&Lang=en&OK=1"
    nfo_camelot = "#{nfo_base}&Version=1"
    movie_info['nfo']['Camelot']['fr'] = "#{nfo_camelot}&Lang=fr&OK=1"
    movie_info['nfo']['Camelot']['en'] = "#{nfo_camelot}&Lang=en&OK=1"
    
    return movie_info
  end
  
  
  # Scrap get a filename with garbage information & clean it
  def Scrap(search)
    short_name = search.gsub(/\./, ' ')
    short_name.gsub!(/ (DVDRip|LiMiTED|REPACK|720p|FRENCH|UNRATED|iNTERNAL|TRUEFRENCH).*$/, '')
    
    DataLoadFromSite(short_name)
  end
end
