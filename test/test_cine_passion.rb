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
    
    @test.DataLoadFromSite("Home")
    assert_not_equal(@test.xml_data, "")
  end
  
  # Test if scrap working
  def test_scrap_load_data
    @test = CinePassion.new
    
    @test.Scrap("Home")
    assert_not_equal(@test.xml_data, "")
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
  end

end
