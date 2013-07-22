# Sample Source
# 正弦泻（正弦线）
# xiáng重（形状）
# 皮鼓皮（苹果皮）

require 'psych'

def words_to_yaml(string)
  words = []
  string.scan(/^.+（）$/)
end

class PinyinMark
  def initialize string
    @string = string
  end
  def to_s
    return "<span class='PinyinMark'>「#{super}」</span>"
  end
end

m = PinyinMark.new("pan")
puts m
