class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :asin
      t.string :published_at
      t.string :amazon_image_url
      t.string :image_url
      t.integer :previous_sales_rank
      t.integer :last_sales_rank

      t.timestamps
    end
  end
end
