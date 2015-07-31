# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ws1 = Workspace.create(title: 'public', path: 'public')
ws2 = Workspace.create(title: 'private', path: 'private')

c1 = Collection.create(title: 'public incidents', path: 'incidents', workspace: ws1)
c2 = Collection.create(title: 'private incidents', path: 'incidents', workspace: ws2)

e1 = Entry.create(collection: c1, content: <<-XML)
<?xml version="1.0" encoding="UTF-8"?>
<iodef:IODEF-Document lang="en" xmlns:iodef="urn:ietf:params:xml:ns:iodef-1.0">
</iodef:IODEF-Document>
XML
