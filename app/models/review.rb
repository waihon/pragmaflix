class Review < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user

  #validates :name, presence: true
  validates :location, presence: true

  STARS = [1, 2, 3, 4, 5]
  validates :stars, inclusion: { 
    in: STARS,
    message: "must be between 1 and 5"
  }

  validates :comment, length: { minimum: 4 }

  scope :past_n_days, ->(n) { where("created_at >= ?", n.days.ago) }
end
