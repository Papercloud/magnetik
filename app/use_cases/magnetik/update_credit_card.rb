module Magnetik
  class UpdateCreditCard
    include UseCase

    attr_reader :local_card

    def initialize(card, params)
      @card   = card
      @params = params
    end

    def perform
      if fetch_customer && fetch_card
        if update_remote_card
          update_local_card
        end
      end
    end

    private

    attr_reader :remote_customer, :remote_card

    def fetch_customer
      @remote_customer = Stripe::Customer.retrieve(@card.customer.stripe_customer_id)
    end

    def fetch_card
      @remote_card = @remote_customer.sources.retrieve(@card.stripe_card_id)
    end

    def update_remote_card
      remote_card.exp_month = @params[:exp_month]
      remote_card.exp_year  = @params[:exp_year]
      remote_card.save.tap do |success|
        errors.add(:base, "Credit card failed to save") unless success
      end
    rescue Stripe::CardError => e
      errors.add(:base, "Credit card failed to save")
    end

    def update_local_card
      @card.update_attributes(@params).tap do |success|
        errors.add(:base, "Credit card failed to save") unless success
      end
    end
  end
end