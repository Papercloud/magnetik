require 'rails_helper'

describe 'a customer class' do
  before :each do
    @owner = User.create
  end

  it 'responds to :acts_as_magnetik_customer' do
    expect(@owner.class).to respond_to :acts_as_magnetik_customer
  end

  describe 'instance' do
    before :each do
      @customer = create(:customer, owner: @owner)
    end

    it 'has access to a magnetik customer instance' do
      expect(@owner.customer).to eq(@customer)
    end

    it 'has direct access to magnetik credit cards for their customer' do
      @credit_card = create(:credit_card, customer: @customer)
      expect(@owner.credit_cards).to include(@credit_card)
    end
  end
end
