# Copyright (c) 2009 Paolo Capriotti <p.capriotti@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

require 'item'

module ItemBag
  def add_item(key, opts)
    remove_item key
    item = create_item({:name => key}.merge(opts))
    items[key] = item
  end
  
  def remove_item(key, *args)
    if items[key]
      destroy_item items[key] unless args.include? :keep
      removed = items[key]
      items.delete(key)
      removed
    end
  end
  
  def move_item(src, dst)
    remove_item dst
    items[dst] = items[src]
    items.delete(src)
    items[dst]
  end
end
