require "active_support"
require "active_support/inflector"

# This module will be **extended** in all of my classes. It contains methods
# that will become **class** methods for the class.

module DatabaseClassMethods

  # Get all of the rows for a table and convert hashes to objects
  #
  # Returns an Array containing Class objects.
  def all
    # Figure out the table's name from the class we're calling the method on.
    table_name = self.to_s.pluralize.underscore

    results = CONNECTION.execute("SELECT * FROM #{table_name}")

    results_as_objects = []

    results.each do |results_hash|
      results_as_objects << self.new(results_hash)
    end

    return results_as_objects
  end


  # Add a new record to the database.
  #
  # options - hash
  #
  # Returns an Object.
  def add(options)
    table_name = self.to_s.pluralize.underscore

    column_names = options.keys
    values = options.values

    individual_values = []

    values.each do |value|
      if value.is_a?(String)
        individual_values << "'#{value}'"
      else
        individual_values << value
      end
    end

    column_names_for_sql = column_names.join(", ")
    individual_values_for_sql = individual_values.join(", ")

    CONNECTION.execute("INSERT INTO #{table_name} (#{column_names_for_sql}) VALUES (#{individual_values_for_sql});")

    options["id"] = CONNECTION.last_insert_row_id

    self.new(options)
  end




#  def save(options)
#    table_name = self.to_s.pluralize.underscore
#
#    column_name = options.keys
#    expr = options.values
#    individual_expr = []
#
#    expr.each do |value|
#      if expr.is_a?(String)
#        individual_expr << "'#{value}'"
#      else
#        individual_expr << value
#      end
#    end
#
#    CONNECTION.execute("UPDATE #{table_name} SET #{column_name} = #{expr} WHERE id = #{@id};")
#  end





  # Get a single row.
  #
  # record_id - The record's Integer ID.
  #
  # Returns an Array containing the Hash of the row.
  def find(record_id)
    # Figure out the table's name from the class we're calling the method on.
    table_name = self.to_s.pluralize.underscore
    CONNECTION.execute("SELECT * FROM #{table_name} WHERE id = #{record_id}")
  end



  # "Deletes" a row from a table
  #
  # record_id - The record's Integer ID.
  #
  # Returns an empty array
  def delete(record_id)
    table_name = self.to_s.pluralize.underscore
    CONNECTION.execute("DELETE FROM #{table_name} WHERE id = #{record_id}")
  end

end




# TODO
  # - adding records to a table - INSERT
  # def add(table_name)
  #   CONNECTION.execute("INSERT INTO #{table_name} (name, age) VALUES ('Sumeet', 500)")
  # end

  # - save - UPDATE customers SET name = 'Sumeet'









