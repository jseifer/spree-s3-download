class S3DownloadExtension < Spree::Extension
  version "1.0"
  description "S3 Download Extension"
  url "http://www.railsenvy.com"

  # Register the s3 extension module for product class to have a clean activation of it.
  module ProductS3Extension
    def self.included(base)
      base.has_many :s3_products
    end
  end
  
  def activate
    Product.send(:include, ProductS3Extension)
    
    User.class_eval do
      def purchased_products
        orders.completed.map{|o| o.line_items.map{|l| l.variant.product}}.flatten
      end
      
      def s3_products
        purchased_products.select{|p| !p.s3_products.empty?}
      end
    end
    
    Order.class_eval do
      named_scope :completed, {
        :include => {:line_items => {:variant => :product}}, # :conditions => {:status => Order::Status::PAID}, We're going to trust the user here.
        :order => 'created_at desc'
      }
      
      named_scope :completed_bare, {
        :conditions => {:status => :checkout_complete},
        :order => 'created_at desc'
      }
    end
    
    Admin::ProductsController.class_eval do
      before_filter :initialize_extension_partials
      def initialize_extension_partials
        @extension_partials ||= Array.new
        @extension_partials.push('admin/s3_products/embed')
      end
    end
  end
  
end