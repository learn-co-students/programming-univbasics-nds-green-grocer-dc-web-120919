def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  counter = 0 
  while counter < collection.length do 

    if name == collection[counter][:item] || name == collection[counter][name]
      
      return collection[counter]
    end   
    
    counter += 1 
  end 
  return nil 
end


#this is only for finding an already matching item, do not use for nil, will just return nil 
def find_matching_index(name, collection)
  #so we know there is a matching item, we just need to find which array index it is in 
  index = 0 
  while index< collection.length do 

    if name == collection[index][:item]
      return index 
    end 

  index += 1 
  end 
end 


def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  cart_array = []
  cart_hash = {}
  count = 0 
  puts "***new consolidated cart*****"
  while count <cart.length do 
    
    item_name = cart[count][:item]
    item_price = cart[count][:price]
    item_clearance = cart[count][:clearance]
    #looks up item in a collection and returns hash or nil 
    check_cart = find_item_by_name_in_collection(item_name, cart_array)
    
    if check_cart == nil 
      
      #adds new item hash to array 
      #puts item_name  
      # working line for using :item as another key in an array of individual hashes  
      cart_array << {item: item_name, price: item_price, clearance: item_clearance, count: 1}
      
      #current working line as a hash of individual keys 
      cart_hash["#{item_name}"] = {
        price: item_price, clearance: item_clearance, count: 1
      }
      
    else #ups the count of an existing item 
  
      # working line for :item as another key in an array of individual hashes  
       ind = find_matching_index(item_name, cart_array)
       cart_array[ind][:count] += 1 
       
       #current working line as a hash of individual keys 
       cart_hash["#{item_name}"][:count] += 1 
    end   
    
    #puts "array result:"
    #puts cart_array 
    #puts "hash result:"
    #puts cart_hash
    #puts "$$$"
    count += 1 
  end 
  #puts "Consolidated cart below:"
  #puts "#{cart_array} \n #{cart_hash} \n ***end consolidated cart***"
  return cart_array 
end


def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  
  puts "***Coupon portion starting***"
  #puts "Coupon length is #{coupons.length}"
  coupon_count = 0 
  new_cart = cart #establishes new copy of cart before looping 
  
  #loops through coupon book 
  while coupon_count<coupons.length do 
    
    coupon_name = coupons[coupon_count][:item]
    check_item = find_item_by_name_in_collection(coupon_name, cart)
    matching_index = find_matching_index(coupon_name, cart)
    
    #checks the item, if it returns nil, coupon is found in the cart; cart count >= coupon num  
    if check_item != nil && cart[matching_index][:count] >= coupons[coupon_count][:num]
      
      #if the item is in the cart and has the correct count, it will now need to be a new line item "___W/ COUPON", change :clearance to true, and add the count to the new item and subtract it from the old 
      num_coupons_applied = cart[matching_index][:count]/coupons[coupon_count][:num]
      
      new_cart << {item: "#{coupon_name} W/COUPON", price: (coupons[coupon_count][:cost])/(coupons[coupon_count][:num]), clearance: cart[matching_index][:clearance], count: (num_coupons_applied*coupons[coupon_count][:num])}
      
      new_cart[matching_index][:count] -= num_coupons_applied*coupons[coupon_count][:num]
      
      #puts "Coupon found!"
    else
      
      #puts "Coupon target not found or not enough items"
    end 
    
    coupon_count += 1 
  end
  
  #puts new_cart 
  puts "***End Coupons"
  return new_cart
end


def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  
  new_cart = cart #works on a new cart, can save old cart as comparison 
  
  counter = 0 
  while counter < cart.length do 
    if cart[counter][:clearance] == true 
      
      #applies discounted price, hardcoded to 20% off
      discounted_price = (cart[counter][:price]*0.8).round(2)
      cart[counter][:price] = discounted_price
    end 
  
  counter += 1 
  end 
  
  return new_cart 
end


def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  
  total_price = 0.0 
  new_cart = consolidate_cart(cart)
  new_cart = apply_coupons(new_cart, coupons)
  new_cart = apply_clearance(new_cart)
  
  price_index = 0 
  while price_index < new_cart.length do 
  
  total_price += new_cart[price_index][:price]*new_cart[price_index][:count]
  end 
  
  if total_price > 100.00 
    
    total_price = total_price*0.9 
  end 
  
  return total_price 
end 