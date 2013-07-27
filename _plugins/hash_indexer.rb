def hash_index(array)
  hash = {}
  array.each_with_index do |q, i|
    hash[(yield i)] = q
  end   
  hash
end