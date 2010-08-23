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

require 'cine_passion_config'

class CinePassion
  attr_reader :xml_data, :movie_info, :result_nb, :status, :quota

  VERSION = '0.5.0'
 unless defined? MAJOR
   MAJOR  = 0
   MINOR  = 5
   TINY   = 0
   PRE    = nil

   STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')

   SUMMARY = "cine-passion #{STRING}"
 end

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
    query="Title" #|IMDB"
    lang="fr" # / en"
    format="XML"
    api_url="#{SITEURL}/scraper/API/1/Movie.Search/#{query}/#{lang}/#{format}/#{APIKEY}/#{search}"

    url = URI.parse(URI.escape(api_url))
        res = Net::HTTP.start(url.host, url.port) {|http|
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
  #  - images => TODO
  #  - ratings => TODO
  # * Quota
  #  - authorize
  #  - use
  #  - reset_date
  def ScrapAnalyse()
    @result = {}
    @line = ""
    @result['status'] = 0
    @movie_info = {}
    @result_nb = 0
    @quota = {}

    doc = Document.new(@xml_data)
    root = doc.root

    root.each_element('movie') { |element|
      @line += "#{element.elements['title'].text} (#{element.elements['year'].text})\n"
      @result_nb+=1
    }

    if @result_nb == 0
      @status = 0
    elsif @result_nb == 1
      @status = 1
    elsif @result_nb > 1
      @status = 2
    end

    if @status == 1
      @movie_info['id'] = root.elements['movie'].elements['id'].text
      @movie_info['id_allocine'] = root.elements['movie'].elements['id_allocine'].text
      @movie_info['id_imdb'] = root.elements['movie'].elements['id_imdb'].text
      @movie_info['last_change'] = root.elements['movie'].elements['last_change'].text
      @movie_info['url'] = root.elements['movie'].elements['url'].text
      @movie_info['title'] = root.elements['movie'].elements['title'].text
      @movie_info['originaltitle'] = root.elements['movie'].elements['originaltitle'].text
      @movie_info['year'] = root.elements['movie'].elements['year'].text
      @movie_info['runtime'] = root.elements['movie'].elements['runtime'].text
      @movie_info['plot'] = root.elements['movie'].elements['plot'].text
      @movie_info['images'] = []

      @movie_info['ratings'] = {}
      @movie_info['ratings']['cinepassion'] = {}
      @movie_info['ratings']['allocine'] = {}
      @movie_info['ratings']['imdb'] = {}
      ratings = root.elements['movie'].elements["ratings"]
      ratings_cinepassion = ratings.elements["rating[@type='cinepassion']"]
      @movie_info['ratings']['cinepassion']['votes'] = ratings_cinepassion.attributes['votes']
      @movie_info['ratings']['cinepassion']['value'] = ratings_cinepassion.text
      ratings_allocine = ratings.elements["rating[@type='allocine']"]
      @movie_info['ratings']['allocine']['votes'] = ratings_allocine.attributes['votes']
      @movie_info['ratings']['allocine']['value'] = ratings_allocine.text
      ratings_imdb = ratings.elements["rating[@type='imdb']"]
      @movie_info['ratings']['imdb']['votes'] = ratings_imdb.attributes['votes']
      @movie_info['ratings']['imdb']['value'] = ratings_imdb.text
    end

    if @status > 0
       @quota['authorize'] = root.elements['quota'].attributes['authorize']
       @quota['use'] =  root.elements['quota'].attributes['use']
       @quota['reset_date'] =  root.elements['quota'].attributes['reset_date']
    end

    @result['quota'] = @quota
    @result['result_nb'] = @result_nb
    @result['line'] = @line
    @result['xml'] = doc.root
    @result['status'] = @status
    @result['movie_info'] = @movie_info

    return @result
  end

  # Scrap get a filename with garbage information & clean it
  def Scrap(search)
    short_name = search.gsub(/\./, ' ')
    short_name.gsub!(/ (DVDRip|LiMiTED|REPACK|720p|FRENCH|UNRATED|iNTERNAL|TRUEFRENCH).*$/, '')
    
    DataLoadFromSite(short_name)
  end
end
