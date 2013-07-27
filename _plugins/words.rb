require_relative 'syntax_parse'
require_relative 'interlacer'
require_relative 'hash_indexer'
# Word Objects
module Jekyll
  class QuotePage < Page
    def initialize(site, base, dir, quote, index)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "quote.html")
      self.data['quote'] = quote
      self.data['url'] = index
      #self.data['raw'] = raw
      self.data['title'] = "Quote #{index}"
      self.data['subtitle'] = "#{index}"
    end
  end
  class WordPage < Page
    def initialize(site, base, dir, quote, index)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "word.html")
      self.data['word'] = quote
      self.data['url'] = index
      #self.data['raw'] = raw
      self.data['title'] = "Translation #{index}"
      self.data['subtitle'] = "#{index}"
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
      # Assign URL index to quosts
      quotes_hash = hash_index(quotes_array) { |i| i + 1 }
      # quotes_array site data
      site.config['quotes'] = quotes_hash
      # Make Pages
      #raw_quotes = quotes_text.split(/\n{2,}/m)
      quotes_hash.each do |i, q|
        dir = i.to_s
        #raw = raw_quotes[index].each_line.to_a
        site.pages << QuotePage.new(site, site.source, dir, q, i)
      end

      # Parse Words
      words_text = File.read(File.join(site.source, 'btp_words.txt'))
      parser = BtpWordsParser.new
      raw_words = words_text.split(/\n+/m)
      words_array = parser.parse(raw_words)
      words_hash = hash_index(words_array) { |i| i + 500 }
      site.config['words'] = words_hash
      words_hash.each do |i, q|
        dir = i.to_s
        #raw = raw_quotes[index].each_line.to_a
        site.pages << WordPage.new(site, site.source, dir, q, i)
      end

      
      # Interlace Quotes and Words
      stream = interlace_arrays(quotes_hash, words_hash)
      site.config['interlaced'] = stream
      puts 
      # puts quotes_array.count
      # puts words_array.count
      puts "Total Stream Items: #{stream.count}"


    end
  end
end