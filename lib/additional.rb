require 'sequel'

desc "load additional values (rookies, sleepers, etc)"
task :additional do
  DB = Sequel.sqlite('football.sqlite')

  puts 'Updating Rookies'
  ['Trent Richardson',
   'Robert Griffin III',
   'Doug Martin',
   'Andrew Luck',
   'Justin Blackmon',
   'David Wilson',
   'Michael Floyd',
   'Coby Fleener',
   'Brian Quick',
   'Ronnie Hillman',
   'Reuben Randle',
   'Brandon Weeden',
   'Kendall Wright',
   'Alshon Jeffery',
   'Stephen Hill',
   'Isaiah Pead',
   'Mohamed Sanu',
   'LaMichael James',
   'Chris Rainey',
   'Ryan Tannehill'].each do |player|
      DB[:players].where(:name => player).update(:rookie => true)
   end

  puts 'Updating Injured'
  ['Adrian Peterson',
   'Kenny Britt',
   'Rashard Mendenhall',
   'Javid Best',
   'Knowshon Moreno',
   'Terrell Suggs',
   'Roy Helu',
   'Tim Hightower',
   'Bernard Scott',
   'Donavon Kemp',
   'Brian Hartline',
   'Adrian Arrington',
   'Ryan Mathews',
   'Marc Mariani'].each do |player|
      DB[:players].where(:name => player).update(:injury => true)
   end

  puts 'Updating Sleepers'
  ['Matt Ryan',
   'Brandon Lloyd',
   'Demaryius Thomas',
   'Isaac Redman',
   'Daniel Thomas',
   'Coby Fleener'].each do |player|
      DB[:players].where(:name => player).update(:sleeper => true)
   end

  puts 'Updating Bye Weeks'
  DB[:players].where(:team => 'IND').update(:bye => 4)
  DB[:players].where(:team => 'PIT').update(:bye => 4)
  DB[:players].where(:team => 'DAL').update(:bye => 5)
  DB[:players].where(:team => 'DET').update(:bye => 5)
  DB[:players].where(:team => 'OAK').update(:bye => 5)
  DB[:players].where(:team => 'TB' ).update(:bye => 5)
  DB[:players].where(:team => 'CAR').update(:bye => 6)
  DB[:players].where(:team => 'CHI').update(:bye => 6)
  DB[:players].where(:team => 'JAC').update(:bye => 6)
  DB[:players].where(:team => 'NO' ).update(:bye => 6)
  DB[:players].where(:team => 'ATL').update(:bye => 7)
  DB[:players].where(:team => 'DEN').update(:bye => 7)
  DB[:players].where(:team => 'KC' ).update(:bye => 7)
  DB[:players].where(:team => 'MIA').update(:bye => 7)
  DB[:players].where(:team => 'PHI').update(:bye => 7)
  DB[:players].where(:team => 'SD' ).update(:bye => 7)
  DB[:players].where(:team => 'BAL').update(:bye => 8)
  DB[:players].where(:team => 'BUF').update(:bye => 8)
  DB[:players].where(:team => 'CIN').update(:bye => 8)
  DB[:players].where(:team => 'HOU').update(:bye => 8)
  DB[:players].where(:team => 'NE' ).update(:bye => 9)
  DB[:players].where(:team => 'NYJ').update(:bye => 9)
  DB[:players].where(:team => 'SF' ).update(:bye => 9)
  DB[:players].where(:team => 'STL').update(:bye => 9)
  DB[:players].where(:team => 'ARI').update(:bye => 10)
  DB[:players].where(:team => 'CLE').update(:bye => 10)
  DB[:players].where(:team => 'GB' ).update(:bye => 10)
  DB[:players].where(:team => 'WAS').update(:bye => 10)
  DB[:players].where(:team => 'MIN').update(:bye => 11)
  DB[:players].where(:team => 'NYG').update(:bye => 11)
  DB[:players].where(:team => 'SEA').update(:bye => 11)
  DB[:players].where(:team => 'TEN').update(:bye => 11)
end
