class Movie < ActiveRecord::Base
    enum listof_ratings: [:"G",:"PG",:"PG-13",:"R",:"NC-17"]
    
    def self.with_ratings(ratings)
        if ratings == nil
            return listof_ratings.keys
        end
        return ratings.keys
    end
end
