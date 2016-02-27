class Movie < ActiveRecord::Base

  def self.ratings
    #get unique ratings
    Movie.select(:rating).map{|movie| movie.rating}.uniq
  end

end
