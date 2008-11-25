require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    @user = create_user
    @product = create_product
    create_complete_order(@user, @product)
    create_s3_object_for_product(@product, {:title => 's3 test one'})
    create_s3_object_for_product(@product, {:title => 's3 test two'})
  end
  
  it "should create a user" do
    @user.should_not be_nil
  end
  
  it "should create a product" do
    @product.should_not be_nil
    @product.variants.should_not be_empty
  end
  
  it 'should have an order' do
    @user.orders.size.should eql(1)
  end
  
  it "should respond to completed_orders" do
    @user.orders.completed.should_not be_nil
  end
  
  it "should have some matching products" do
    @user.purchased_products.should_not be_nil
  end
  
  it "should have s3 products" do
    @user.s3_products.size.should eql(1)
  end
end

