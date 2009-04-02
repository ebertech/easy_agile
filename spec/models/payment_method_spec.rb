require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaymentMethod do
  before(:each) do
    ActiveMerchant::Billing::Base.mode = :test

    @valid_attributes = {
      :last_four_digits => 1,
      :expiry_month => 1,
      :expiry_year => 1
    }
  end

  it "should create a new instance given valid attributes" do
    PaymentMethod.create!(@valid_attributes)
  end

  describe "associations" do
    it "should belong to a billing address" do
      PaymentMethod.should belong_to(:billing_address)
    end

    it "should belong to a user" do
      PaymentMethod.should belong_to(:user)
    end

    it "should have one organisation" do
      PaymentMethod.should belong_to(:organisation)
    end
  end

  describe "creation" do
    before :each do
      @payment_method = PaymentMethods.create_payment_method!(
        :card_number => 1111222233334444
      )
      @payment_method.save
    end

    it "should set the last four digits" do
      @payment_method.last_four_digits.should == 4444
    end
  end

  describe "card types" do
    it "should return visa and mastercard" do
      PaymentMethod::CARD_TYPES.should == ['mastercard', 'visa']
    end
  end

  describe "credit_card" do
    before :each do
      @payment_method = PaymentMethods.create_payment_method!(
        :cardholder_name => 'Joe Bloggs'
      )
      @credit_card = @payment_method.credit_card
    end

    it "should return a credit card object" do
      @credit_card.should be_kind_of(ActiveMerchant::Billing::CreditCard)
    end

    it "should set the number" do
      @credit_card.number.should == @payment_method.card_number
    end

    it "should set the month" do
      @credit_card.month.should == @payment_method.expiry_month
    end

    it "should set the year" do
      @credit_card.year.should == @payment_method.expiry_year
    end

    it "should set the cv2" do
      @credit_card.verification_value.should == @payment_method.cv2
    end

    it "should set the first name" do
      @credit_card.first_name.should == "Joe"
    end

    it "should set the last name" do
      @credit_card.last_name.should == "Bloggs"
    end

    it "should set the card type" do
      @credit_card.type.should == "visa"
    end

    it "should be valid" do
      @credit_card.should be_valid
    end
  end
end