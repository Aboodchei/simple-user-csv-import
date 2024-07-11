# frozen_string_literal: true

class UserResultComponent < ViewComponent::Base
  def initialize(user_result:)
    @user_result = user_result
  end
end
