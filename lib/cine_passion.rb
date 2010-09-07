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

class CinePassion
  attr_reader :xml_data, :movies_info, :result_nb, :status, :quota, :apikey, :siteurl, :proxyinfo, :lang
  
  VERSION = '0.10.2'

  def version()
     return VERSION
  end
  
  # This class does not require parameters
  # First action is reset object
  def initialize(apikey=nil, proxy=nil)
     if apikey.nil?
        @apikey = "fake-7945cb-fake"
        defineOtherSiteURL("http://scraper-cine-passion-demo.ledez.net")
        puts '*'*50
        puts "I need a apikey to get real values"
        puts " Please see README to create it"
        puts "currently I use theres values :"
        puts "@siteurl: #{@siteurl}"
        puts "@apikey; #{@apikey}"
        puts '*'*50
     else
        @apikey = apikey
        defineOtherSiteURL("http://passion-xbmc.org")
     end
     
     @proxy_host = @proxy_port = @proxy_user = @proxy_password = nil
     if (ENV['http_proxy'] || proxy)
         uri=URI.parse(ENV['http_proxy']) if proxy.nil?
         uri=URI.parse(proxy) if ENV['http_proxy'].nil?
         @proxy_host = uri.host
         @proxy_port = uri.port
         @proxy_user, @proxy_password = uri.userinfo.split(/:/) if uri.userinfo
     end
     @proxyinfo = [@proxy_host, @proxy_port, @proxy_user, @proxy_password]
     
     self.defineLanguage()
     self.DataReset()
  end
  
  # Define other host to scrap
  #  Default http://passion-xbmc.org
  def defineOtherSiteURL(siteurl=nil)
      if siteurl.nil?
        @siteurl = "http://passion-xbmc.org"
      else
        @siteurl = siteurl
      end
  end
  
  # define a language to scrap
  #  Default en
  def defineLanguage(lang="en")
    @lang = lang
  end
  
  # Reset object (With empty XML xml_data)
  def DataReset()
    @xml_data = ""
  end
  
  # Load XML data from online Cine Passion Scraper
  # Put movie name in parameter
  def DataLoadFromSite(url)
    conn = Net::HTTP::Proxy(@proxy_host, @proxy_port, @proxy_user, @proxy_password)
    
    request = URI.parse(URI.escape(url))
        res = conn.start(request.host, request.port) {|http|
        http.get(request.path)
    }
    
    @xml_data = res.body
    self.ScrapAnalyse()
  end
  
  # Generate URL For Movie.Search
  def GenerateURLMovieSearch(search, query="Title", format="XML")
    "#{@siteurl}/scraper/API/1/Movie.Search/#{query}/#{@lang}/#{format}/#{@apikey}/#{search}"
  end
  
  # Generate URL For Movie.GetInfo
  def GenerateURLMovieGetInfo(search, query="ID", format="XML")
    "#{@siteurl}/scraper/API/1/Movie.GetInfo/#{query}/#{@lang}/#{format}/#{@apikey}/#{search}"
  end
  
  # Execute a MovieSearch on scraper
  def MovieSearch(search, query="Title", format="XML")
    DataLoadFromSite(GenerateURLMovieSearch(search, query=query, format=format))
    @xml_data
  end
  
  # Execute a MovieGetInfo on scraper
  def MovieGetInfo(search, query="ID", format="XML")
    DataLoadFromSite(GenerateURLMovieGetInfo(search, query=query, format=format))
    @xml_data
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
  # * Movie -> See ScrapAnalyseOneMovieElement function
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
    begin
       doc.root.elements["movie"].has_elements?
       root = doc.root
    rescue
       root = doc
    end
    
    @movies_info = []
    root.each_element('movie') do |movie|
      @movies_info.push ScrapAnalyseOneMovieElement(movie)
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
  def ScrapAnalyseOneMovieElement(oneMovieXML)
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
    movie_info['tagline'] = oneMovieXML.elements['tagline'].text if not oneMovieXML.elements['tagline'].nil?
    movie_info['information'] = oneMovieXML.elements['information'].text if not oneMovieXML.elements['information'].nil?
    
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
    
    movie_info['directors'] = []
    directors = oneMovieXML.elements["directors"]
    if not directors.nil?
      directors.each_element("director") do |director|
        movie_info['directors'].push(director.text)
      end
    end
    
    movie_info['trailers'] = []
    trailers = oneMovieXML.elements["trailers"]
    if not trailers.nil?
      trailers.each_element("trailer") do |trailer|
        movie_info['trailers'].push(trailer.text)
      end
    end
    
    movie_info['countries'] = []
    countries = oneMovieXML.elements["countries"]
    if not countries.nil?
      countries.each_element("country") do |country|
        movie_info['countries'].push(country.text)
      end
    end
    
    movie_info['genres'] = []
    genres = oneMovieXML.elements["genres"]
    if not genres.nil?
      genres.each_element("genre") do |genre|
        movie_info['genres'].push(genre.text)
      end
    end
    
    movie_info['studios'] = []
    studios = oneMovieXML.elements["studios"]
    if not studios.nil?
      studios.each_element("studio") do |studio|
        movie_info['studios'].push(studio.text)
      end
    end
    
    movie_info['credits'] = []
    credits = oneMovieXML.elements["credits"]
    if not credits.nil?
      credits.each_element("credit") do |credit|
        movie_info['credits'].push(credit.text)
      end
    end
    
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
    
    movie_info['casting'] = {}
    casting = oneMovieXML.elements["casting"]
    if not casting.nil?
      casting.each_element("person") do |person|
         person_id = person.attributes['id']
         
         if not movie_info['casting'].has_key? person_id
            movie_info['casting'][person_id] = {}
         end
         
         movie_info['casting'][person_id]['name'] = person.attributes['name']
         movie_info['casting'][person_id]['character'] = person.attributes['character']
         movie_info['casting'][person_id]['idthumb'] = person.attributes['idthumb']
         movie_info['casting'][person_id]['thumb'] = person.attributes['thumb']
      end
    end
    
    nfo_base = "#{@siteurl}/scraper/index.php?id=#{movie_info['id']}&Download=1"
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
  def CleanMovieName(search)
    short_name = search.gsub(/\./, ' ')
    short_name.gsub!(/ (DVDRip|LiMiTED|REPACK|720p|FRENCH|UNRATED|iNTERNAL|TRUEFRENCH).*$/, '')
    
    short_name
  end
end
