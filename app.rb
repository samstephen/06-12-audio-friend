#require "pry"
require "sinatra"
require "sinatra/reloader"

# empower my program with SQLite
require "sqlite3"

# load/create our database for this program
CONNECTION = SQLite3::Database.new("users.db")

# transforms sqlite tables(or rows/columns) to ruby hashes
CONNECTION.results_as_hash = true

# creating tables (no need for "IF NOT EXISTS" because tables will be deleted immediately when loading app.rb)
CONNECTION.execute("CREATE TABLE IF NOT EXISTS customers (id INTEGER PRIMARY KEY, name TEXT, card TEXT,
phone TEXT, street TEXT, city TEXT, state TEXT, zip TEXT);")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, product_name TEXT,
current_cost REAL, category TEXT, brand TEXT, retailer TEXT);")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS orders (id INTEGER PRIMARY KEY, customer_id INTEGER,
purchased_on TEXT);")

CONNECTION.execute("CREATE TABLE IF NOT EXISTS order_items (id INTEGER PRIMARY KEY, order_id INTEGER,
product_id INTEGER, quantity INTEGER, item_cost REAL);")

# ----------------------------------------------------------------------------------------------------------------------
require_relative 'customer.rb'
require_relative 'product.rb'
require_relative 'order.rb'
require_relative 'order_item.rb'
require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"
# ----------------------------------------------------------------------------------------------------------------------

################################################### BEGIN WEB UX #######################################################

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
  erb :"updated_customer_name"
end


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













