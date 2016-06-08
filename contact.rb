# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact < ActiveRecord::Base

  def to_s
    "#{id} : #{name} (#{email})"
  end

  class << self 
    def search(term)
      Contact.where("name ILIKE ? OR email ILIKE ?", term, term)
    end 

  end

end
