require File.join(File.dirname(__FILE__), "..", "lib", "database")

%w(
Human%E2%80%93computer_interaction
Foods_named_after_places
Skateboarding_tricks
Mechanisms
Sex_positions
Literary_criticism
Space_plasmas
Ghosts
Mammals_of_South_Australia
Dances
Toy_stubs
National_Toy_Hall_of_Fame_inductees
Technology
Packaging
Animals_described_in_1758
Simple_machines
Weapons
American_cuisine
Traditional_Chinese_objects
String_instruments
Creativity
American_inventions
Psychoanalytic_terminology
Cooking_utensils
).each do |category|
  Database.add_category(category)
end