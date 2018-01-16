class User < ApplicationRecord
  # Enable password feature via bcrypt library (-> requires :password_digest attr on model class)
  # Injects method :authenticate(<PASSWD>) on user model, which returns model instance in case of success (false in case of wrong <PASSWD>)
  # see also https://robert-reiz.com/2014/04/12/has_secure_password-with-rails-4-1/
  has_secure_password

  validates :email,
    presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
    uniqueness: true
  validates :password, length: { minimum: 5 }, if: :password
end

