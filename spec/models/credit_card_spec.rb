require 'rails_helper'

module Magnetik
  RSpec.describe CreditCard, type: :model do
    describe 'associations' do
      it 'belongs to an customer' do
        @customer = create(:customer)
        @credit_card = create(:credit_card, customer: @customer)

        expect(@customer.credit_cards).to include(@credit_card)
      end
    end

    describe 'validations' do
      before :each do
        @credit_card = build(:credit_card)
      end

      it 'cannot be created without a customer' do
        @credit_card.customer = nil

        expect(@credit_card).to_not be_valid
      end

      it 'cannot be created without a stripe id' do
        @credit_card.stripe_card_id = nil

        expect(@credit_card).to_not be_valid
      end

      it 'cannot be created without the last 4 digits of the card number' do
        @credit_card.last_4_digits = nil

        expect(@credit_card).to_not be_valid
      end

      it 'cannot be created without the expiry month' do
        @credit_card.exp_month = nil

        expect(@credit_card).to_not be_valid
      end

      it 'cannot be created without the expiry year' do
        @credit_card.exp_year = nil

        expect(@credit_card).to_not be_valid
      end

      it 'cannot be created without the brand' do
        @credit_card.brand = nil

        expect(@credit_card).to_not be_valid
      end
    end
  end
end
