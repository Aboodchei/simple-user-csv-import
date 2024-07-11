# frozen_string_literal: true

class UserImportResultComponent < ViewComponent::Base
  def initialize(user_import_result:)
    @user_import_result = user_import_result
  end
end
