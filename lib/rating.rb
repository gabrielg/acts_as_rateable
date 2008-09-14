class Rating < ActiveRecord::Base
  belongs_to :rateable, :polymorphic => true
  validates_presence_of :score
  validates_uniqueness_of :user_id, :scope => [:rateable_id, :rateable_type]
  validate :max_rating_allowed_by_parent
  delegate :max_rating, :to => :rateable
  
private
  
  def max_rating_allowed_by_parent
    if score < 1
      errors.add(:score, "must be greater than or equal to 1")
    elsif score > max_rating
      errors.add(:score, "must be less than or equal to #{max_rating}")
    end
  end

end
