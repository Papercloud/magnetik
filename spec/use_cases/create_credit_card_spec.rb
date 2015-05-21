require 'rails_helper'

module Magnetik
  RSpec.describe CreateCreditCard do
    describe '#perform' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before  { StripeMock.start }
      after   { StripeMock.stop }

      context 'user has a customer' do
        before :each do
          @customer = Stripe::Customer.create
          @user = create(:user, customer: create(:customer, stripe_customer_id: @customer.id))
          @card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 2020, exp_month: 1)
        end

        it 'fetches a remote customer' do
          expect(Stripe::Customer).to receive(:retrieve) { @customer }
          CreateCreditCard.perform(@user, @card_token)
        end

        it 'doesnt create a remote customer' do
          expect(Stripe::Customer).not_to receive(:create)
          CreateCreditCard.perform(@user, @card_token)
        end

        it 'doesnt creates a local customer' do
          expect {
            CreateCreditCard.perform(@user, @card_token)
          }.to_not change(Customer, :count)
        end

        it 'creates a remote credit card' do
          @card = @customer.sources.create(:source => @card_token)

          expect(Stripe::Customer).to receive(:create) { @customer }
          expect(@customer.sources).to receive(:create) { @card }

          CreateCreditCard.perform(@user, @card_token)
        end

        it 'creates a local credit card' do
          expect {
            CreateCreditCard.perform(@user, @card_token)
          }.to change(CreditCard, :count).by(1)
        end
      end

      context 'user has no customer' do
        it 'creates a remote customer' do
          @user = create(:user)
          @customer = Stripe::Customer.create
          @card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 2020, exp_month: 1)

          expect(Stripe::Customer).to receive(:create) { @customer }
          CreateCreditCard.perform(@user, @card_token)
        end

        it 'creates a local customer' do
          @user = create(:user)
          @card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 2020, exp_month: 1)

          expect {
            CreateCreditCard.perform(@user, @card_token)
          }.to change(Customer, :count).by(1)
        end

        it 'creates a remote credit card' do
          @user = create(:user)
          @customer = Stripe::Customer.create
          @card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 2020, exp_month: 1)
          @card = @customer.sources.create(:source => @card_token)

          expect(Stripe::Customer).to receive(:create) { @customer }
          expect(@customer.sources).to receive(:create) { @card }
          CreateCreditCard.perform(@user, @card_token)
        end

        it 'creates a local credit card' do
          @user = create(:user)
          @card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 2020, exp_month: 1)

          expect {
            CreateCreditCard.perform(@user, @card_token)
          }.to change(CreditCard, :count).by(1)
        end
      end
    end
  end
end