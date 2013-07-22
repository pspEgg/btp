# Word Objects
module Jekyll

  class PinyinMark
    def initialize string
      @string = string
    end
    def to_s
      "<span class='pinyin-mark'>#{@string}</span>"
    end
  end
  class Semantifier
    attr_accessor :file, :rules
    def initialize rules, file_path
      @rules = rules
      @file = File.read(file_path)
    end
    def apply_rules
      @rules.each do |regex, sub_block|
        @file.gsub!(regex) do |m|
          sub_block.call($1)
        end
      end
    end
  end


  class WordsDataGenerator < Generator
    safe true
    def generate(site)
      rules = {
        # [pinyin]
        /\[([^\[\]]+)\]/ => proc { |s| "<sup class='pinyin-mark'>#{s}</sup>" },
        # (translation)
        /（([^（）]+)）/ =>  proc { |s| "<span class='trans'>（#{s}）</span>" }
      }
      words_path = site.config['data']['words']
      sub_words = Semantifier.new(rules, words_path)
      sub_words.apply_rules
      site.config['words'] = sub_words.file.each_line.to_a

      quotes_path = site.config['data']['quotes']
      sub_words.file = File.read(quotes_path)
      rules = {
        # #8320 - #8329
        /([\u2080-\u2089]+)/ => proc { |s| "<sub>#{s}</sub>"}
      }
      sub_words.rules.merge! rules
      sub_words.apply_rules
      site.config['quotes'] = sub_words.file.split(/^\n/)
    end
  end
end