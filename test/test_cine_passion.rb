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
    assert_equal(@test.movie_info['id'], "136356")
    assert_equal(@test.movie_info['id_allocine'], "136356")
    assert_equal(@test.movie_info['id_imdb'], "1234548")
    assert_equal(@test.movie_info['last_change'], "1279466676")
    assert_equal(@test.movie_info['url'], "http://passion-xbmc.org/scraper/index2.php?Page=ViewMovie&ID=136356")
    assert_equal(@test.movie_info['title'], "Les Chèvres du Pentagone")
    assert_equal(@test.movie_info['originaltitle'], "The Men Who Stare at Goats")
    assert_equal(@test.movie_info['year'], "2009")
    assert_equal(@test.movie_info['runtime'], "90")
    assert_equal(@test.movie_info['plot'], "Bob Wilton, un journaliste désespéré fait l'heureuse rencontre de Lyn Cassady, un soldat aux pouvoirs paranormaux combattant le terrorisme. Ils se rendent ensemble en Irak ou ils rencontrent Bill Django, le fondateur de l'unité, et Larry Hooper, soldat de l'unité qui dirige une prison.")
    assert_equal(@test.movie_info['ratings']['cinepassion']['votes'], "1")
    assert_equal(@test.movie_info['ratings']['cinepassion']['value'], "7")
    assert_equal(@test.movie_info['ratings']['allocine']['votes'], "1603")
    assert_equal(@test.movie_info['ratings']['allocine']['value'], "2,5")
    assert_equal(@test.movie_info['ratings']['imdb']['votes'], "30695")
    assert_equal(@test.movie_info['ratings']['imdb']['value'], "6,4")

    # Quota extraction
    assert_equal(@test.quota['authorize'], "300")
    assert_equal(@test.quota['use'], "1")
    assert_equal(@test.quota['reset_date'], "2010-08-04 12:45:26")

    # Extract multiple responses
    @test.DataLoadFromFile("test/data/cinepassion-scraper-test-02-mutiple-response.xml")
    assert_not_equal(@test.xml_data, "")
    assert_equal(@test.quota['authorize'], "300")
    assert_equal(@test.quota['use'], "2")
    assert_equal(@test.quota['reset_date'], "2010-08-04 12:45:26")
  end
end
