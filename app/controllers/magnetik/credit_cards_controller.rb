require_dependency "magnetik/application_controller"

module Magnetik
  class CreditCardsController < ApplicationController
    before_filter :authenticate!

    respond_to :json

    def index
      render json: { credit_cards: collection }
    end

    def create
      token = create_params[:token]
      card_params = create_params.except(:token)
      @use_case = CreateCreditCard.perform(customer, token, card_params)

      if @use_case.success?
        render json: { credit_card: @use_case.local_card }, status: :ok
      else
        render json: { errors: @use_case.errors }, status: :unprocessable_entity
      end
    end

    def update
      @credit_card = CreditCard.find(params[:id])
      @use_case = UpdateCreditCard.perform(@credit_card, update_params)

      if @use_case.success?
        render json: { credit_card: @credit_card }, status: :ok
      else
        render json: { errors: @use_case.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      @credit_card = CreditCard.find(params[:id])
      @use_case = DestroyCreditCard.perform(@credit_card)

      if @use_case.success?
        render nothing: true, status: :no_content
      else
        render json: { errors: @use_case.errors }, status: :unprocessable_entity
      end
    end

    private

    def authenticate!
      method(Magnetik.authentication_method).call
    end

    def user
      @user ||= method(Magnetik.current_user_method).call
    end

    def customer
      @customer ||= user
    end

    def collection
      @credit_cards ||= customer.credit_cards.limit(30)
    end

    def create_params
      params.require(:credit_card).permit(
        :token,
        :name
      )
    end

    def update_params
      params.require(:credit_card).permit(
        :name,
        :exp_month,
        :exp_year,
        :is_default
      )
    end
  end
end
