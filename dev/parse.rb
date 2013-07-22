han = []
Dir['*.txt'].each do |f|
  han[0,0] = File.read(f).scan(/\p{han}/)
end
#han.uniq!
puts han.uniq!.count