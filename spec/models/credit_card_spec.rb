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

    describe '#requires_revalidation?' do
      before do
        @credit_card = create(:credit_card)
      end

      after do
        Magnetik.validation_interval = 3.months
      end

      context 'with interval set' do
        before do
          Magnetik.validation_interval = 3.months
        end

        it 'returns false if the credit cards last validation is within the interval' do
          @credit_card.last_validated_at = 2.months.ago

          expect(@credit_card.requires_revalidation?).to eq false
        end

        it 'returns true if the credit cards last validation is outside the interval' do
          @credit_card.last_validated_at = 4.months.ago

          expect(@credit_card.requires_revalidation?).to eq true
        end
      end

      context 'without interval set' do
        before do
          Magnetik.validation_interval = nil
        end

        it 'returns false' do
          expect(@credit_card.requires_revalidation?).to eq false
        end
      end
    end
  end
end
