#!/usr/bin/env ruby

require_relative 'contact'

CSVFILE = 'contacts.csv'

class ContactList
  def initialize
    Contact.get_csv(CSVFILE)
    receive
  end

  private
    def help
      puts "Here is a list of availabe commands:
      \t--new\t- Create a new contact
      \t--list\t- List all contacts
      \t--show\t- Show a contact
      \t--search\t- Search contacts
      \t--help\t- Print all commands"
    end

    def receive
      @commands = ARGV[0..-1]
      @commands << '--help' if @commands.empty?
      until @commands.empty? do 
        operand(@commands.shift)  
      end
    end

    def operand(option)
      case option
      when '--help'
        help
      when '--list'
        print_contacts(Contact.all)
        print_total(Contact.all)
      when '--new'
        create_contact(@commands.shift, @commands.shift)
      when '--show'
        show(@commands.shift)
      when '--search'
        selected = Contact.search(@commands.shift)
        print_contacts(selected)
        print_total(selected)
      else
        puts "Invalid command.\n"
      end
    end

    def create_contact(name, email)
      unless Contact.search(email).empty?
        puts "Duplicated email"
        exit!
      end
      new_contact = Contact.create(name, email)
      puts "Contact created succesfully. ID #{Contact.all.length}"
    end

    def print_contacts(list)
      list.each_with_index do |contact, index|
        puts contact
        # gets if (index + 1) % 5 == 0 # Pagination for every 5 (wait for an enter to print the rest)
      end
    end

    def print_total(list)
      puts "------"
      puts "#{list.length} records total" 
    end

    def show(id)
      contact = Contact.find(id.to_i)
      if contact
        puts contact
      else
        puts "Not Found"
      end
    end

end


ContactList.new if $0 == __FILE__
