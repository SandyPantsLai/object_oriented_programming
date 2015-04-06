require 'bigdecimal'
require 'bigdecimal/util'

BASIC_TAX_RATE = BigDecimal('0.10')
IMPORT_DUTY_TAX = BigDecimal('0.05')

#The shopper adds items to a list in the shopping cart
class Shopper
  def initialize
    @shopping_cart = ShoppingCart.new
    puts "Please select your order number to complete checkout.\n"
    load_order
  end

  def load_order
    puts "There are 3 orders stored in the system.  Please enter your order number (1, 2 or 3)"
    case gets.chomp
      when "1"
        @shopping_cart.list_of_items = [[{:item_name => "book", :unit_cost => 12.49}, 1], [{:item_name => "music CD", :unit_cost => 14.99, :tax_rate => "basic"}, 1], [{:item_name => "chocolate_bar", :unit_cost => 0.85}, 1]]
      when "2"
        @shopping_cart.list_of_items = [[{:item_name => "box of chocolates", :unit_cost => 10.00, :tax_rate => "import only"}, 1], [{:item_name => "bottle of perfume", :unit_cost => 47.50, :tax_rate => "import and basic"}, 1]]
      when "3"
        @shopping_cart.list_of_items = [[{:item_name => "bottle of perfume", :unit_cost => 27.99, :tax_rate => "import and basic"}, 1], [{:item_name => "bottle of perfume", :unit_cost => 18.99, :tax_rate => "basic"}, 1], [{:item_name => "packet of headache pills", :unit_cost => 9.75}, 1], [{:item_name => "box of chocolates", :unit_cost => 11.25, :tax_rate => "import only"}, 1]]
      else puts "Invalid choice."
    end
    checkout
  end

  def checkout
    Checkout.new(@shopping_cart)
  end
end

#The shopping cart stores a list of items as they are scanned and performs calclations on it to report to the checkout
class ShoppingCart
  attr_accessor :list_of_items
  def initialize
    list_of_items = []
    @subtotal = 0
    @total_taxes = 0
  end

  def calculate_item_subtotal(unit_cost, quantity)
    (unit_cost * quantity)
  end

  def calculate_item_tax(item_subtotal, tax_rate = nil)
    item_sub_total = BigDecimal(item_subtotal.to_d)
    if tax_rate == "import and basic"
      ((item_subtotal * BASIC_TAX_RATE) + (item_subtotal * IMPORT_DUTY_TAX)).ceil(2).to_f
    elsif tax_rate == "basic"
      (item_subtotal * BASIC_TAX_RATE).ceil(2).to_f
    elsif tax_rate == "import only"
      (item_subtotal * IMPORT_DUTY_TAX).ceil(2).to_f
    else 0
    end
  end

  def add_to_totals(item_subtotal, item_tax)
    @subtotal += item_subtotal
    @total_taxes += (item_tax * 20).ceil / 20.0 #total taxes are rounded up to nearest $0.05
  end

  def return_totals
    totals = Hash.new
    totals[:subtotal] = @subtotal
    totals[:total_taxes] = @total_taxes
    totals[:total] = '%.2f' % (totals[:subtotal] + totals[:total_taxes])
    totals
  end

end

#Shows list of items with totals
class Checkout
  def initialize(shopping_cart)
    @shopping_cart = shopping_cart
    display_cart(@shopping_cart.list_of_items)
  end

  def display_cart(list)
    puts "----------Your Cart-----------"
    list.each do |entry|
      item = entry[0]
      quantity = entry[1]

      if item[:tax_rate] == "import and basic" || item[:tax_rate] == "import only"
       import = " imported"
      else import = nil
      end

      item_subtotal = @shopping_cart.calculate_item_subtotal(item[:unit_cost], quantity)
      item_tax = @shopping_cart.calculate_item_tax(item_subtotal, item[:tax_rate])
      item_total = '%.2f' % (item_subtotal + item_tax)

      puts "#{quantity}#{import} #{item[:item_name]} at $#{item_total}"
      @shopping_cart.add_to_totals(item_subtotal, item_tax)
    end
    puts "------------------------------"
    totals = @shopping_cart.return_totals
    puts "Subtotal: $" + '%.2f' % totals[:subtotal]
    puts "Total Taxes: $" + '%.2f' % totals[:total_taxes]
    puts "Total: $" + totals[:total]
    exit
  end
end

Shopper.new