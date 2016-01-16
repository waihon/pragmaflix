class User < ActiveRecord::Base
  has_secure_password validations: true

  validates :name, presence: true
  validates :email, presence: true,
                    #format: { with: /\A\S+@\S+\z/ },
                    email: true,
                    uniqueness: { case_sensitive: false }
  # A password isn't required when a user updates his name and/or email.
  # So if the password field is left blank when editing the user account, 
  # the length validation is skipped.
  validates :password, length: { minimum: 10, allow_blank: true }
end
