require File.dirname(__FILE__) + '/../spec_helper'

describe S3Product do

  describe "creating an s3 product" do
    before(:each) do
      @s3_product = S3Product.new(:s3_url => "http://s3.amazonaws.com/test.file")
    end

    it "should require a product" do
      @s3_product.should_not be_valid
    end
  end


  valid_filenames_and_extensions = [
    ['http://s3.amazonaws.com/test.file',     'test.file',     'file'],
    ['http://s3.amazonaws.com/test.file.mp3', 'test.file.mp3', 'mp3'],
    ['http://s3.amazonaws.com/test.jpg',      'test.jpg',      'jpg']
  ]

  valid_filenames_and_extensions.each do |url, valid_filename, valid_extension|
    describe "S3 Product with a url of #{url}" do
      before(:each) do
        @s3_product = create_s3_object_for_product(create_product, {:s3_url => url})
      end

      it "should not be nil" do
        @s3_product.should_not be_nil
      end

      it "should have a product" do
        @s3_product.product.should_not be_nil
      end

      it "should pull the filename(#{valid_filename}) based on the extension: #{valid_filename}" do
        @s3_product.filename.should == valid_filename
      end

      it "should pull the extension(#{valid_extension}) based on the filename: #{valid_filename}" do
        @s3_product.extension.should == valid_extension
      end
    end
  end

end