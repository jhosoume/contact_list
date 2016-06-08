require 'pg'

DBNAME = 'contactbook'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email
  attr_reader :id 

  # @@contacts = []
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email, id = nil)
    @name = name
    @email = email
    @id = id
  end

  def to_s
    "#{id} : #{name} (#{email})"
  end

  def to_a
    [name, email]
  end

  def save
    if id
      Contact.connection.exec("UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int", [name, email, id])
    else
      id = Contact.connection.exec("INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id", [name, email])
      @id = id[0]["id"].to_i
    end
    self
  end
    
  def destroy
    Contact.connection.exec("DELETE FROM contacts WHERE id = $1::int;", [id])
  end

  # Provides functionality for managing contacts in the contacts database.
  class << self

    def connection
        PG.connect(
            host: 'localhost',
            dbname: DBNAME,
            user: 'development',
            password: 'development'
        )
    end

    # Opens contacts database and creates a Contact object for each row in the table (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      connection.exec("SELECT * FROM contacts").map do |contact_info|
        self.new(contact_info["name"], contact_info["email"], contact_info["id"].to_i) 
      end
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      self.new(name, email).save
    end
   
    # Find the Contact in the database file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      contact_info = connection.exec("SELECT * FROM contacts WHERE id = $1::int;", [id])
      if contact_info.count <= 0 
        nil
      else
          contact_info = contact_info.first
          self.new(contact_info["name"], contact_info["email"], id)
      end
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      connection.exec("SELECT * FROM contacts WHERE name LIKE $1 OR email LIKE $1;", [term]).map do |contact_info|
        self.new(contact_info["name"], contact_info["email"], contact_info["id"])
      end 
      # all.select { |contact| contact.name == term || contact.email == term }
    end

    def update(id, name, email)
      to_update = find(id)
      to_update.name = name
      to_update.email = email
      to_update.save
    end

    def destroy(id)
      self.find(id).destroy    
    end

  end
end
