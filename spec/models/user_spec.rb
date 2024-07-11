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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(name: "Test User", password: password) }

  context "validations" do
    describe "password validation" do
      context "when password is strong" do
        let(:password) { "Aqpfk1swods" }

        it "is valid" do
          expect(subject).to be_valid
        end
      end

      context "when password is too short" do
        let(:password) { "Abc123" }

        it "is invalid" do
          expect(subject).to be_invalid
          expect(subject.errors[:password]).to eq([ "must be between 10 and 16 characters long" ])
        end
      end

      context "when password is too long" do
        let(:password) { "Abc123" * 2 }

        it "is invalid" do
          expect(subject).to be_invalid
          expect(subject.errors[:password]).to eq([ "must be between 10 and 16 characters long" ])
        end
      end

      context "when password does not contain an uppercase character" do
        let(:password) { "abcdefgh123" }

        it "is invalid" do
          expect(subject).to be_invalid
          expect(subject.errors[:password]).to eq([ "must contain at least one uppercase character" ])
        end
      end

      context "when password does not contain a lowercase character" do
        let(:password) { "ABCDEFGH123" }

        it "is invalid" do
          expect(subject).to be_invalid
          expect(subject.errors[:password]).to eq([ "must contain at least one lowercase character" ])
        end
      end

      context "when password does not contain a digit" do
        let(:password) { "Abcdefghij" }

        it "is invalid" do
          expect(subject).to be_invalid
          expect(subject.errors[:password]).to eq([ "must contain at least one digit" ])
        end
      end

      context "when password contains three repeating characters in a row" do
        let(:password) { "AAAfk1swods" }

        it "is invalid" do
          expect(subject).to be_invalid
          expect(subject.errors[:password]).to eq([ "cannot contain three repeating characters in a row" ])
        end
      end

      context "when password does not match any criteria" do
        let(:password) { "???" }

        it "is invalid" do
          expect(subject).to be_invalid
          expect(subject.errors[:password]).to eq([
            "must be between 10 and 16 characters long",
            "must contain at least one uppercase character",
            "must contain at least one lowercase character",
            "must contain at least one digit",
            "cannot contain three repeating characters in a row"
          ])
        end
      end
    end
  end
end
