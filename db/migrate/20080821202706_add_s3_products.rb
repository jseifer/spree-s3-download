class AddS3Products < ActiveRecord::Migration
  def self.up
    create_table :s3_products do |t|
      t.string :title
      t.integer :product_id
      t.string :description
      t.string :s3_url
    end    
    add_index :s3_products, :product_id
  end

  def self.down
    remove_table :s3_products
  end
end
