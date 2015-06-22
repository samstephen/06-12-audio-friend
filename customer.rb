require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Customer

  extend DatabaseClassMethods
  include DatabaseInstanceMethods

  attr_reader :id
  attr_accessor :name, :card, :phone, :street, :city, :state, :zip

  # Initializes a new customer object.
  #
  #options
  #id     (optional) - Integer of a customer's record in the 'customers' table.
  #name   (optional) - String of a customer's name.
  #card   (optional) - String of a customer's credit card payment info.
  #phone  (optional) - String of a customer's phone number
  #street (optional) - String of the customer's street.
  #city   (optional) - String of the customer's city.
  #state  (optional) - String of the customer's state (abbrv).
  #zip    (optional) - String of the customer's zip code.
  #
  #
  # Examples:
  #   Customers.new({"name" => "Sam", "card" => "1234123412341234", "phone" => "4024324292", "street" => "221 N 6", "city" => "Elmwood", "state" => "NE", "zip" => "68349"})
  #
  # Returns a Customer object.
  def initialize(options={})
    @id = options["id"]
    @name = options["name"]
    @card = options["card"]
    @phone = options["phone"]
    @street = options["street"]
    @city = options["city"]
    @state = options["state"]
    @zip = options["zip"]
  end


  # Find a customer name by id using find method from database_class_methods.rb
  #
  #customer_id - The customers table's Integer ID.
  #
  # Returns a Customer object
  def self.find_as_object(customer_id)
    @id = customer_id
    results = Customer.find(customer_id).first
    Customer.new(results)
  end


#  # Updates the customer's table with all values for the customer.
#  #
#  # Returns an empty Array. TODO - This should return something better.
#  def save
#    CONNECTION.execute("UPDATE customers SET name='#{@name}', card='#{@card}', phone='#{@phone}', street='#{@street}', city='#{@city}', state='#{@state}', zip ='#{@zip}' WHERE id = #{@id};")
#  end


end

