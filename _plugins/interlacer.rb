def interlace_arrays (first, second)
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
