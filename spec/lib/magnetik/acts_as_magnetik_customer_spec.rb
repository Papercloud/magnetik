require 'rails_helper'

describe 'a customer class' do
  before :each do
    @customer = create(:user)
  end

  it 'responds to :acts_as_magnetik_customer' do
    expect(@customer.class).to respond_to :acts_as_magnetik_customer
  end

  describe 'instance' do
    before :each do
      @customer = create(:user)
    end

    it 'has access to magnetik credit cards collection' do
      @credit_card = create(:credit_card, customer: @customer)
      expect(@customer.credit_cards).to include(@credit_card)
    end
  end
end
