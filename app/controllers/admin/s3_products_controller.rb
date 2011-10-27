class Admin::S3ProductsController < Admin::BaseController
  resource_controller
  belongs_to :product

  create.response do |wants|
    wants.html { redirect_to admin_product_s3_products_path(@product) }
  end
end