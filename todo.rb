require "pry"
require "./db/setup"
require "./lib/all"
require "colorize"

puts "*****RUNNING TO-DO LIST*****"
puts "An item in red means it is incomplete.".colorize(:red)
puts "An item in green means that task has been completed!".colorize(:green)
sleep(1)
puts "\n===========================\n==========================="


def add (list, item) # method on LIST class
# This will add a list and item unless no item is specified in which case it will only add a list.
  List.find_or_create_by(name: list)
  List.find_by(name: list).items.create(item_name: item)

  end

def due (item, due_date) # method on ITEM class
# This will add a due date for an already created item.
  a = Item.find_by(item_name: item)
  a.update(due_date: due_date)
  end

def done (item) # method on ITEM class
# Marks the given item as completed.
   Item.find_by(item_name: item).update(completed: true)
end

def list name=nil # just a search / return method in the web file.
# If no list name is given, show all incomplete items. If name is given, show only items from the given list.
  if name != nil
    a = List.find_by(name: name).items
    a.find_each do |item|
      if item.completed == false
        puts "#{item.item_name}".colorize(:red)
      else
        puts "#{item.item_name}".colorize(:green)
    end
  end
  else
    a = Item.where(completed: false)
      a.find_each do |item|
        puts "#{item.item_name}".colorize(:red)
      end
  end
end

def list_all # just a search / return method in the web file.
# Show all lists/items with visual cue for completed items.
  a = Item.all
    a.find_each do |item|
      if item.completed == false
        puts "#{item.item_name}".colorize(:red)
      else
        puts "#{item.item_name}".colorize(:green)
    end
  end
end

def rando # method on ITEM class
# Picks a random item with preference for items with due dates.
  a = Item.where("due_date is not null")
    if a.count > 0
      x = a.sample
      puts "#{x.item_name}"
    else
      b = Item.all
      x = b.sample
      puts "#{x.item_name}"
    end

end

def search (string) # just a search / return method in the web file.
# Searched lists/items for a specific string.
  a = Item.all
  b = List.all
  a.each do |item|
    if "#{string}".match(item.item_name)
      puts "#{item.item_name},\ndue on: #{item.due_date},\ncompleted? #{item.completed}"
    end
  end
  b.each do |list|
    if "#{string}".match(list.name)
      puts "#{list.name}"
    end
  end
end


command = ARGV.shift
case command
when "add"
  # adds TODO item to list (or creates a new list)
  list = ARGV.first
  item = ARGV[1]

  add(list, item)
end
case command
when "due"
  # adds a due date to the associated item.
  item = ARGV.first
  due_date = ARGV[1]

  due(item, due_date)
end
case command
when "done"
  item = ARGV.first

  done(item)
end
case command
when "list"
  name = ARGV.first

  list(name)
end
case command
when "list_all"
  list_all
end
case command
when "rando"
  rando
end
case command
when "search"
  string = ARGV.first

  search(string)
end

