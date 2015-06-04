require 'rails_helper'

module Magnetik
  RSpec.describe CreateCreditCard do
    describe '#perform' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before  { StripeMock.start }
      after   { StripeMock.stop }

      before :each do
        @card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 2020, exp_month: 1)
        @user = create(:user)
        @card_params = { name: 'My Card' }
      end

      context 'user has a customer' do
        before :each do
          @customer = Stripe::Customer.create
          @user.update(stripe_customer_id: @customer.id)
        end

        it 'fetches a remote customer' do
          expect(Stripe::Customer).to receive(:retrieve) { @customer }
          CreateCreditCard.perform(@user, @card_token, @card_params)
        end

        it 'doesnt create a remote customer' do
          expect(Stripe::Customer).not_to receive(:create)
          CreateCreditCard.perform(@user, @card_token, @card_params)
        end

        it 'doesnt create a local customer' do
          expect {
            CreateCreditCard.perform(@user, @card_token, @card_params)
          }.to_not change(@user, :stripe_customer_id)
        end

        it 'creates a remote credit card' do
          @card = @customer.sources.create(:source => @card_token)

          expect(Stripe::Customer).to receive(:retrieve) { @customer }
          expect(@customer.sources).to receive(:create) { @card }

          CreateCreditCard.perform(@user, @card_token, @card_params)
        end
      end

      context 'user has no customer' do
        it 'creates a remote customer' do
          @customer = Stripe::Customer.create

          expect(Stripe::Customer).to receive(:create).with(hash_including({
            email: @user.email
          })) { @customer }
          CreateCreditCard.perform(@user, @card_token, @card_params)
        end

        it 'creates a remote customer with a nil email if the model doesnt have one' do
          @new_user = create(:customer)
          @customer = Stripe::Customer.create

          expect(Stripe::Customer).to receive(:create).with(hash_including({
            email: nil
          })) { @customer }
          CreateCreditCard.perform(@new_user, @card_token, @card_params)
        end

        it 'includes a customer description if the actor defines it' do
          @customer = Stripe::Customer.create

          expect(Stripe::Customer).to receive(:create).with(hash_including({
            description: 'Magnetik Customer'
          })) { @customer }
          CreateCreditCard.perform(@user, @card_token, @card_params)
        end

        it 'includes a nil description if the actor hasnt defined one' do
          @new_user = create(:customer)
          @customer = Stripe::Customer.create

          expect(Stripe::Customer).to receive(:create).with(hash_including({
            description: nil
          })) { @customer }
          CreateCreditCard.perform(@new_user, @card_token, @card_params)
        end

        it 'creates a local customer' do
          expect {
            CreateCreditCard.perform(@user, @card_token, @card_params)
          }.to change(@user, :stripe_customer_id)
        end

        it 'creates a remote credit card' do
          @customer = Stripe::Customer.create
          @card = @customer.sources.create(:source => @card_token)

          expect(Stripe::Customer).to receive(:create) { @customer }
          expect(@customer.sources).to receive(:create) { @card }
          CreateCreditCard.perform(@user, @card_token, @card_params)
        end
      end

      it 'creates a local credit card' do
        expect {
          CreateCreditCard.perform(@user, @card_token, @card_params)
        }.to change(CreditCard, :count).by(1)
      end

      it 'merges in the card params whe creating the local card' do
        @local_card = CreateCreditCard.perform(@user, @card_token, @card_params).local_card

        expect(@local_card.name).to eq('My Card')
      end
    end
  end
end