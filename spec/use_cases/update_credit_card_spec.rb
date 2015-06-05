require 'rails_helper'

module Magnetik
  RSpec.describe UpdateCreditCard do
    describe '#perform' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before  { StripeMock.start }
      after   { StripeMock.stop }

      before :each do
        @stripe_customer = Stripe::Customer.create(email: 'customer@example.com')
        @stripe_card = @stripe_customer.sources.create(:source => stripe_helper.generate_card_token)

        @customer = create(:user, stripe_customer_id: @stripe_customer.id)
        @credit_card = create(:credit_card, customer: @customer, stripe_card_id: @stripe_card.id, exp_month: "1", exp_year: "2016")

        @update_params = {
          exp_month: '12',
          exp_year: '2020',
          name: 'My updated card'
        }
      end

      it 'fetches a remote customer' do
        expect(Stripe::Customer).to receive(:retrieve) { @stripe_customer }
        UpdateCreditCard.perform(@credit_card, @update_params)
      end

      it 'fetches a remote card' do
        allow(Stripe::Customer).to receive(:retrieve) { @stripe_customer }
        expect(@stripe_customer.sources).to receive(:retrieve) { @stripe_card }
        UpdateCreditCard.perform(@credit_card, @update_params)
      end

      it 'updates the stripe card' do
        UpdateCreditCard.perform(@credit_card, @update_params)

        stripe_customer = Stripe::Customer.retrieve(@customer.stripe_customer_id)
        stripe_card = stripe_customer.sources.retrieve(@credit_card.stripe_card_id)

        expect(stripe_card[:exp_month]).to eq @update_params[:exp_month]
        expect(stripe_card[:exp_year]).to eq @update_params[:exp_year]
      end

      it 'updates the local credit cards month' do
        expect do
          UpdateCreditCard.perform(@credit_card, @update_params)
        end.to change(@credit_card, :exp_month).to('12')
      end

      it 'updates the local credit cards year' do
        expect do
          UpdateCreditCard.perform(@credit_card, @update_params)
        end.to change(@credit_card, :exp_year).to('2020')
      end

      it 'updates the local credit cards name' do
        expect do
          UpdateCreditCard.perform(@credit_card, @update_params)
        end.to change(@credit_card, :name).to('My updated card')
      end
    end
  end
end