#!/usr/bin/env ruby

require 'pry'
require 'byebug'
require 'pg'
require 'active_record'
require_relative 'contact'

DBNAME = 'contactbook'

#ActiveRecord::Base.logger = Logger.new(STDOUT)

puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: DBNAME,
  username: 'development',
  password: 'development',
  host: 'localhost',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)
puts 'CONNECTED'

class ContactList
  def initialize
    receive
  end

  private
    def help
      puts "Here is a list of availabe commands:
      \t--new\t- Create a new contact
      \t--list\t- List all contacts
      \t--show\t- Show a contact
      \t--search\t- Search contacts
      \t--help\t- Print all commands
      \t--update\t- Update selected contact
      \t--delete\t- Delete according to id"
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
        print_contacts(Contact.all.order(:id))
        print_total(Contact.all)
      when '--new'
        create_contact(@commands.shift, @commands.shift)
      when '--show'
        show(@commands.shift)
      when '--search'
        selected = Contact.search(@commands.shift)
        print_contacts(selected)
        print_total(selected)
      when '--update'
        update(@commands.shift, @commands.shift, @commands.shift)
      when '--delete'
        delete(@commands.shift) 
      else
        puts "Invalid command.\n"
      end
    end

    def create_contact(name, email)
      unless Contact.search(email).empty?
        puts "Duplicated email"
        exit!
      end
      new_contact = Contact.create(name: name, email: email)
      puts "Contact created succesfully. ID #{new_contact.id}"
    end

    def print_contacts(list)
      list.each { |contact| puts contact } 
    end

    def print_total(list)
      puts "------"
      puts "#{list.length} records total" 
    end

    def delete(id)
      Contact.find(id).destroy
      puts "Now, #{id} is no longer in the record"
    end

    def show(id)
      contact = Contact.find(id.to_i)
      if contact
        puts contact
      else
        puts "Not Found"
      end
    end

    def update(id, name, email)
      Contact.find(id).update(name: name, email: email)
      puts "Contact of #{id} successfully updated!"
    end

end


ContactList.new if $0 == __FILE__
