class Movie < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc)}, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations
    
  has_attached_file :image, styles: {
    small: "90x133>",
    thumb: "50x50>"
  }

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  
  # validates :image_file_name, allow_blank: true, format: {
  #   with: /\w+\.(gif|jpg|png)\z/i,
  #   message: "must reference a GIF, JPG, or PNG image"
  # }
  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/png"] },
    size: { less_than: 1.megabyte }

  RATINGS = %w[G PG PG-13 R NC-17]
  validates :rating, inclusion: { in: RATINGS }

  scope :released, -> { where("released_on <= ?", Time.now).order(released_on: :desc) }
  # def self.released
  #   where("released_on <= ?", Time.now).order("released_on desc")
  # end
  
  scope :hits, -> { released.where('total_gross >= 300000000').order(total_gross: :desc) }
  # def self.hits
  #   where('total_gross >= 300000000').order('total_gross desc')
  # end

  scope :flops, -> { released.where('total_gross < 50000000').order(total_gross: :asc) }  
  # def self.flops
  #   where('total_gross < 10_000_000').order('total_gross asc')
  # end

  scope :upcoming, -> { where("released_on > ?", Time.now).order(released_on: :asc) }

  scope :rated, ->(rating) { released.where(rating: rating) }

  scope :recent, ->(max = 5) { released.limit(max) }
  
  scope :recently_added, ->(max = 3) { order(created_at: :desc).limit(max) }
  # def self.recently_added
  #   order('created_at desc').limit(3)
  # end

  scope :grossed_less_than, ->(amount) { released.where("total_gross < ?", amount) }

  scope :grossed_greater_than, ->(amount) { released.where("total_gross > ?", amount) }

  def self.cult_classics
    # Aggregation methods such as average when being applied to an empty collection will return a nil 
    # and that could not be compared to a numeric value.
    # An example of resulting error is "NoMethodError: undefined method `>=' for nil:NilClass".
    # The solution is to prefix that comparison with a checking on the size of the collection.     
    select { |movie| movie.reviews.count > 50 && movie.revews.average(:stars) >= 4.0 }
  end

  def cult_classic?
    #reviews.size > 50 && average_stars >= 4.0
    reviews.count > 50 && average_stars >= 4.0
  end
  
  def flop?
    #total_gross.blank? || total_gross < 50000000
    if cult_classic?
      false
    elsif total_gross.blank? || total_gross < 50000000
      true
    else
      false
    end
  end

  def average_stars
    reviews.average(:stars)
  end

  def recent_reviews
    #reviews.order(created_at: :desc).limit(2)
    # has_many :reviews has a 2nd parameter with sorting criteria
    reviews.limit(2)
  end
end
