# Spree S3 Product Extension

The Spree S3 product extension lets you easily add downloads to your spree 
application.

## How to use:

This has to go in the "vendor/spree/vendor/extensions" from your project
root.

First off, run the 'db:migrate' task.  There's a migration in the db directory
that will create a s3_products table that's associated with products.

In your project root (not Spree root), create config/initializers/s3.rb.  
There's a sample in the config/initializers/s3.rb.  It supports the S3 gem
convention of having environment variables: AMAZON_ACCESS_KEY_ID and 
AMAZON_SECRET_ACCESS_KEY respectively.  So create it:

		S3Options = {
		  :access_key_id     => (ENV['AMAZON_ACCESS_KEY_ID'] || 'SECRET'),
		  :secret_access_key => (ENV['AMAZON_SECRET_ACCESS_KEY'] || 'SECRET'),
		  :product_bucket    => 'envycasts',
		  :url_valid_for     => 15.minutes
		}

The string you put in "product_bucket" is where the S3DownloadSet model will
look for your s3 files.  The "url_valid_for" option only work when you create 
a bulk download set.  A bulk download set will go through a product and its
associated S3 files and generate temporary urls that are valid for the amount
of time you specify in 'url_valid_for'.

Once you migrate and configure you need to add your associated s3 products.
You can put a link in your product, say your edit view:

		<%= link_to "Add S3 Object to &quot;#{@product.name}&quot;", 
		    new_admin_product_s3_products_path(@product) %>

And link to your s3 products this way:

		<%= link_to "Edit S3 Objects for &quot;#{@product.name}&quot;", 
		    admin_product_s3_products_path(@product) %>

## Linking to your downloads

You have two options.  Option 1: Individual download link.  This will
create a temporary url for just one s3 product.  Where ever you want to
link to your users s3 download, just do this in your view (this assumes
you have the "product" variable set to a completed order product variant):

		<% for s3_product in product.s3_products %>
		<%= link_to s3_product.title, download_individual_path(product, s3_product) %>
		<% end %>

The downloads controller automatically generates the s3 download set object
for you.

Option 2 is to create a download set and iterate through that.  In your
controller:

		@s3_set = S3DownloadSet.new(:user => user, 
								:product => product,
		 						:url_generation => 'bulk')

In your view:

		<% for s3_object in @s3_set %>
		  <%= link_to s3_object.name, s3_object.temporary_url %>
		<% end %>

## Notes:

This doesn't provide any upload functionality.  You can use one of the many
s3 clients to do that.  Just make sure you don't set the permissions of your
file to be public.


## License

The MIT License

Copyright (c) 2008 Jason Seifer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.