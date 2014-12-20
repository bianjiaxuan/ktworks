class Country < ActiveRecord::Base
  # attr_accessible :name, :parent, :kind
  validates :name, :presence => true

  def parents?
    parents_node=[""]
    nodes=Country.where("kind ='country'")
    nodes.each do |node|
      parents_node.push(node.name)
    end
    return parents_node

    Country.find
  end

  def self.cities
    Country.where(:kind => "city")
  end

  def self.countries
    Country.where(:kind => "country")
  end
end

