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
class BtpParser
  attr_accessor :deliminator, :re_display_hash
  def initialize(deliminator = /\n{2,}/m)
    @deliminator = deliminator
    @re_display_hash = Hash(re_display_hash)
  end
  def parse(text)
    array = text.split(@deliminator)
    array.each do |p|
      # Pinyin Super Scripts []
      p.gsub!(/\[([^\]\[]+)\]/){|s|BtpPinyinSuperScript.new($1)}
      # Trailing "，"
      p.chomp!('，')
      # Subscript Characters
      p.gsub!(/([\u2080-\u2089]+)/){|s| "<sub>#{s}</sub>"}
      # Normal line
      p.gsub!(/^([^>（）\n]+)/){|s| BtpDescription.new($1)}
      # newline（Action）
      p.gsub!(/^（(.[^（）]+)）/){|s| BtpAction.new($1)}
      # inline（TRANS）
      p.gsub!(/（(.[^（）]+)）/){|s| BtpTranslation.new($1)}  
      # > ...
      p.gsub!(/^>(.+)$/){|s| BtpQuote.new($1)}
    end
    array
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
    super(string) {|s| "<blockquote><div class=\"char\">老高</div>#{s}
    </blockquote>"}
  end
end
class BtpDescription < BtpString
  def initialize(string)
    super(string) {|s| "<p class=\"description\">#{s}</p>"}
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
