# -*- coding: utf-8 -*-
require 'test/unit'
require 'cine_passion'

# Suite tests of CinePassion scraper binding
# Many tests can be launch offline
class TestCinePassion < Test::Unit::TestCase
  
  # Test creation of object with right class
  def test_create_object
    @test = CinePassion.new
    assert_not_nil(@test)
    assert_instance_of(CinePassion, @test)
    assert_not_nil(@test.version)
  end
  
  # Test ability to define a apikey
  def test_can_have_apikey
    @test1 = CinePassion.new()
    assert_equal(@test1.apikey, "test-api-key")
    @test2 = CinePassion.new("fake-7945cb-fake")
    assert_equal(@test2.apikey, "test-api-key")
  end
  
  # Test ability to define a server
  def test_can_change_siteurl
    @test1 = CinePassion.new()
    assert_equal(@test1.siteurl, "http://scraper-cine-passion-demo.ledez.net")
    @test2 = CinePassion.new("a-key")
    assert_equal(@test2.siteurl, "http://passion-xbmc.org")
    @test2.defineOtherSiteURL("http://localhost:4567")
    assert_equal(@test2.siteurl, "http://localhost:4567")
    @test2.defineOtherSiteURL()
    assert_equal(@test2.siteurl, "http://passion-xbmc.org")
  end
  
  # Test GenerateURLMovieSearch & GenerateURLMovieGetInfo
  def test_generate_url
    @test1 = CinePassion.new()
    assert_equal(@test1.GenerateURLMovieSearch("toto"), "http://scraper-cine-passion-demo.ledez.net/scraper/API/1/Movie.Search/Title/en/XML/fake-7945cb-fake/toto")
    assert_equal(@test1.GenerateURLMovieGetInfo("toto"), "http://scraper-cine-passion-demo.ledez.net/scraper/API/1/Movie.GetInfo/ID/en/XML/fake-7945cb-fake/toto")
  end
  
  # Test ability to define a language for requests
  def test_can_change_language
    @test1 = CinePassion.new()
    assert_equal(@test1.lang, "en")
    @test1.defineLanguage("fr")
    assert_equal(@test1.lang, "fr")
  end
  
  # Test ability to define a proxy
  def test_can_have_apikey
    @test1 = CinePassion.new("test-api-key")
    assert_equal(@test1.proxyinfo, [nil, nil, nil, nil])
    
    @test2 = CinePassion.new("test-api-key", "http://127.0.0.1:3128/")
    assert_equal(@test2.proxyinfo, ["127.0.0.1", 3128, nil, nil])
    
    @test3 = CinePassion.new("test-api-key", "http://user:pass@127.0.0.1:3128/")
    assert_equal(@test3.proxyinfo, ["127.0.0.1", 3128, "user", "pass"])
  end
  
  # Test ability to load data from xml & reset data
  def test_data_load_and_reset
    @test = CinePassion.new
    assert_equal(@test.xml_data, "")
    
    @test.DataLoadFromFile("test/data/cinepassion-scraper-test-01-one-response.xml")
    assert_not_equal(@test.xml_data, "")
    
    @test.DataReset()
    assert_equal(@test.xml_data, "")
  end
  
  # Test ability to load data from network
  def test_data_load_from_network
    @test = CinePassion.new
    
    @test.MovieSearch("Home")
    assert_not_equal(@test.xml_data, "")
    @test.DataReset()
    
    @test.MovieGetInfo("136356")
    assert_not_equal(@test.xml_data, "")
  end
  
  # Test if scrap working
  def test_clean_moviename_working
    @test = CinePassion.new
    
    assert_equal(@test.CleanMovieName("Home.DVDRip"), "Home")
    assert_equal(@test.CleanMovieName("Home.LiMiTED"), "Home")
    assert_equal(@test.CleanMovieName("Home.REPACK"), "Home")
    assert_equal(@test.CleanMovieName("Home.720p"), "Home")
    assert_equal(@test.CleanMovieName("Home.FRENCH"), "Home")
    assert_equal(@test.CleanMovieName("Home.UNRATED"), "Home")
    assert_equal(@test.CleanMovieName("Home.iNTERNAL"), "Home")
    assert_equal(@test.CleanMovieName("Home.TRUEFRENCH"), "Home")
    assert_equal(@test.CleanMovieName("Home.DVDRip.LiMiTED.REPACK.720p.FRENCH.UNRATED.iNTERNAL.TRUEFRENCH"), "Home")
    assert_equal(@test.CleanMovieName("Home.TRUEFRENCH.iNTERNAL.UNRATED.FRENCH.720p.REPACK.LiMiTED.DVDRip"), "Home")
  end
  
  # Test if datas was properly extracted
  def test_xml_load_data
    @test = CinePassion.new
    
    # Test no response
    @test.DataLoadFromFile("test/data/cinepassion-scraper-test-00-no-response.xml")
    assert_not_equal(@test.xml_data, "")
    assert_equal(@test.result_nb, 0)
    
    # Extract all data in one result
    @test.DataLoadFromFile("test/data/cinepassion-scraper-test-01-one-response.xml")
    assert_not_equal(@test.xml_data, "")
    assert_equal(@test.result_nb, 1)
    assert_equal(@test.movies_info[0]['id'], "136356")
    assert_equal(@test.movies_info[0]['id_allocine'], "136356")
    assert_equal(@test.movies_info[0]['id_imdb'], "1234548")
    assert_equal(@test.movies_info[0]['last_change'], "1279466676")
    assert_equal(@test.movies_info[0]['url'], "http://passion-xbmc.org/scraper/index2.php?Page=ViewMovie&ID=136356")
    assert_equal(@test.movies_info[0]['title'], "Les Chèvres du Pentagone")
    assert_equal(@test.movies_info[0]['originaltitle'], "The Men Who Stare at Goats")
    assert_equal(@test.movies_info[0]['year'], "2009")
    assert_equal(@test.movies_info[0]['runtime'], "90")
    assert_equal(@test.movies_info[0]['plot'], "Bob Wilton, un journaliste désespéré fait l'heureuse rencontre de Lyn Cassady, un soldat aux pouvoirs paranormaux combattant le terrorisme. Ils se rendent ensemble en Irak ou ils rencontrent Bill Django, le fondateur de l'unité, et Larry Hooper, soldat de l'unité qui dirige une prison.")
    
    assert_equal(@test.movies_info[0]['images']['311335']['type'], "Poster")
    assert_equal(@test.movies_info[0]['images']['311335']['original']['height'], "2716")
    assert_equal(@test.movies_info[0]['images']['311335']['original']['width'], "2000")
    assert_equal(@test.movies_info[0]['images']['311335']['original']['url'], "http://passion-xbmc.org/scraper/Gallery/main/Poster_LesChvresduPentagone-311335.jpg")
    assert_equal(@test.movies_info[0]['images']['311335']['preview']['url'], "http://passion-xbmc.org/scraper/Gallery/preview/Poster_LesChvresduPentagone-311335.jpg")
    assert_equal(@test.movies_info[0]['images']['311335']['thumb']['url'], "http://passion-xbmc.org/scraper/Gallery/thumb/Poster_LesChvresduPentagone-311335.jpg")
    
    assert_equal(@test.movies_info[0]['images']['316672']['type'], "Fanart")
    assert_equal(@test.movies_info[0]['images']['316672']['original']['height'], "1080")
    assert_equal(@test.movies_info[0]['images']['316672']['original']['width'], "1920")
    assert_equal(@test.movies_info[0]['images']['316672']['original']['url'], "http://passion-xbmc.org/scraper/Gallery/main/Fanart_LesChvresduPentagone-316672.jpg")
    assert_equal(@test.movies_info[0]['images']['316672']['preview']['url'], "http://passion-xbmc.org/scraper/Gallery/preview/Fanart_LesChvresduPentagone-316672.jpg")
    assert_equal(@test.movies_info[0]['images']['316672']['thumb']['url'], "http://passion-xbmc.org/scraper/Gallery/thumb/Fanart_LesChvresduPentagone-316672.jpg")
    
    assert_equal(@test.movies_info[0]['ratings']['cinepassion']['votes'], "1")
    assert_equal(@test.movies_info[0]['ratings']['cinepassion']['value'], "7")
    assert_equal(@test.movies_info[0]['ratings']['allocine']['votes'], "1603")
    assert_equal(@test.movies_info[0]['ratings']['allocine']['value'], "2,5")
    assert_equal(@test.movies_info[0]['ratings']['imdb']['votes'], "30695")
    assert_equal(@test.movies_info[0]['ratings']['imdb']['value'], "6,4")
    
    assert_equal(@test.movies_info[0]['nfo']['Babylon']['fr'], "http://scraper-cine-passion-demo.ledez.net/scraper/index.php?id=136356&Download=1&Version=0&Lang=fr&OK=1")
    assert_equal(@test.movies_info[0]['nfo']['Babylon']['en'], "http://scraper-cine-passion-demo.ledez.net/scraper/index.php?id=136356&Download=1&Version=0&Lang=en&OK=1") 
    assert_equal(@test.movies_info[0]['nfo']['Camelot']['fr'], "http://scraper-cine-passion-demo.ledez.net/scraper/index.php?id=136356&Download=1&Version=1&Lang=fr&OK=1")
    assert_equal(@test.movies_info[0]['nfo']['Camelot']['en'], "http://scraper-cine-passion-demo.ledez.net/scraper/index.php?id=136356&Download=1&Version=1&Lang=en&OK=1")
    
    # Quota extraction
    assert_equal(@test.quota['authorize'], "300")
    assert_equal(@test.quota['use'], "1")
    assert_equal(@test.quota['reset_date'], "2010-08-04 12:45:26")
  end
  
  def test_xml_load_data_multiple_movies
    @test = CinePassion.new
    @test.DataLoadFromFile("test/data/cinepassion-scraper-test-02-mutiple-response.xml")
    
    # Quota extraction
    assert_not_equal(@test.xml_data, "")
    
    assert_equal(@test.result_nb, 20)
    
    assert_equal(@test.movies_info[0]['id'], "128179")
    assert_equal(@test.movies_info[0]['id_allocine'], "128179")
    assert_equal(@test.movies_info[0]['id_imdb'], "1014762")
    assert_equal(@test.movies_info[0]['last_change'], "1279466610")
    
    assert_equal(@test.movies_info[1]['id'], "125081")
    assert_equal(@test.movies_info[1]['id_allocine'], "125081")
    assert_equal(@test.movies_info[1]['id_imdb'], "822388")
    assert_equal(@test.movies_info[1]['last_change'], "1279466639")
    
    assert_equal(@test.movies_info[2]['id'], "130190")
    assert_equal(@test.movies_info[2]['id_allocine'], "130190")
    assert_equal(@test.movies_info[2]['id_imdb'], "1319569")
    assert_equal(@test.movies_info[2]['last_change'], "1279466629")
    
    assert_equal(@test.movies_info[3]['id'], "24226")
    assert_equal(@test.movies_info[3]['id_allocine'], "24226")
    assert_equal(@test.movies_info[3]['id_imdb'], "825475")
    assert_equal(@test.movies_info[3]['last_change'], "1279466647")
    
    assert_equal(@test.movies_info[4]['id'], "172454")
    assert_equal(@test.movies_info[4]['id_allocine'], "172454")
    assert_equal(@test.movies_info[4]['id_imdb'], "861795")
    assert_equal(@test.movies_info[4]['last_change'], "1279466623")
    
    assert_equal(@test.movies_info[5]['id'], "61770")
    assert_equal(@test.movies_info[5]['id_allocine'], "61770")
    assert_equal(@test.movies_info[5]['id_imdb'], "471005")
    assert_equal(@test.movies_info[5]['last_change'], "1279466668")
    
    assert_equal(@test.movies_info[6]['id'], "126889")
    assert_equal(@test.movies_info[7]['id'], "61521")
    assert_equal(@test.movies_info[8]['id'], "111582")
    assert_equal(@test.movies_info[9]['id'], "108235")
    assert_equal(@test.movies_info[10]['id'], "124132")
    assert_equal(@test.movies_info[11]['id'], "38634")
    assert_equal(@test.movies_info[12]['id'], "112059")
    assert_equal(@test.movies_info[13]['id'], "23239")
    assert_equal(@test.movies_info[14]['id'], "7380")
    assert_equal(@test.movies_info[15]['id'], "112129")
    assert_equal(@test.movies_info[16]['id'], "19203")
    assert_equal(@test.movies_info[17]['id'], "36161")
    assert_equal(@test.movies_info[18]['id'], "36331")
    assert_equal(@test.movies_info[19]['id'], "16194")
    
    assert_equal(@test.quota['authorize'], "300")
    assert_equal(@test.quota['use'], "2")
    assert_equal(@test.quota['reset_date'], "2010-08-04 12:45:26")
    
    # Extract all data from getInfo(id)
    @test.DataLoadFromFile("test/data/cinepassion-scraper-test-03-by-id.xml")
    assert_not_equal(@test.xml_data, "")
    assert_equal(@test.result_nb, 1)
    assert_equal(@test.movies_info[0]['id'], "136356")
    assert_equal(@test.movies_info[0]['id_allocine'], "136356")
    assert_equal(@test.movies_info[0]['id_imdb'], "1234548")
    assert_equal(@test.movies_info[0]['last_change'], "1279466676")
    assert_equal(@test.movies_info[0]['url'], "http://passion-xbmc.org/scraper/index2.php?Page=ViewMovie&ID=136356")
    assert_equal(@test.movies_info[0]['title'], "Les Chèvres du Pentagone")
    assert_equal(@test.movies_info[0]['originaltitle'], "The Men Who Stare at Goats")
    assert_equal(@test.movies_info[0]['year'], "2009")
    assert_equal(@test.movies_info[0]['directors'][0], "Grant Heslov")
    assert_equal(@test.movies_info[0]['plot'], "Bob Wilton, un journaliste désespéré fait l'heureuse rencontre de Lyn Cassady, un soldat aux pouvoirs paranormaux combattant le terrorisme. Ils se rendent ensemble en Irak ou ils rencontrent Bill Django, le fondateur de l'unité, et Larry Hooper, soldat de l'unité qui dirige une prison.")
    assert_equal(@test.movies_info[0]['tagline'], "(...) un casting de rêve pour une comédie dont l'insolence revigorante et l'absurdité assumée rappellent le récent Burn after reading des frères Coen. Jubilatoire!")
    assert_equal(@test.movies_info[0]['runtime'], "90")
    assert_equal(@test.movies_info[0]['information'], "Couleur  / Format de projection : 2.35 : 1 Cinemascope / Format de production : 35 mm")
    assert_equal(@test.movies_info[0]['trailers'][0], "http://hd.fr.mediaplayer.allocine.fr/nmedia/18/73/11/43/18937641_fa2_vost_hd.flv")
    assert_equal(@test.movies_info[0]['countries'][0], "américain")
    assert_equal(@test.movies_info[0]['genres'][0], "Comédie")
    assert_equal(@test.movies_info[0]['studios'][0], "Sony Pictures Releasing")
    assert_equal(@test.movies_info[0]['credits'][0], "Peter Straughan")
    
    assert_equal(@test.movies_info[0]['images']['311335']['type'], "Poster")
    assert_equal(@test.movies_info[0]['images']['311335']['original']['height'], "2716")
    assert_equal(@test.movies_info[0]['images']['311335']['original']['width'], "2000")
    assert_equal(@test.movies_info[0]['images']['311335']['original']['url'], "http://passion-xbmc.org/scraper/Gallery/main/Poster_LesChvresduPentagone-311335.jpg")
    assert_equal(@test.movies_info[0]['images']['311335']['preview']['url'], "http://passion-xbmc.org/scraper/Gallery/preview/Poster_LesChvresduPentagone-311335.jpg")
    assert_equal(@test.movies_info[0]['images']['311335']['thumb']['url'], "http://passion-xbmc.org/scraper/Gallery/thumb/Poster_LesChvresduPentagone-311335.jpg")
    
    assert_equal(@test.movies_info[0]['images']['316672']['type'], "Fanart")
    assert_equal(@test.movies_info[0]['images']['316672']['original']['height'], "1080")
    assert_equal(@test.movies_info[0]['images']['316672']['original']['width'], "1920")
    assert_equal(@test.movies_info[0]['images']['316672']['original']['url'], "http://passion-xbmc.org/scraper/Gallery/main/Fanart_LesChvresduPentagone-316672.jpg")
    assert_equal(@test.movies_info[0]['images']['316672']['preview']['url'], "http://passion-xbmc.org/scraper/Gallery/preview/Fanart_LesChvresduPentagone-316672.jpg")
    assert_equal(@test.movies_info[0]['images']['316672']['thumb']['url'], "http://passion-xbmc.org/scraper/Gallery/thumb/Fanart_LesChvresduPentagone-316672.jpg")
    
    assert_equal(@test.movies_info[0]['ratings']['cinepassion']['votes'], "1")
    assert_equal(@test.movies_info[0]['ratings']['cinepassion']['value'], "7")
    assert_equal(@test.movies_info[0]['ratings']['allocine']['votes'], "1603")
    assert_equal(@test.movies_info[0]['ratings']['allocine']['value'], "2,5")
    assert_equal(@test.movies_info[0]['ratings']['imdb']['votes'], "33172")
    assert_equal(@test.movies_info[0]['ratings']['imdb']['value'], "6,4")
    
    assert_equal(@test.movies_info[0]['casting']['10551']['name'], "Stephen Root")
    assert_equal(@test.movies_info[0]['casting']['10551']['character'], "Gus Lacey")
    assert_equal(@test.movies_info[0]['casting']['10551']['idthumb'], "0")
    assert_equal(@test.movies_info[0]['casting']['10551']['thumb'], "http://passion-xbmc.org/scraper/Images/Actor_Unknow.png")
    assert_equal(@test.movies_info[0]['casting']['103366']['name'], "Nick Offerman")
    assert_equal(@test.movies_info[0]['casting']['103366']['character'], "Scotty Mercer")
    assert_equal(@test.movies_info[0]['casting']['103366']['idthumb'], "0")
    assert_equal(@test.movies_info[0]['casting']['103366']['thumb'], "http://passion-xbmc.org/scraper/Images/Actor_Unknow.png")
    assert_equal(@test.movies_info[0]['casting']['32799']['name'], "J.K. Simmons")
    assert_equal(@test.movies_info[0]['casting']['32799']['character'], "le général Putkin")
    assert_equal(@test.movies_info[0]['casting']['32799']['idthumb'], "32423")
    assert_equal(@test.movies_info[0]['casting']['32799']['thumb'], "http://passion-xbmc.org/scraper/Gallery/main/JKSimmons-32423.jpg")
    assert_equal(@test.movies_info[0]['casting']['12399']['name'], "Kevin Spacey")
    assert_equal(@test.movies_info[0]['casting']['12399']['character'], "Larry Hooper")
    assert_equal(@test.movies_info[0]['casting']['12399']['idthumb'], "32271")
    assert_equal(@test.movies_info[0]['casting']['12399']['thumb'], "http://passion-xbmc.org/scraper/Gallery/main/KevinSpacey-32271.jpg")
    assert_equal(@test.movies_info[0]['casting']['111326']['name'], "Tim Griffin")
    assert_equal(@test.movies_info[0]['casting']['111326']['character'], "Tim Kootz")
    assert_equal(@test.movies_info[0]['casting']['111326']['idthumb'], "0")
    assert_equal(@test.movies_info[0]['casting']['111326']['thumb'], "http://passion-xbmc.org/scraper/Images/Actor_Unknow.png")
    assert_equal(@test.movies_info[0]['casting']['6298']['name'], "Robert Patrick")
    assert_equal(@test.movies_info[0]['casting']['6298']['character'], "Todd Nixon")
    assert_equal(@test.movies_info[0]['casting']['6298']['idthumb'], "31401")
    assert_equal(@test.movies_info[0]['casting']['6298']['thumb'], "http://passion-xbmc.org/scraper/Gallery/main/RobertPatrick-31401.jpg")
    assert_equal(@test.movies_info[0]['casting']['17043']['name'], "Ewan McGregor")
    assert_equal(@test.movies_info[0]['casting']['17043']['character'], "Bob Wilton")
    assert_equal(@test.movies_info[0]['casting']['17043']['idthumb'], "31599")
    assert_equal(@test.movies_info[0]['casting']['17043']['thumb'], "http://passion-xbmc.org/scraper/Gallery/main/EwanMcGregor-31599.jpg")
    assert_equal(@test.movies_info[0]['casting']['6407']['name'], "Stephen Lang")
    assert_equal(@test.movies_info[0]['casting']['6407']['character'], "le général Hopgood")
    assert_equal(@test.movies_info[0]['casting']['6407']['idthumb'], "50691")
    assert_equal(@test.movies_info[0]['casting']['6407']['thumb'], "http://passion-xbmc.org/scraper/Gallery/main/StephenLang-50691.jpg")
    assert_equal(@test.movies_info[0]['casting']['1052']['name'], "Jeff Bridges")
    assert_equal(@test.movies_info[0]['casting']['1052']['character'], "Bill Django")
    assert_equal(@test.movies_info[0]['casting']['1052']['idthumb'], "31026")
    assert_equal(@test.movies_info[0]['casting']['1052']['thumb'], "http://passion-xbmc.org/scraper/Gallery/main/JeffBridges-31026.jpg")
  end
end
