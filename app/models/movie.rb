class Movie < ActiveRecord::Base

def Movie.with_ratings(input_ratings)
    Movie.where(rating: input_ratings)
end
       
end
