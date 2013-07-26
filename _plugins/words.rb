require_relative 'syntax_parse'
require_relative 'interlacer'
# Word Objects
module Jekyll
  class QuotePage < Page
    def initialize(site, base, dir, quote, raw, index)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "quote.html")
      self.data['quote'] = quote
      self.data['raw'] = raw
      self.data['title'] = "Quote #{index}"
    end
  end

  class WordsDataGenerator < Generator
    safe true
    def generate(site)
      # Parse Quotes
      quotes_text = File.read(File.join(site.source, 'btp_quotes_dev.txt'))
      parser = BtpParser.new
      raw_quotes = quotes_text.split(/\n{2,}/m)
      quotes_array = parser.parse(raw_quotes)
      site.config['quotes'] = quotes_array

      # Parse Words
      words_text = File.read(File.join(site.source, 'btp_words.txt'))
      parser = BtpWordsParser.new
      raw_words = words_text.split(/\n+/m)
      words_array = parser.parse(raw_words)
      site.config['words'] = words_array
      
      # Interlace Quotes and Words
      stream = interlace_arrays(quotes_array, words_array)
      site.config['interlaced'] = stream
      # puts 
      # puts quotes_array.count
      # puts words_array.count
      # puts stream.count

      raw_quotes = quotes_text.split(/\n{2,}/m)
      # Make Pages
      quotes_array.each_with_index do |html, index|
        dir = (index).to_s
        raw = raw_quotes[index].each_line.to_a
        site.pages << QuotePage.new(site, site.source, dir, html, raw, index)
      end
    end
  end
end