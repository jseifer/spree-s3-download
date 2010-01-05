unless defined? SPREE_ROOT
  ENV["RAILS_ENV"] = "test"
  case
  when ENV["SPREE_ENV_FILE"]
    require ENV["SPREE_ENV_FILE"]
  when File.dirname(__FILE__) =~ %r{vendor/SPREE/vendor/extensions}
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../../../")}/config/environment"
  else
    puts "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
    require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/environment"
  end
end

require "#{SPREE_ROOT}/spec/spec_helper"

if File.directory?(File.dirname(__FILE__) + "/scenarios")
  Scenario.load_paths.unshift File.dirname(__FILE__) + "/scenarios"
end
if File.directory?(File.dirname(__FILE__) + "/matchers")
  Dir[File.dirname(__FILE__) + "/matchers/*.rb"].each {|file| require file }
end

Spec::Runner.configure do |config|
  # config.use_transactional_fixtures = true
  # config.use_instantiated_fixtures  = false
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures'

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do 
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
end

module S3Helper
  def stub_s3
    
  end
  
  def create_user(options={})
    User.create({
      :email => 'joe@blow.com',
      :password => 'asdf',
      :password_confirmation => 'asdf'
    }.merge(options))
  end

  def create_product(options={})
    product = Product.new({
      :name => "Test product",
      :price => 19.99,
      :description => 'The best product in the world.',
      :available_on => 5.minutes.ago.to_s(:db)
    }.merge(options))
    
    variant = Variant.new(:product => product)
    product.variants.push(variant)
    product.save
    product
  end
  
  def create_s3_object_for_product(product, options={})
    product.s3_products.create({
      :title => "s3 product",
      :s3_url => 'http://s3.amazonaws.com/test',
      :description => 'an s3 product'
    }.merge(options))
  end

def create_line_item(variant)
  line_item = LineItem.new(:quantity => 1)
  line_item.variant = variant
  line_item.price = 19.99
  line_item.save!
  line_item
end

# this is approximative and need to be checked  
def create_complete_order(user, product, options={})
  returning(user.orders.create) do |order|
    order.line_items.push create_line_item(product.variants.first)
    order.save
    order.checkout.bill_address =  Address.new({
        :firstname => "First",
        :lastname => "Last",
        :address1 => "Address1",
        :city => "City",
        :state_name => "A State",
        :zipcode => "00000",
        :country => Country.new,
        :phone => "00000000"
      })
    order.complete
    order.save!
  end
end   
  
  def create_user_and_product_and_order
    @user = create_user
    @product = create_product
    create_s3_object_for_product(@product, {:title => 's3 file 1'})
    create_s3_object_for_product(@product, {:title => 's3 file 2'})
    create_complete_order(@user, @product)
  end
end

include S3Helper