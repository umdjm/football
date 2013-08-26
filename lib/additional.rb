require 'sequel'

desc "load additional values (rookies, sleepers, etc)"
task :additional do
  DB = Sequel.sqlite('football.sqlite')

  puts 'Updating Rookies'
  ['Tyler Eifert',
   'Cordarrelle Patterson',
   'Montee Ball',
   "Le'Veon Bell",
   'Eddie Lacy',
   'Giovani Bernard',
   'Tavon Austin',
   'DeAndre Hopkins',
   'Cordarelle Patterson',
   'Zac Stacy',
   'E.J. Manuel',
   'Robert Woods',
   'Keenan Allen',
   'Markus Wheaton',
   'Andre Ellington',
   'Johnathan Franklin',
   'Geno Smith',
   'Aaron Dobson',
   'Stedman Bailey',
   'Justin Hunter'].each do |player|
      DB[:players].where(:name => player).update(:rookie => true)
   end

  puts 'Updating Injured'
  ['Plaxico Burress',
   'Joseph Morgan',
   'Arrelious Benn',
   'Danny Amendola',
   'Danario Alexander',
   'Jeremy Maclin',
   'Dennis Pitta',
   'Armon Binns',
   'Dustin Keller',
   'LaRon Byrd',
   'Taylor Price',
   'Sederrik Cunningham',
   'Kris Adams',
   'Brandon Carswell',
   'Kevin Elliott',
   'Michael Zordich',
   'R.J. Webb',
   'Mike Caussin',
   "Le'Veon Bell",
   'Maurice Jones-Drew',
   'Lex Hilliard'].each do |player|
      DB[:players].where(:name => player).update(:injury => true)
   end

  puts 'Updating Sleepers'
  ['Steven Jackson',
   'Reggie Bush',
   'Percy Harvin',
   'Ahmad Bradshaw',
   'Wes Welker',
   'Anquan Boldin',
   'David Wilson',
   'Danario Alexander',
   'Rueben Randle',
   'Vincent Brown',
   'Bryce Brown',
   'Michael Floyd',
   'Lamar Miller'
   ].each do |player|
      DB[:players].where(:name => player).update(:sleeper => true)
   end

  puts 'Updating Bye Weeks'
  DB[:players].where(:team => 'CAR').update(:bye => 4)
  DB[:players].where(:team => 'GB' ).update(:bye => 4)
  DB[:players].where(:team => 'PIT').update(:bye => 5)
  DB[:players].where(:team => 'WAS').update(:bye => 5)
  DB[:players].where(:team => 'MIN').update(:bye => 5)
  DB[:players].where(:team => 'TB' ).update(:bye => 5)
  DB[:players].where(:team => 'ATL').update(:bye => 6)
  DB[:players].where(:team => 'MIA').update(:bye => 6)
  DB[:players].where(:team => 'NO' ).update(:bye => 7)
  DB[:players].where(:team => 'OAK').update(:bye => 7)
  DB[:players].where(:team => 'CHI').update(:bye => 8)
  DB[:players].where(:team => 'BAL').update(:bye => 8)
  DB[:players].where(:team => 'HOU').update(:bye => 8)
  DB[:players].where(:team => 'IND').update(:bye => 8)
  DB[:players].where(:team => 'TEN').update(:bye => 8)
  DB[:players].where(:team => 'SD' ).update(:bye => 8)
  DB[:players].where(:team => 'ARI').update(:bye => 9)
  DB[:players].where(:team => 'DET').update(:bye => 9)
  DB[:players].where(:team => 'JAC').update(:bye => 9)
  DB[:players].where(:team => 'DEN').update(:bye => 9)
  DB[:players].where(:team => 'SF' ).update(:bye => 9)
  DB[:players].where(:team => 'NYG').update(:bye => 9)
  DB[:players].where(:team => 'NE' ).update(:bye => 10)
  DB[:players].where(:team => 'NYJ').update(:bye => 10)
  DB[:players].where(:team => 'KC' ).update(:bye => 10)
  DB[:players].where(:team => 'CLE').update(:bye => 10)
  DB[:players].where(:team => 'STL').update(:bye => 11)
  DB[:players].where(:team => 'DAL').update(:bye => 11)
  DB[:players].where(:team => 'PHI').update(:bye => 12)
  DB[:players].where(:team => 'BUF').update(:bye => 12)
  DB[:players].where(:team => 'CIN').update(:bye => 12)
  DB[:players].where(:team => 'SEA').update(:bye => 12)

  puts 'Updating Keepers'
  DB[:players].where(:name => 'Arian Foster').update(:drafted => true, :mine => true)
  DB[:players].where(:name => 'Aaron Rodgers').update(:drafted => true)
  DB[:players].where(:name => 'Jamaal Charles').update(:drafted => true)
  DB[:players].where(:name => 'Adrian Peterson').update(:drafted => true)
  DB[:players].where(:name => 'Drew Brees').update(:drafted => true)
  DB[:players].where(:name => 'C.J. Spiller').update(:drafted => true)
  DB[:players].where(:name => 'Brandon Marshall').update(:drafted => true)
  DB[:players].where(:name => 'Roddy White').update(:drafted => true)
  DB[:players].where(:name => 'Frank Gore').update(:drafted => true)
  DB[:players].where(:name => 'Peyton Manning').update(:drafted => true)
  DB[:players].where(:name => 'Marshawn Lynch').update(:drafted => true)
  DB[:players].where(:name => 'David Wilson').update(:drafted => true)

  puts 'Updating Return Men'
  ['Darren Sproles',
   'Cordarrelle Patterson',
   'Trindon Holliday',
   'Josh Cribbs',
   'Darius Reynaud',
   'Leon Washington',
   'Dwayne Harris',
   'Jacoby Jones',
   'Ted Ginn Jr',
   'Reggie Bush',
   'Leodis McKelvin',
   'Joe McKnight',
   'Percy Harvin',
   'David Wilson',
   'Randall Cobb',
   'T.Y. Hilton',
   'Dez Bryant',
   'Giovani Bernard',
   'Tavon Austin',
   'LaMichael James'].each do |player|
      DB[:players].where(:name => player).update(:returner => true)
  end
end
