module Magnetik
  class DestroyCreditCard
    include UseCase

    def initialize(card)
      @card       = card
    end

    def perform
      if fetch_customer && fetch_card
        if destroy_local_card
          destroy_remote_card
        end
      end
    end

    private

    attr_reader :remote_customer, :remote_card

    def fetch_customer
      @remote_customer = Stripe::Customer.retrieve(@card.customer.stripe_customer_id)
    end

    def fetch_card
      @remote_card = remote_customer.sources.retrieve(@card.stripe_card_id)
    end

    def destroy_local_card
      @card.destroy.tap do |success|
        errors.add(:base, "Credit card failed to delete") unless success
      end
    end

    def destroy_remote_card
      remote_card.delete.tap do |success|
        errors.add(:base, "Credit card failed to delete") unless success
      end
    end
  end
end