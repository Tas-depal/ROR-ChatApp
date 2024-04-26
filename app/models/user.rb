class User < ApplicationRecord
  has_secure_password
  has_many :messages, dependent: :destroy
  validates :username, :email, :password_digest, presence: true
  validates :username, :email, uniqueness: true
  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit {broadcast_append_to "users"} 
end
