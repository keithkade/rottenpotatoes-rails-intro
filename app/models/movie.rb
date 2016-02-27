class Movie < ActiveRecord::Base

  #get unique ratings as Arr
  def self.ratingsArr
    Movie.select(:rating).map{|movie| movie.rating}.uniq
  end

  #get unique ratings as Hash
  def self.ratingsHash
    hash = {}
    Movie.select(:rating).map{|movie| movie.rating}.uniq.each do |r|
      hash[r] = 1
    end
    return hash
  end
end
