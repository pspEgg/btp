require_relative 'syntax_parse'
# Word Objects
module Jekyll

  class WordsDataGenerator < Generator
    safe true
    def generate(site)
      quotes_text = File.read(File.join(site.source, 'btp_quotes_dev.txt'))
      parser = BtpParser.new
      quotes_array = parser.parse(quotes_text)
      site.config['quotes'] = quotes_array
    end
  end
end