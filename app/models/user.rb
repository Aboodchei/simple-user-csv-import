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
  validates :password, presence: true, length: { in: 10..16 }
  validate :strong_password

  private

  def strong_password
    # TODO
    # It contains at least one lowercase character, one uppercase character and one digit.
    # It cannot contain three repeating characters in a row (e.g. "...zzz..." is not strong, but "...zz...z..." is strong, assuming other conditions are met).
    # For example, the following passwords are "strong":
    # Aqpfk1swods
    # QPFJWz1343439
    # PFSHH78KSMa
    # And the following passwords are not "strong":
    # Abc123 (this is too short)
    # abcdefghijklmnop (this does not contain an uppercase character or a digit)
    # AAAfk1swods (this contains three repeating characters, namely AAA)
  end
end
