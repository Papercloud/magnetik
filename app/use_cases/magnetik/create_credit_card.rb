module Magnetik
  class CreateCreditCard
    include UseCase

    attr_reader :local_card

    def initialize(actor, token, card_params = {})
      @token  = token
      @actor  = actor
      @card_params = card_params
      @remote_customer = nil
    end

    def perform
      if @actor.has_stripe_customer?
        fetch_customer
      else
        create_remote_customer
        create_local_customer
      end

      if @remote_customer && create_remote_card
        create_local_card
      end
    end

    private

    attr_reader :remote_customer, :remote_card, :card_params

    def fetch_customer
      @remote_customer = Stripe::Customer.retrieve(@actor.stripe_customer_id)
    end

    def create_remote_customer
      @remote_customer = Stripe::Customer.create({
        email: @actor.try(:email),
        description: @actor.try(:stripe_description)
      })
    end

    def create_local_customer
      @actor.update_attributes(stripe_customer_id: remote_customer.id).tap do |success|
        errors.add(:base, "User failed to save") unless success
      end
    end

    def create_remote_card
      @remote_card = remote_customer.sources.create(source: @token)
    rescue Stripe::CardError => e
      errors.add(:base, "Credit card failed to save")
      return false
    end

    def create_local_card
      @local_card = CreditCard.new(card_params.merge({
        customer: @actor,
        stripe_card_id: remote_card[:id],
        last_4_digits: remote_card[:last4],
        exp_month: remote_card[:exp_month],
        exp_year: remote_card[:exp_year],
        brand: remote_card[:brand]
      }))

      @local_card.save.tap do |success|
        errors.add(:base, "Credit card failed to save") unless success
      end
    end

  end
end