module Magnetik
  class CreateCreditCard
    include UseCase

    def initialize(user, token)
      @token    = token
      @user     = user
      @remote_customer = nil
    end

    def perform
      if @user.customer.nil?
        create_remote_customer
        create_local_customer
      else
        fetch_customer
      end

      if @remote_customer && create_remote_card
        create_local_card
      end
    end

    private

    attr_reader :remote_customer, :local_customer, :remote_card, :local_card

    def fetch_customer
      @remote_customer = Stripe::Customer.retrieve(@user.customer.stripe_customer_id)
    end

    def create_remote_customer
      @remote_customer = Stripe::Customer.create({
        description: "Stuff"
      })
    end

    def create_local_customer
      @local_customer = Customer.new(stripe_customer_id: remote_customer.id, owner: @user)
      @local_customer.save.tap do |success|
        errors.add(:base, "Customer failed to save") unless success
      end
    end

    def create_remote_card
      @remote_card = remote_customer.sources.create(source: @token)
    end

    def create_local_card
      @local_card = CreditCard.new({
        customer: local_customer,
        stripe_card_id: remote_card[:id],
        last_4_digits: remote_card[:last4],
        exp_month: remote_card[:exp_month],
        exp_year: remote_card[:exp_year],
        brand: remote_card[:brand]
      })

      @local_card.save.tap do |success|
        errors.add(:base, "Credit card failed to save") unless success
      end
    end

  end
end