require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email

  @@contacts = []
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
    self.name, self.email = name, email
  end

  def to_s
    "#{name} (#{email})"
  end
    
  # Provides functionality for managing contacts in the csv file.
  class << self

    def get_csv(csvfile)
      @@csv = csvfile
    end

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
      CSV.foreach('contacts.csv') do |csvcontact|
        @@contacts << Contact.new(csvcontact[0], csvcontact[1]) 
      end
      @@contacts
    end

    def total
      @@contacts.length
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      contact = Contact.new(name, email)
      CSV.open(@@csv, 'a') do |csv|
        csv << [contact.name, contact.email]
      end
      contact
    end
   
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      @@contacts[id - 1]
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      @@contacts.select { |contact| contact.name == term || contact.email == term }
    end

  end

end
