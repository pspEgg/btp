def stream_hash(key, html, type)
  {"url" => key, "html" => html, "type" => type}
end

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

  # Make Enumerator
  insertions = more.each
  interlaced = []
  less.each_with_index do |(key, html), index|
    interlaced.push stream_hash(key, html, 1)
    min_insertion.times do
      p = insertions.next
      interlaced.push stream_hash(p[0], p[1], 2)
    end
    # Adding Left Overs
    if pts.include? index
      p = insertions.next
      interlaced.push stream_hash(p[0], p[1], 2)
    end
  end
  interlaced
end
