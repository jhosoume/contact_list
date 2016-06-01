require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_reader :indx, :name, :email

  # @@contacts = []
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email, indx)
    @name = name
    @email = email
    @indx = indx
  end

  def to_s
    "#{indx} : #{name} (#{email})"
  end

  def to_a
    [name, email]
  end
    
  # Provides functionality for managing contacts in the csv file.
  class << self

    def get_csv(csvfile)
      @@csv = csvfile
    end

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      CSV.open(@@csv).each_with_index.map do |csvcontact, indx|
        Contact.new(csvcontact[0], csvcontact[1], indx + 1) 
      end
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      contact = Contact.new(name, email, all.length + 1)
      CSV.open(@@csv, 'a') do |csv|
        csv << contact.to_a
      end
      contact
    end
   
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      all[id - 1]
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      all.select { |contact| contact.name == term || contact.email == term }
    end

  end
end
