module ActiveRecord
  module Acts
    module Rateable
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_rateable(options = {})
          has_many :ratings, :as => :rateable, :dependent => :destroy
          unless respond_to?(:max_rating)
            class_inheritable_accessor :max_rating
            attr_protected :max_rating
            self.max_rating = options[:max_rating] || 5
          end
          include ActiveRecord::Acts::Rateable::InstanceMethods
        end
      end
            
      module InstanceMethods
        # Rates the object by a given score. A user id should be passed to the method.
        def rate_it(score, user_id)
          returning(ratings.find_or_initialize_by_user_id(user_id)) do |rating|
            rating.update_attributes!(:score => score)
          end
        end
        
        # Calculates the average rating. Calculation based on the already given scores.
        def average_rating
          avg = ratings.average(:score)
          avg || 0.0
        end

        # Rounds the average rating value.
        def average_rating_round
          average_rating.round
        end
    
        # Returns the average rating in percent.
        def average_rating_percent
          f = 100 / max_rating.to_f
          average_rating * f
        end
        
        # Checks whether a user rated the object or not.
        def rated_by?(user_id)
          ratings.exists?(:user_id => user_id)
        end

        # Returns the rating a specific user has given the object.
        def rating_by(user_id)
          rating = ratings.find_by_user_id(user_id)
          rating ? rating.score : nil
        end

      end
      
    end
  end
end
