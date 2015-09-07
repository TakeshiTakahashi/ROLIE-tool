# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ws1 = Workspace.create(title: 'public', path: 'public')
ws2 = Workspace.create(title: 'private', path: 'private')

c1 = Collection.create(title: 'public incidents', path: 'incidents', workspace: ws1, author: <<-XML.chomp)
<author><email>csirt@example.org</email><name>EMC CSIRT</name></author><author><email>csirt2@example.org</email></author>
XML

c2 = Collection.create(title: 'private incidents', path: 'incidents', workspace: ws2, author: <<-XML.chomp)
<author><email>csirt@example.org</email><name>EMC CSIRT</name></author>
XML
