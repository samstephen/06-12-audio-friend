require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Order

  extend DatabaseClassMethods
  include DatabaseInstanceMethods

  attr_reader :id
  attr_accessor :customer_id, :purchased_on

  # Initializes a new Order object.
  #
  #id           (optional) - Integer of a order's record in the 'orders' table.
  #customer_id  (optional) - Integer of a order's name.
  #purchased_on (optional) - String of a order's credit card payment info.
  #
  # Returns a Order object.
  def initialize(options={})
    @id = options["id"]
    @customer_id = options["customer_id"]
    @purchased_on = options["purchased_on"]
  end

  # Lists all orders. Includes the total cost of an order
  def self.list_all_orders
    CONNECTION.execute('SELECT orders.id, orders.customer_id, orders.purchased_on, SUM(order_items.quantity * order_items.item_cost) FROM orders, order_items WHERE orders.id = order_items.order_id GROUP BY orders.id, orders.customer_id, orders.purchased_on;')
  end


  # Lists orders of a customer. Includes the total cost of an order
  def self.list_orders_of_customer(customer_id)
    CONNECTION.execute("SELECT orders.id, orders.customer_id, orders.purchased_on, SUM(order_items.quantity * order_items.item_cost) FROM orders, order_items WHERE orders.id = order_items.order_id AND orders.customer_id = #{customer_id} GROUP BY orders.id, orders.customer_id, orders.purchased_on;")
  end

end



