require 'rails_helper'

module Magnetik
  RSpec.describe DestroyCreditCard do
    describe '#perform' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before  { StripeMock.start }
      after   { StripeMock.stop }

      before :each do
        @stripe_customer = Stripe::Customer.create(email: 'customer@example.com')
        @stripe_card = @stripe_customer.sources.create(:source => stripe_helper.generate_card_token)

        @customer = create(:user, stripe_customer_id: @stripe_customer.id)
        @credit_card = create(:credit_card, customer: @customer, stripe_card_id: @stripe_card.id)
      end

      it 'fetches a remote customer' do
        expect(Stripe::Customer).to receive(:retrieve) { @stripe_customer }
        DestroyCreditCard.perform(@credit_card)
      end

      it 'fetches a remote card' do
        allow(Stripe::Customer).to receive(:retrieve) { @stripe_customer }
        expect(@stripe_customer.sources).to receive(:retrieve) { @stripe_card }
        DestroyCreditCard.perform(@credit_card)
      end

      it 'destroys the credit card' do
        expect {
          DestroyCreditCard.perform(@credit_card)
        }.to change(CreditCard, :count).by(-1)
      end

      it 'removes the credit card from stripe' do
        DestroyCreditCard.perform(@credit_card)
        stripe_customer = Stripe::Customer.retrieve(@customer.stripe_customer_id)

        expect {
          stripe_customer.sources.retrieve(@credit_card.stripe_card_id)
        }.to raise_error(Stripe::InvalidRequestError)
      end
    end
  end
end