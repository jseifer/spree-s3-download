# S3 Options Hash for Spree S3 Products
# -------------------------------------
# Keys:
# access_key_id:     Your Amazon Access Key
# secret_access_key: Your Amazon Secret Access Key
# product_bucket:    The bucket where you keep your products
# url_valid_for:     How long you want your s3 url to work for someone
#                    downloading your product once it has been
#                    purchased.
S3Options = {
  :access_key_id     => (ENV['AMAZON_ACCESS_KEY_ID'] || 'SECRET'),
  :secret_access_key => (ENV['AMAZON_SECRET_ACCESS_KEY'] || 'SECRET'),
  :product_bucket    => 'envycasts',
  :url_valid_for     => 15.minutes
}