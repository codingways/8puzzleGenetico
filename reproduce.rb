def reproduce(a,b)
  #[8, 1, 5, 0, 2, 6, 7, 3, 4]
  rep_size = rand(a.size) + 1
  rep_size -= 1 if rep_size == 4
  rep = Array.new(a)
  rep_size.times do |i|
    rep[i] = b[i]
  end
  rep
end

puts reproduce([0,1,2,3],[4,5,6,7]).inspect
