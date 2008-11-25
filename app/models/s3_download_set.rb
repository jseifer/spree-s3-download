require 'aws/s3'
class S3DownloadSet
  attr_accessor :user, :product, :bucket, :urls
  attr_reader :s3_objects
  
  def initialize(*args)
    @options = args.extract_options!
    @options[:url_generation] ||= 'individual'
    @s3_objects = Array.new
    connect
    fetch
  end
  
  def valid?
    @options[:user].purchased_products.include?(@options[:product])
  end
  
private
  def fetch
    case @options[:url_generation]
    when 'individual'
      fetch_individual(@options[:id])
      return @s3_objects.first.temporary_url
    when 'bulk'
      fetch_bulk
      return @s3_objects
    end
  end
  
  def fetch_individual(file_id)
    s3_product = @options[:product].s3_products.find(file_id)
    s3_product.temporary_url = generate_url(s3_product)
    @s3_objects.push(s3_product)
  end

  def fetch_bulk
    @options[:product].s3_products.each do |s3_product|
      s3_product.temporary_url = generate_url(s3_product)
      @s3_objects.push(s3_objects)
    end
  end

  def connect
    AWS::S3::Base.establish_connection!(
      :access_key_id     => S3Options[:access_key_id],
      :secret_access_key => S3Options[:secret_access_key]
    )
    @bucket = AWS::S3::Bucket.find(S3Options[:product_bucket])
  end
  
  def generate_url(item)
    AWS::S3::S3Object.url_for(item.filename, S3Options[:product_bucket], :authenticated => true, :expires_in => S3Options[:url_valid_for])
  end
end