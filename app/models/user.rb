class User < ActiveRecord::Base
  before_save :format_username
  before_save :format_email

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true

  validates :username, presence: true,
                       format: { with: /\A[A-Z0-9]+\z/i, allow_blank: true },
                       uniqueness: { case_sensitive: false } 

  validates :email, presence: true,
                    #format: { with: /\A\S+@\S+\z/ },
                    #format: { with: EmailValidator.regexp(strict_mode: true), allow_blank: true },
                    #email: true,
                    email: { strict_mode: true, allow_blank: true },
                    uniqueness: { case_sensitive: false }

  has_secure_password validations: true                       

  # A password isn't required when a user updates his name and/or email.
  # So if the password field is left blank when editing the user account, 
  # the length validation is skipped.
  validates :password, length: { minimum: 10, allow_blank: true }

  #scope :by_name, -> { order(name: :asc) }
  # OR
  scope :by_name, -> { order(:name) }

  scope :not_admins, -> { where(admin: false).by_name }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def self.authenticate(email_or_username, password)
    # find_by is case sensitive
    #user = User.find_by(email: email_or_username) || User.find_by(username: email_or_username)
    # Make the search case insensitive
    user = User.where("lower(email) = ?", email_or_username.downcase).first || 
           User.where("lower(username) = ?", email_or_username.downcase).first
    user && user.authenticate(password)
  end

  def to_param
    username
  end

  private

    def format_username
      self.username = username.downcase
    end

    def format_email
      self.email = email.downcase
    end
end
