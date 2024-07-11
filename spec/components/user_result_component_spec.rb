# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserResultComponent, type: :component do
  include ViewComponent::TestHelpers
  let(:user_result) do
    OpenStruct.new(
      name: "John Doe",
      password: "secret123",
      row: 1,
      status: status,
      description: "Import successful",
      errors: errors
    )
  end

  subject { render_inline(described_class.new(user_result: user_result)) }

  context 'when the status is success' do
    let(:status) { ImportStatus::SUCCESS }
    let(:errors) { [] }

    it 'renders with a success border' do
      expect(subject.css('.card.border-success')).to be_present
    end

    it 'does not render errors' do
      expect(subject.css('.text-danger')).to be_empty
    end

    it 'renders the user name and row' do
      expect(subject.text).to include("John Doe (Row 1)")
    end

    it 'renders the password' do
      expect(subject.text).to include("Password: secret123")
    end

    it 'renders the status and description' do
      expect(subject.text).to include("#{status}: Import successful")
    end
  end

  context 'when the status is not success' do
    let(:status) { ImportStatus::FAILURE }
    let(:errors) { [ "Invalid email format", "Password too short" ] }

    it 'renders with a danger border' do
      expect(subject.css('.card.border-danger')).to be_present
    end

    it 'renders errors' do
      expect(subject.css('.text-danger').text).to include("Invalid email format")
      expect(subject.css('.text-danger').text).to include("Password too short")
    end

    it 'renders the user name and row' do
      expect(subject.text).to include("John Doe (Row 1)")
    end

    it 'renders the password' do
      expect(subject.text).to include("Password: secret123")
    end

    it 'renders the status and description' do
      expect(subject.text).to include("#{status}: Import successful")
    end
  end
end
