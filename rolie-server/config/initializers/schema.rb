SCHEMA_Atom = Nokogiri::XML::RelaxNG(File.open("#{Rails.root}/config/atom.rng"))
SCHEMA_iodef = Nokogiri::XML::Schema(File.open("#{Rails.root}/config/iodef-1.0.xsd"))
