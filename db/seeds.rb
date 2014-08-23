# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "********Seeding Data Start************"
admin=User.find(:all, :conditions => ["email=?",'admin@tmochat.com'])
if admin.blank?
	admin=User.new(:username => 'admin', 
		:email => 'admin@tmochat.com', 
		:password => 'tmoadmin', 
		:password_confirmation => 'tmoadmin', 
		:user_type => 'Admin')
	     admin.save!(:validate => false)
	puts "data feed successfully!!!"
else
	puts "data Already added!!!"
end

puts "********Seeding Data End************"