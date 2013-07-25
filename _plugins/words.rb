require_relative 'syntax_parse'
require_relative 'interlacer'
# Word Objects
module Jekyll

  class WordsDataGenerator < Generator
    safe true
    def generate(site)
      quotes_text = File.read(File.join(site.source, 'btp_quotes_dev.txt'))
      parser = BtpParser.new
      quotes_array = parser.parse(quotes_text)
      site.config['quotes'] = quotes_array

      words_text = File.read(File.join(site.source, 'btp_words.txt'))
      parser = BtpWordsParser.new
      words_array = parser.parse(words_text)
      site.config['words'] = words_array

      site.config['interlaced'] = interlace_arrays(quotes_array, words_array)

    end
  end
end