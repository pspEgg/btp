# syntax_parse.rb
class BtpString
  attr_accessor :sting, :display_rule
  def initialize(string, &display_rule)
    @string = string
    @display_rule = display_rule
  end
  def to_s
    @display_rule.call(@string)
  end
end
class BtpWordsParser
  def parse(array)
    array.map! do |p|
      # Pinyin Super Scripts []
      p.gsub!(/\[([^\]\[]+)\]/){|s|BtpPinyinSuperScript.new($1)}
      # trans
      p.gsub!(/（(.[^（）]+)）/){|s| "<br />" + BtpTranslation.new($1).to_s}  
      # entire line
      p.gsub!(/^(.+)$/){|s| BtpQuote.new($1)}

      p = "<div class=\"translation-article\">#{p}</div>"
      # p = "<div class=\"translation-article-wrapper\">#{p}</div>"
    end
    array
  end
end
class BtpParser
  def parse(array)
    array.map! do |p|
      # Pinyin Super Scripts []
      p.gsub!(/\[([^\]\[]+)\]/){|s|BtpPinyinSuperScript.new($1)}
      # Trailing "，"
      p.chomp!('，')
      # Subscript Characters
      p.gsub!(/([\u2080-\u2089]+)/){|s| "<sub>#{s}</sub>"}
      # Line in the beginning or the middle
      p.gsub!(/^([^>（）\n]+)$(?=\n[^\z])/){|s| BtpScene.new($1)}
      # Last Line
      if (p.gsub!(/^([^>（）\n]+)\z/){|s| BtpComment.new($1)}).nil?
      #   p << "\n" + BtpComment.new('').to_s
      end
      # newline（Action）
      p.gsub!(/^（(.[^（）]+)）/){|s| BtpAction.new($1)}
      # inline（TRANS）
      p.gsub!(/（(.[^（）]+)）/){|s| BtpTranslation.new($1)}  
      # > ...
      p.gsub!(/^>(.+)$/){|s| BtpQuote.new($1)}

      "<div class=\"quote-article\">#{p}</div>"
    end
  end
end
class BtpTranslation < BtpString
  def initialize(string)
    super(string) {|s| "<span class=\"trans\">（#{s}）</span>"}
  end
end
class BtpAction < BtpString
  def initialize(string)
    super(string) {|s| "<p class=\"action\">(#{s})</p>"}
  end
end
class BtpQuote < BtpString
  def initialize(string)
    super(string) {|s| "<blockquote class=\"quote\">#{s}</blockquote>"}
  end
end
class BtpScene < BtpString
  def initialize(string)
    super(string) {|s| "<p class=\"scene\">#{s}，</p>"}
  end
end
class BtpComment < BtpString
  def initialize(string)
    # With the Square in front
    super(string) {|s| "<p class=\"comment\">█ #{s}</p>"}
  end
end
class BtpPinyinSuperScript < BtpString
  def initialize(string)
    # e.g. [suī]
    super(string) {|s| "<sup class=\"pinyin\">#{s}</sup>"}
  end
end
# between "（）" but not on newline.
# re_display_hash = {
#   /.+（([^（）]+)）/ => -> s {"#{@string}"}
# }
# text = File.read('./quotes_v2.txt')
# parser = BtpParser.new
# array = parser.parse(text)
# puts array[20..23]
