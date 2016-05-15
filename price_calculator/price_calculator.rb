require 'csv'

class Order
  attr_accessor :order_item_list
  def initialize
    @order_item_list = {}
  end

  def add_order_item(item_name, quantity = 1)
    key = Item.name_to_key(item_name)
    if @order_item_list.key?(key)
      @order_item_list[key].quantity += quantity
    else
      @order_item_list[key] = OrderItem.new(key,quantity)
    end
  end

  def amount_total
    @order_item_list.values.inject(0){ |total, order_item|
      total + order_item_total(order_item)
    }
  end

  def order_item_total(order_item)
      regular_price_quantity = order_item.quantity % order_item.item.sale_price_quantity
      sale_eligible_quantity = order_item.quantity - regular_price_quantity
      sale_price_total = (sale_eligible_quantity / order_item.item.sale_price_quantity * order_item.item.sale_price)
      regular_price_total = (regular_price_quantity * order_item.item.single_unit_price)

      sale_price_total + regular_price_total
  end

  def amount_saved
    raw_total = @order_item_list.values.inject(0){ |total, order_item|
      total + (order_item.quantity * order_item.item.single_unit_price)
    }

    raw_total - amount_total
  end

  def printout_items
    @order_item_list.values.each{ |order_item|
      puts [
        order_item.item.name.ljust(9),
        order_item.quantity.to_s.ljust(13),
        Order.to_dollar(order_item_total(order_item))
      ].join('')
    }

  end

  def print_order
    puts 
    puts "Item     Quantity      Price"
    puts "--------------------------------------"
    printout_items
    puts
    puts "Total price : #{Order.to_dollar(amount_total)}"
    puts "You saved #{Order.to_dollar(amount_saved)} today."
  end

  def self.to_dollar(amount)
    "$" + amount.to_s.rjust(3,"0").insert(-3,".")
  end
end

class OrderItem
  attr_accessor :item, :quantity
  def initialize(item_key, quantity)
    @item = PricingTable.get_item(item_key)
    @quantity = quantity
  end
end

class Item
  attr_accessor :name, :single_unit_price, :sale_price, :sale_price_quantity

  def initialize(name, single_unit_price, sale_price = nil, sale_price_quantity = nil)
    @name = name
    @single_unit_price = single_unit_price
    @sale_price = sale_price || @single_unit_price
    @sale_price_quantity = sale_price_quantity || 1
  end

  def key
    self.class.name_to_key(@name)
  end

  def self.name_to_key(name)
    name.strip.downcase
  end

end

class PricingTable
  @@list = {}
  def self.add(item)
    @@list[item.key] = item
  end

  def self.get_item(item_key)
    @@list[item_key] || (raise "Item for key #{item_key} does not exist")
  end

  def self.add_items_from_raw_table(raw_table)
    # transform raw pricing table to machine friendly delimited table
    transformed_rows = raw_table.split(/\r?\n\r?/).map{ |row|
      row.gsub(/\s{2,}/,",")
        .gsub(/\$([0-9]{0,3})\.([0-9]{2})/,"\\1\\2") # remove dollar sign and decimal
    }.reject{ |row|
      row =~ /[-=+]{3,}/ # remove the divider row
    }

    CSV::parse(transformed_rows.join("\n"), col_sep: ',', headers: true).each do |csv|
      row = csv.to_h
      name = row["Item"]
      price = row["Unit price"].to_i
      if row["Sale price"]
        sale_price = row["Sale price"].split(" for ")[1].to_i
        sale_price_quantity = row["Sale price"].split(" for ")[0].to_i
      else
        sale_price = nil
        sale_price_quantity = nil 
      end

      new_item = Item.new( name, price, sale_price, sale_price_quantity )
      add(new_item)
    end
  end
end

# For the purposes of this exercise, the pricing table is embedded in a heredoc
# of the source code. This normally would exist outside the document and be loaded
# at run time. To do that, copy the contents of the heredoc into a file in the
# current directory named pricing_table.txt, delete the heredoc code below 
# (lines 140 - 147), and uncomment the following line:
# raw_pricing_table = File.read("pricing_table.txt")

raw_pricing_table = <<-RAW_PRICING_TABLE
Item     Unit price        Sale price
--------------------------------------
Milk      $3.97            2 for $5.00
Bread     $2.17            3 for $6.00
Banana    $0.99
Apple     $0.89
RAW_PRICING_TABLE

################
# Main Runtime #
################

PricingTable.add_items_from_raw_table(raw_pricing_table)
order = Order.new

puts "Please enter all the items purchased separated by a comma"
item_input = gets

item_input.strip.split(",").each do |item_name|
  order.add_order_item(item_name)
end

order.print_order
