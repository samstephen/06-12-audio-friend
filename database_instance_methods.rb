require "active_support"
require "active_support/inflector"

# This module will be **included** in all of my classes. It contains methods
# that will become **instance** methods in the class.

module DatabaseInstanceMethods

  # "Gets" the value of a field for a given row from a table.
  #
  # field - String of the column name.
  #
  # Returns the String value of the cell in the table.
  def get(field)
    # Figure out the table's name from the object we're calling the method on.
    table_name = self.class.to_s.pluralize.underscore

    # Get the first/only row as a Hash.
    result = CONNECTION.execute("SELECT * FROM #{table_name} WHERE id = #{@id}").first

    # Return only the value for the key of the field we're seeking.
    result[field]
  end


  # Change a row's cell info by id
  #
  # table_name - table of the class
  # column - String
  # value - String
  # id - Integer
  #
  # Update the name of a product
  def update_cell(column, value)
    table_name = self.class.to_s.pluralize.underscore
    CONNECTION.execute("UPDATE #{table_name} SET #{column} = '#{value}' WHERE id = #{@id}")
  end


end