require 'rails_helper'

module Magnetik
  RSpec.describe Customer, type: :model do
    describe 'associations' do
      it 'belongs to an owner' do
        @user = create(:user)
        @customer = create(:customer, owner: @user)

        expect(@user.customer).to eq(@customer)
      end
    end

    describe 'validations' do
      before :each do
        @customer = build(:customer)
      end

      it 'cannot be created without a owner' do
        @customer.owner = nil

        expect(@customer).to_not be_valid
      end

      it 'cannot be created without a stripe id' do
        @customer.stripe_customer_id = nil

        expect(@customer).to_not be_valid
      end
    end
  end
end
