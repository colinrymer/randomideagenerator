class Category
  def self.all
    Database.all_categories
  end

  def self.random
    Database.random_category
  end

  def self.add(category)
    Database.add_category(category)
  end

  def self.remove(category)
    Database.remove_category(category)
  end
end