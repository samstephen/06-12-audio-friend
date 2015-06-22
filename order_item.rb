require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class OrderItem

  extend DatabaseClassMethods
  include DatabaseInstanceMethods

  attr_reader :id
  attr_accessor :product_id, :order_id, :quantity

  # Initializes a new OrderItem object.
  #
  #id           (optional) - Integer of a order item's record in the 'order items' table.
  #product_id   (optional) - Integer of a order's product_id.
  #order_id     (optional) - Integer of a order's order_id.
  #quantity     (optional) - Integer of a order item's quantity.
  #
  # Returns a OrderItem object.
  def initialize(options={})
    @id = options["id"]
    @product_id = options["product_id"]
    @order_id = options["order_id"]
    @quantity = options["quantity"]
  end


  # adds a new "item" to an existing order.
    # ("item_cost" is figured by "product_cost" in "products table" when added to "order_items table")
  def self.add_order_item(product_id, order_id, quantity)
    item_cost = product_cost(product_id)
    CONNECTION.execute("INSERT INTO order_items (product_id, order_id, quantity, item_cost) VALUES (#{product_id}, #{order_id}, #{quantity}, #{item_cost});")
  end


  # finds "current_cost" of product based on it's "product_id", returns value to "product_cost" method
  # need to separate the two costs, because cost can change - order cost doesn't change.
  def self.product_cost(product_id)
    product = Product.new(product_id)
    product.find_current_cost
  end




  # lists all order items and includes item_cost as item_total in order_items table
  def self.list_all_order_items
    CONNECTION.execute("SELECT *, quantity * item_cost as item_total FROM order_items;")
  end

  # Show all items purchased in an order by order_id
  def self.list_items_in_an_order(order_id)
    CONNECTION.execute("SELECT *, quantity * item_cost as item_total FROM order_items WHERE order_id = '#{order_id}';")
  end

  # Selects a row from the order_items table by id and includes the total of item_cost
  def get_item
    CONNECTION.execute("SELECT *, quantity * item_cost as item_total FROM order_items WHERE id = '#{@id}';")
  end

end



