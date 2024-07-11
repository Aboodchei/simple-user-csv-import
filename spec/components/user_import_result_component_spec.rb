# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserImportResultComponent, type: :component do
  include ViewComponent::TestHelpers
  let(:user_import_result) do
    OpenStruct.new(
      status: ImportStatus::PARTIAL_SUCCESS,
      description: "User import completed with some errors",
      results: []
    )
  end

  subject { render_inline(described_class.new(user_import_result: user_import_result)) }

  it 'renders the status and description' do
    expect(subject.text).to include(user_import_result.status)
    expect(subject.text).to include("User import completed with some errors")
  end
end
