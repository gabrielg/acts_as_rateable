class Rating < ActiveRecord::Base
  belongs_to :rateable, :polymorphic => true
  validates_presence_of :score
  validates_numericality_of :score, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5
  
  validates_uniqueness_of :user_id, :scope => [:rateable_id, :rateable_type]
end
