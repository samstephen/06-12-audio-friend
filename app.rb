#require "pry"
require "sinatra"
require "sinatra/reloader"

# empower my program with SQLite
require "sqlite3"

# load/create our database for this program
CONNECTION = SQLite3::Database.new("users.db")

# dropping tables to reset the database, can comment out if you'd like to keep history
# CONNECTION.execute("DROP TABLE IF EXISTS customers;")
# CONNECTION.execute("DROP TABLE IF EXISTS products;")
# CONNECTION.execute("DROP TABLE IF EXISTS orders;")
# CONNECTION.execute("DROP TABLE IF EXISTS order_items;")

# transforms sqlite tables(or rows/columns) to ruby hashes
CONNECTION.results_as_hash = true

# creating tables (no need for "IF NOT EXISTS" because tables will be deleted immediately when loading app.rb)
CONNECTION.execute("CREATE TABLE IF NOT EXISTS customers (id INTEGER PRIMARY KEY, name TEXT, card TEXT, phone TEXT, street TEXT, city TEXT, state TEXT, zip TEXT);")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, product_name TEXT, current_cost REAL, category TEXT, brand TEXT, retailer TEXT);")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS orders (id INTEGER PRIMARY KEY, customer_id INTEGER, purchased_on TEXT);")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS order_items (id INTEGER PRIMARY KEY, order_id INTEGER, product_id INTEGER, quantity INTEGER, item_cost REAL);")

# ----------------------------------------------------------------------------------------------------------------------
require_relative 'customer.rb'
require_relative 'product.rb'
require_relative 'order.rb'
require_relative 'order_item.rb'
require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"
# ----------------------------------------------------------------------------------------------------------------------

#define some customers
# Customer.add(name, card, phone, street, city, state, zip)
#Customer.add({'name' => 'Sam Stephen', 'card' => '1234123412341234', 'phone' => '4024324292',
#              'street' => '221 N 6', 'city' => 'Elmwood', 'state' => 'NE', 'zip' => '68349'})         #1
#Customer.add({'name' => 'Joe Poole', 'card' => '4567456745674567', 'phone' => '4022971421',
#              'street' => '1324 S 5', 'city' => 'Lincoln', 'state' => 'NE', 'zip' => '68501'})        #2
#Customer.add({'name' => 'Daniel Mariscal', 'card' => '9876987698769876', 'phone' => '4025555555',
#              'street' => '134 Regency Court', 'city' => 'Omaha', 'state' => 'NE', 'zip' => '68234'}) #3
#
##define some products
## Product.add(product_name, 'current_cost', 'category', 'brand', 'retailer')
#Product.add({'product_name' => 'KeyLab 61', 'current_cost' => 499.00,
#             'category' => 'Instrument', 'brand' => 'Arturia', 'retailer' => 'Guitar Center'})      #1
#Product.add({'product_name' => 'Axiom Pro 25', 'current_cost' => 399.99,
#             'category' => 'Instrument', 'brand' => 'Avid', 'retailer' => 'Best Buy'})              #2
#Product.add({'product_name' => 'Blue Yeti USB Microphone', 'current_cost' => 129.99,
#             'category' => 'Recording', 'brand' => 'Blue', 'retailer' => 'Best Buy'})               #3
#Product.add({'product_name' => 'KRK KNS 8400 - headphones', 'current_cost' => 149.99,
#             'category' => 'Recording', 'brand' => 'KRK Systems', 'retailer' => 'Guitar Center'})   #4
#Product.add({'product_name' => 'KRK VXT 8 Powered Studio Monitor', 'current_cost' => 599.00,
#             'category' => 'Recording', 'brand' => 'KRK Systems', 'retailer' => 'Guitar Center'})   #5
#Product.add({'product_name' => 'Pro Tools 9', 'current_cost' => 399.00,
#             'category' => 'Software', 'brand' => 'Avid', 'retailer' => 'Best Buy'})                #6
#Product.add({'product_name' => 'Logic Pro X', 'current_cost' => 199.00,
#             'category' => 'Software', 'brand' => 'Apple', 'retailer' => 'Guitar Center'})          #7
#
#
##define some orders
## Order.add(customer_id, date)
#Order.add({'customer_id' => 1, 'purchased_on' => '12-20-2010'})  #1(primary key)
#Order.add({'customer_id' => 1, 'purchased_on' => '05-16-2011'})  #2
#Order.add({'customer_id' => 2, 'purchased_on' => '01-05-2012'})  #3
#Order.add({'customer_id' => 1, 'purchased_on' => '07-20-2012'})  #4
#Order.add({'customer_id' => 2, 'purchased_on' => '03-22-2014'})  #5
#Order.add({'customer_id' => 2, 'purchased_on' => '06-01-2015'})  #6
#Order.add({'customer_id' => 1, 'purchased_on' => '06-01-2015'})  #7
#
#
##define some order_items
## OrderItem.add(product_id, order_id, quantity)
#OrderItem.add({'product_id' => 1, 'order_id' => 2, 'quantity' => 1})  #1(customer_id)
#OrderItem.add({'product_id' => 2, 'order_id' => 1, 'quantity' => 1})  #1
#OrderItem.add({'product_id' => 3, 'order_id' => 5, 'quantity' => 1})  #2
#OrderItem.add({'product_id' => 4, 'order_id' => 4, 'quantity' => 1})  #1
#OrderItem.add({'product_id' => 5, 'order_id' => 3, 'quantity' => 1})  #2
#OrderItem.add({'product_id' => 6, 'order_id' => 6, 'quantity' => 2})  #2
#OrderItem.add({'product_id' => 7, 'order_id' => 7, 'quantity' => 1})  #1
#OrderItem.add({'product_id' => 7, 'order_id' => 5, 'quantity' => 1})  #1

# ----------------------------------------------------------------------------------------------------------------------

############################################## BEGIN WEB UX ###############################################


# ---------------------------------------------------------------------
# Menu
# ---------------------------------------------------------------------
get "/home" do
  erb :"homepage"
end

# ---------------------------------------------------------------------
# Add a Customer
# ---------------------------------------------------------------------

# Step 1: Display a form into which the user will add new customer info.
get "/add_customer" do
  erb :"add_customer_form"
end

# Step 2: Take the information they submitted and use it to create new record.
get "/save_customer" do
  # Since the form's action was "/save_customer", it sent its values here.
  #
  # Sinatra stores them for us in `params`, which is a hash. Like this:
  #
  # {"name" => "Beth", "age" => "588"}

  # So using `params`, we can run our class/instance methods as needed
  # to create a customer record.
  @new_customer = Customer.add({"name" => params["name"], "card" => params["card"], "phone" => params["phone"], "street" => params["street"], "city" => params["city"], "state" => params["state"], "zip" => params["zip"]})

  erb :"customer_added"

end

# ---------------------------------------------------------------------
# Change customer's name
# ---------------------------------------------------------------------

# Step 1: List all customers.
#
# Each customer in the ERB is linked to a route that displays a
# form to collect their new name.
get "/update_customers" do
  erb :"update_customers"
end

# Step 2: Display a form into which the user types in a customer's new name.
#
# This route handler is activated when one of the
# links (from Step 1) is clicked.
#
# Example of this path: "/change_customer_name_form/3"
get "/change_name_form/:x" do
  # The actual value of ':x' is stored in params.
  # So using the example path I've given here,
  # `params` equals {"x" => "3"}

  # We don't *need* the customer's ID here, because we're just collecting
  # the customer's new name. But we will need the customer's ID in the next
  # step, so we must collect it here in order to pass it along to the
  # next route.

  # This ERB shows a form into which the customer's new name is typed.
  # Check the ERB file for more documentation.
  erb :"change_name_form"
end

# Step 3: Take the new name and update the correct customer's record.
#
# The form submitted here - for example, to "/change_customer_name/3".
#
# So we have a customer's ID and the customer's new name. That's enough
# information for us to change the database correctly!
get "/change_customer_name" do
  # `params` stores information from BOTH the path (:x) and from the
  # form's submitted information. So right now,
  # `params` is {"x" => "3", "name" => "Marlene"}

  customer = Customer.find_as_object(params["x"].to_i)
  customer.name = params["name"]
  customer.update_cell("name", customer.name)

  # TODO - Send the user somewhere nice after they successfully
  # accomplish this name change.
end















##menu.rb
#
## Log in / Sign up
#puts "Welcome to Audio Friend! ^_^ "
#puts "Please, (L)og In or (S)ign Up! "
#puts "To (Q)uit Audio Friend, type 'q' "
#print ">> "
#answer = gets.chomp.downcase
#
#while answer != "q"
#  if answer == "l"
#    puts "Select who you are. "
#
#    Customer.all.each do |customer|
#      puts "#{customer.id} - #{customer.name}"
#    end
#
#    print ">> "
#    customer_id = gets.chomp.to_i
#
#    Customer(customer_id).all.each do |customer|
#      puts "Welcome #{customer.name}"
#    end
#
#  elsif answer == "s"
#    puts "Enter your first and last name."
#    name = gets.chomp.to_s
#    print ">> "
#    puts "Enter your credit card #."
#    card = gets.chomp.to_s
#    print ">> "
#    puts "Enter your phone #."
#    phone = gets.chomp.to_s
#    print ">> "
#    puts "Enter your street address."
#    street = gets.chomp.to_s
#    print ">> "
#    puts "Enter your city."
#    city = gets.chomp.to_s
#    print ">> "
#    puts "Enter your state."
#    state = gets.chomp.to_s
#    print ">> "
#    puts "Enter your zip code."
#    zip = gets.chomp.to_s
#    print ">> "
#    new_customer = Customer.new(name, card, phone, street, city, state, zip)
#    new_customer.add
#    puts "Welcome to Audio-Friend, #{new_customer.name}"
#  else
#    puts "Sorry, incorrect choice."
#  end
#end


#-----------------------------------------------------------------------------------------------------------------------

# THINGS TODO:

# 1. Create / update / delete warehouse locations (and their descriptions)
# 2. Assign products to a location (a given location should be able to hold multiple products)
# 3. Move products from one location to another
# 4. Assign a product to a category
# 5. Fetch all products in a given category
# 6. Fetch all products in a given location
# 7. Update product quantity



# THINGS TO WATCH OUT FOR

# 1. Be able to create a product that doesn't have a serial number, description, cost, etc. (if you added extra fields, you get to decide which ones are / aren't mandatory)
# 2.Have a given single item exist in more than one location at a time (while I might have a book in Bin A and a book in Bin C, a single book should not exist in both Bins A and C)
# 3. Delete a location or category without first ensuring that it has no products assigned to it (or without otherwise ensuring that those products get assigned to other locations or categories).



# THINGS DONE

# 1. Create product records
# 2. Edit product records
# 3. Fetch and read product records
# 4. Delete product records
# 5.
# 6.
# 7.













