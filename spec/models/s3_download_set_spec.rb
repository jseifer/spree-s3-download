require File.dirname(__FILE__) + '/../spec_helper'

describe S3DownloadSet do
  before(:all) do
    s3_interface = mock("s3")
    s3_interface.mock!(:get_link, :return => 'http://test.url')
    RightAws::S3Interface.mock!(:new, :return => s3_interface)
  end
  
  describe "downloading an individual file" do
    before(:each) do
      create_user_and_product_and_order
      @want_download = @product.s3_products.first
      @s3_download_set = S3DownloadSet.new(:user => @user, :product => @product, :id => @want_download)
    end

    it "should be valid" do
      @s3_download_set.should be_valid
    end

    it "should have s3 products" do
      @s3_download_set.s3_objects.size.should == 1
    end
  end

  describe "creating a bulk download set" do
    before(:each) do
      create_user_and_product_and_order
      @want_download = @product.s3_products.first
      @s3_download_set = S3DownloadSet.new(:user => @user, :product => @product, :url_generation => 'bulk')
    end
    
    it 'should be valid' do
      @s3_download_set.should be_valid
    end
    
    it 'should have s3 products' do
      @s3_download_set.s3_objects.size.should be >= 1
    end
    
    it 'should have a temporary url on the products' do
      @s3_download_set.s3_objects.first.temporary_url.should_not be_nil
    end
  end
end