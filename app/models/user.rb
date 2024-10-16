# frozen_string_literal: true

# User model
class User < ApplicationRecord
  has_secure_password
  has_one_attached :profile_image, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :broadcasts, dependent: :destroy
  validates :username, :email, :password_digest, presence: true
  validates :username, :email, uniqueness: true
  validates :password_digest, length: { minimum: 8, message: 'Must be at least 8 characters long.' }
  validate :password_validation
  validate :email_validation
  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }

  # Checks password validation
  def password_validation
    return if password_digest.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/)

    errors.add :password_digest,
               'must include at least one uppercase letter, one lowercase letter, one digit, one special character'
  end

  # Checks email validation
  def email_validation
    return if email.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)

    errors.add :email, 'is not in a valid format'
  end
end
