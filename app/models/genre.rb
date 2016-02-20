class Genre < ActiveRecord::Base
  before_validation :generate_slug

  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations
  
  validates :name, presence: true, 
                   uniqueness: { case_sensitive: false }

  def to_param
    slug
  end

  def generate_slug
    self.slug ||= name.parameterize if name?
  end
    
end
