# app/models/amazon_proxy.rb

class AmazonProxy
  Amazon::Ecs.configure do |options|
    options[:AWS_access_key_id] = ''
    options[:AWS_secret_key]    = ''
    options[:associate_tag]     = 'cheryltee69-20'
  end

  private
  def self.fetch(asin)
    result = Amazon::Ecs.item_lookup(asin, { :response_group => 'Medium' })
    result.items[0]
  end

  def self.import_book(asin)
    item = fetch(asin)
    save_book asin, item
  end

  def self.save_book(asin, item)
    return if Book.exists?(asin: asin)
    options                       = {}
    image_url                     = item.get_hash('MediumImage')['URL']
    item_attributes               = item.get_element('ItemAttributes')
    options[:asin]                = asin
    options[:title]               = item_attributes.get('Title')
    options[:published_at]        = item_attributes.get('PublicationDate')
    options[:author]              = item_attributes.get_array('Author').join(', ')
    options[:amazon_image_url]    = image_url
    options[:image_url]           = save_image(asin, image_url)
    sales_rank                    = item.get_element('SalesRank')
    options[:previous_sales_rank] = sales_rank
    Book.create! options
  end

  begin
    def self.save_image(asin, image_url)
      relative_path = "/static/#{asin}.jpg"
      file_path     = Rails.root.join("public#{relative_path}")
      Magick::Image.read(image_url).first.resize_to_fill(100, 100).write(file_path)
      relative_path
    end
  end
end