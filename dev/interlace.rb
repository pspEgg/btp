require_relative '../_plugins/syntax_parse.rb'

source = '/Users/egg/Dropbox/dev/btp/'

quotes_text = File.read(File.join(source, 'btp_quotes_dev.txt'))
parser = BtpParser.new
quotes_array = parser.parse(quotes_text)

words_text = File.read(File.join(source, 'btp_words.txt'))
parser = BtpWordsParser.new
words_array = parser.parse(words_text)

def interlace(first, second)
  f = first.count
  s = second.count
  if f > s then more, less = first, second
  else          less, more = first, second
  end
  min_insertion = more.count / less.count
  # Randomized Insertion points for Left_over
  left_over = more.count % less.count
  pts = []
  left_over.times do 
    index = rand(less.count)
    if pts.include? index
      redo
    else
      pts.push index
    end
  end

  insertions = more.map
  interlaced = []
  less.each_with_index do |l, index|
    interlaced.push l
    min_insertion.times do
      interlaced.push(insertions.next)
    end
    # Adding Left Overs
    interlaced.push(insertions.next) if pts.include? index
  end
  interlaced
end

interlaced = interlace(quotes_array, words_array)
puts quotes_array.count
puts words_array.count 
puts
puts interlaced.count