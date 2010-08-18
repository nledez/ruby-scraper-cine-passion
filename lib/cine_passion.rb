require 'uri'
require 'net/http'
require 'rexml/document'
include REXML

class CinePassion
  attr_reader :data, :movie_info, :result_nb, :status, :quota

  def initialize
     self.DataReset()
  end

  def DataReset()
    @data = ""
  end

  def DataLoadFromSite(search)
    query="Title" #|IMDB"
    lang="fr" # / en"
    format="XML"
    apikey="6f518c31f6baa365f55c38d11cc349d1"
    api_url="http://passion-xbmc.org/scraper/API/1/Movie.Search/#{query}/#{lang}/#{format}/#{apikey}/#{search}"


    url = URI.parse(URI.escape(api_url))
        res = Net::HTTP.start(url.host, url.port) {|http|
        http.get(url.path)
    }

    @data = res.body
    self.ScrapAnalyse()
  end

  def DataLoadFromFile(filename)
    file = File.new(filename)

    @data = file
    self.ScrapAnalyse()
  end

  def ScrapAnalyse()
    @result = {}
    @line = ""
    @result['status'] = 0
    @movie_info = {}
    @result_nb = 0
    @quota = {}

    doc = Document.new(@data)
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
      @movie_info['ratings'] = []
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

  def Scrap(search)
    short_name = search.gsub(/\./, ' ')
    short_name.gsub!(/ (DVDRip|LiMiTED|REPACK|720p|FRENCH|UNRATED|iNTERNAL|TRUEFRENCH).*$/, '')
    
    DataLoadFromSite(short_name)
  end
end
