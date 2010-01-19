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
      @s3_objects.push(s3_product)
    end
  end


  def connect
    @aws = RightAws::S3Interface.new(S3Options[:access_key_id], S3Options[:secret_access_key], :logger => Rails.logger)
  end
  
  def generate_url(item)
    @aws.get_link(S3Options[:product_bucket], item.filename, S3Options[:url_valid_for])
  end
end