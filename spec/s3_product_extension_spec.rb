require File.dirname(__FILE__) + '/spec_helper'

describe S3ProductExtension do
  it "should register itself by giving products s3 products" do
    product = create_product
    product.s3_products.should eql([])
  end
end