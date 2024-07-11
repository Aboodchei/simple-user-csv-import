# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validate :strong_password

  private

  def strong_password
    unless password&.length&.between?(10, 16)
      errors.add(:password, "must be between 10 and 16 characters long")
    end

    unless password =~ /[a-z]/
      errors.add(:password, "must contain at least one lowercase character")
    end

    unless password =~ /[A-Z]/
      errors.add(:password, "must contain at least one uppercase character")
    end

    unless password =~ /\d/
      errors.add(:password, "must contain at least one digit")
    end

    if password =~ /(.)\1{2,}/
      errors.add(:password, "cannot contain three repeating characters in a row")
    end
  end
end
