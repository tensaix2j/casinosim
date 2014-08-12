
winner = 0
loser = 0

(0...1024000).each { |t|
	capital = 1024
	while capital > 1 && capital < 1000000

		bet = capital / 2
		result = rand(2)

		if result == 0
			capital += bet
		else
			capital -= bet
		end
	end

	if capital >= 1000000
		winner += 1
	else
		loser += 1
	end

}

puts "winner #{winner}"
puts "loser #{loser}"