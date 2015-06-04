require 'rails_helper'

module Magnetik
  RSpec.describe CreditCard, type: :model do
    describe 'associations' do
      it 'belongs to an customer' do
        @customer = create(:user)
        @credit_card = create(:credit_card, customer: @customer)

        expect(@customer.credit_cards).to include(@credit_card)
      end
    end

    describe 'validations' do
      it { should validate_presence_of(:customer) }
      it { should validate_presence_of(:stripe_card_id) }
      it { should validate_presence_of(:last_4_digits) }
      it { should validate_presence_of(:exp_month) }
      it { should validate_presence_of(:exp_year) }
      it { should validate_presence_of(:brand) }
      it { should validate_length_of(:name).is_at_most(Magnetik.max_name_length) }
    end
  end
end
