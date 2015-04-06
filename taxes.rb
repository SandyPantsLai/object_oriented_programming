require 'bigdecimal'
require 'bigdecimal/util'

BASIC_TAX_RATE = BigDecimal('0.10')
IMPORT_DUTY_TAX = BigDecimal('0.05')

#The shopper adds items to a list in the shopping cart
class Shopper
  def initialize
    @shopping_cart = ShoppingCart.new
    puts "Welcome to the Bitmaker Replicatorium."
    shopping_choice
  end

  #Gets input from shopper and decides what to do next
  def shopping_choice
    puts " Please press [1] to replicate your own item, [2] to replicate one from our catalog, [3] to load your previous order or [4] to view your cart and complete checkout.\n"
    case gets.chomp
      when "1" then add_own_item
      when "2" then add_from_catalog
      when "3" then load_previous_order
      when "4" then checkout
      else puts "Invalid choice."
    end
    shopping_choice
  end

  def add_own_item
    puts "Choose an item to replicate or enter your own item."
    add_item_to_catalog(item)
    @shopping_cart.list_of_items << [item, quantity]
  end

  def add_from_catalog
    puts "Please select a category.  [1] for Books and Music, [2] for Food or [3] for Health and Beauty"
    add_from_category(gets.chomp)
  end

  def add_from_category(choice)
    p @shopping_cart.list_of_items
    books_and_music_list = [{:item_name => "book", :unit_cost => 12.49}, {:item_name => "music CD", :unit_cost => 14.99, :tax_rate => "basic"}]
    food_list = [{:item_name => "chocolate_bar", :unit_cost => 0.85},{:item_name => "box of chocolates", :unit_cost => 10.00, :tax_rate => "import only"}]
    health_and_beauty_list = [{:item_name => "bottle of perfume", :unit_cost => 47.50, :tax_rate => "import + basic"}]

    case choice
      when "1" then list = books_and_music_list
      when "2" then list = food_list
      when "3" then list = health_and_beauty_list
    end

    item_number = 1

    list.each do |item|
      puts "[#{item_number}] #{item[:item_name]}: $#{item[:unit_cost]}"
      item_number += 1
    end

    puts "What would you like to add?"
    item = list[gets.chomp.to_i - 1]
    puts "How many would you like?"
    quantity = gets.chomp.to_i
    @shopping_cart.list_of_items.push([item, quantity])
    p @shopping_cart.list_of_items
  end

  def add_item_to_shopping_cart(item)
    @shopping_cart.list_of_items << [item, quantity]
  end

  def load_previous_order
    @shopping_cart.list_of_items ||= [[{:item_name => "book", :unit_cost => 12.49}, 1], [{:item_name => "music CD", :unit_cost => 14.99, :tax_rate => "basic"}, 1], [{:item_name => "chocolate_bar", :unit_cost => 0.85}, 1]]
  end

  def checkout
    Checkout.new(@shopping_cart)

  end
end

#The shopping cart stores a list of items as they are scanned and performs calclations on it to report to the checkout
class ShoppingCart
  attr_accessor :list_of_items
  def initialize
    @list_of_items = []
    @subtotal = 0
    @total_taxes = 0
  end

  def calculate_item_subtotal(unit_cost, quantity)
    (unit_cost * quantity)
  end

  def calculate_item_tax(item_subtotal, tax_rate = nil)
    item_sub_total = BigDecimal(item_subtotal.to_d)
    if tax_rate == "import and basic"
      ((item_subtotal * BASIC_TAX_RATE) + (item_subtotal * IMPORT_DUTY_TAX)).round(2).to_f
    elsif tax_rate == "basic"
      (item_subtotal * BASIC_TAX_RATE).round(2).to_f
    elsif tax_rate == "import only"
      (item_subtotal * IMPORT_DUTY_TAX).round(2).to_f
    else 0
    end
  end

  def add_to_totals(item_subtotal, item_tax)
    @subtotal += item_subtotal
    @total_taxes += item_tax
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
    p list
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