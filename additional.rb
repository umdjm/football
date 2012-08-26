require 'sequel'

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
    DB[:offense].where(:name => player).update(:rookie => true)
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
    DB[:offense].where(:name => player).update(:injury => true)
 end

puts 'Updating Sleepers'
['Matt Ryan',
 'Brandon Lloyd',
 'Demaryius Thomas',
 'Isaac Redman',
 'Daniel Thomas',
 'Coby Fleener'].each do |player|
    DB[:offense].where(:name => player).update(:sleeper => true)
 end

puts 'Updating Bye Weeks'
DB[:offense].where(:team => 'IND').update(:bye => 4)
DB[:offense].where(:team => 'PIT').update(:bye => 4)
DB[:offense].where(:team => 'DAL').update(:bye => 5)
DB[:offense].where(:team => 'DET').update(:bye => 5)
DB[:offense].where(:team => 'OAK').update(:bye => 5)
DB[:offense].where(:team => 'TB' ).update(:bye => 5)
DB[:offense].where(:team => 'CAR').update(:bye => 6)
DB[:offense].where(:team => 'CHI').update(:bye => 6)
DB[:offense].where(:team => 'JAC').update(:bye => 6)
DB[:offense].where(:team => 'NO' ).update(:bye => 6)
DB[:offense].where(:team => 'ATL').update(:bye => 7)
DB[:offense].where(:team => 'DEN').update(:bye => 7)
DB[:offense].where(:team => 'KC' ).update(:bye => 7)
DB[:offense].where(:team => 'MIA').update(:bye => 7)
DB[:offense].where(:team => 'PHI').update(:bye => 7)
DB[:offense].where(:team => 'SD' ).update(:bye => 7)
DB[:offense].where(:team => 'BAL').update(:bye => 8)
DB[:offense].where(:team => 'BUF').update(:bye => 8)
DB[:offense].where(:team => 'CIN').update(:bye => 8)
DB[:offense].where(:team => 'HOU').update(:bye => 8)
DB[:offense].where(:team => 'NE' ).update(:bye => 9)
DB[:offense].where(:team => 'NYJ').update(:bye => 9)
DB[:offense].where(:team => 'SF' ).update(:bye => 9)
DB[:offense].where(:team => 'STL').update(:bye => 9)
DB[:offense].where(:team => 'ARI').update(:bye => 10)
DB[:offense].where(:team => 'CLE').update(:bye => 10)
DB[:offense].where(:team => 'GB' ).update(:bye => 10)
DB[:offense].where(:team => 'WAS').update(:bye => 10)
DB[:offense].where(:team => 'MIN').update(:bye => 11)
DB[:offense].where(:team => 'NYG').update(:bye => 11)
DB[:offense].where(:team => 'SEA').update(:bye => 11)
DB[:offense].where(:team => 'TEN').update(:bye => 11)
