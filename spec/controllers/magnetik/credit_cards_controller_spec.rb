require 'rails_helper'

module Magnetik
  RSpec.describe CreditCardsController, type: :controller do
    routes { Magnetik::Engine.routes }

    let(:user) { create(:user) }

    before :each do
      allow(controller).to receive(:authenticate!) { true }
      allow(controller).to receive(:user) { user }
    end

    describe 'GET #index' do
      before :each do
        @credit_cards = create_list(:credit_card, 3, customer: user)
      end

      it 'returns http success' do
        get :index, format: :json
        expect(response).to have_http_status(:success)
      end

      it 'assigns a collection of credit cards for the current user' do
        get :index, format: :json
        expect(assigns(:credit_cards)).to match_array(@credit_cards)
      end
    end

    describe 'POST #create' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before { StripeMock.start }
      after  { StripeMock.stop }

      before :each do
        @card_token = StripeMock.generate_card_token(last4: '9191', exp_year: 2020, exp_month: 1)
      end

      context 'successful request' do
        it 'returns http success' do
          post :create, format: :json, credit_card: { token: @card_token }
          expect(response).to have_http_status(:ok)
        end

        it 'returns the credit card object' do
          post :create, format: :json, credit_card: { token: @card_token }
          expect(json[:credit_card][:id]).not_to be_nil
        end
      end

      context 'unsuccessful request' do
        before :each do
          StripeMock.prepare_card_error(:card_declined, :create_source)
        end

        it 'returns http unprocessable if theres an error' do
          post :create, format: :json, credit_card: { token: @card_token }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the errors from the use case if theres an error' do
          post :create, format: :json, credit_card: { token: @card_token }
          expect(json[:errors]).not_to be_nil
        end
      end
    end

    describe 'PUT update' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before { StripeMock.start }
      after  { StripeMock.stop }

      before :each do
        customer = Stripe::Customer.create(email: 'customer@example.com')
        card = customer.sources.create(:source => stripe_helper.generate_card_token)

        @customer = create(:user, stripe_customer_id: customer.id)
        @credit_card = create(:credit_card, customer: @customer, stripe_card_id: card.id)

        @update_params = {
          exp_month: '12',
          exp_year: '2018',
        }
      end

      it 'returns a 200 status' do
        put :update, format: :json, id: @credit_card.id, credit_card: @update_params

        expect(response.status).to eq 200
      end

      it 'returns the updated credit card object' do
        put :update, format: :json, id: @credit_card.id, credit_card: @update_params

        expect(json[:credit_card][:id]).to eq @credit_card.id
        expect(json[:credit_card][:exp_year]).to eq '2018'
        expect(json[:credit_card][:exp_month]).to eq '12'
      end

      it 'should fail to update with invalid details' do
        StripeMock.prepare_card_error(:card_declined, :update_source)

        put :update, format: :json, id: @credit_card.id, credit_card: @update_params

        expect(response.status).to eq 422
      end
    end

    describe 'DELETE destroy' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      before { StripeMock.start }
      after  { StripeMock.stop }

      before :each do
        customer = Stripe::Customer.create(email: 'customer@example.com')
        card = customer.sources.create(:source => stripe_helper.generate_card_token)

        @customer = create(:user, stripe_customer_id: customer.id)
        @credit_card = create(:credit_card, customer: @customer, stripe_card_id: card.id)
      end

      it 'returns a 204 status' do
        delete :destroy, format: :json, id: @credit_card.id
        expect(response.status).to eq 204
      end
    end
  end
end
