require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Product

  extend DatabaseClassMethods
  include DatabaseInstanceMethods

  attr_reader :id
  attr_accessor :product_name, :current_cost, :category, :brand, :retailer

  # Initializes a new product object.
  #
  #id             (optional) - Integer of a product's record in the 'products' table.
  #product_name   (optional) - String of a product's name.
  #current_cost   (optional) - Real of a product's current cost in 'products' table
  #category       (optional) - String of a product's category.
  #brand          (optional) - String of a product's brand.
  #retailer       (optional) - String of a product's retailer.
  #
  # Returns a Product object.
  def initialize(options={})
    @id = options["id"]
    @product_name = options["product_name"]
    @current_cost = options["current_cost"]
    @category = options["category"]
    @brand = options["brand"]
    @retailer = options["retailer"]
  end




  # Find a customer name by id using find method from database_class_methods.rb
  #
  # product_id - The products table's Integer ID.
  #
  # Returns a Customer object
  def self.find_as_object(product_id)
    @id = product_id
    results = Product.find(product_id).first

    temp_name = results["product_name"]
    temp_cost = results["current_cost"]
    temp_category = results["category"]
    temp_brand = results["brand"]
    temp_retailer = results["retailer"]

    Product.new(product_id, temp_name, temp_cost, temp_category, temp_brand, temp_retailer)
  end








  # Change product name by id
  #
  # product_id - The products table's Integer ID.
  #
  # Update the name of a product

  #
  #
  # Update the current_cost of a product
  def change_product_cost(current_cost)
    CONNECTION.execute("UPDATE products SET cost = #{current_cost} WHERE id = #{@id}")
  end
end



