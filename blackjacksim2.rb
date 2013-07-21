
# 1 shoe = n * decks (n = 1 to 8)
# 1 deck = 4 * suits

$suit = [  2, 3, 4, 5,  6, 7, 8, 9,  10, 10, 10, 10, 11 ]





#--------------
def get_hand_value( handcards ) 

	sum = 0
	softvalue = 0
	
	# How many aces are being used as 11
	handcards.each do
		|v|
		if v == 11 
			softvalue += 10
		end
		sum += v
	end
	
	while sum > 21 && softvalue > 0
		sum -= 10
		softvalue -= 10
	end
	
	return sum
end


#--------------
def basic_card_counting( used_cards )

	result = 0

	used_cards.each do 
		|pv|
		if [ 2,3,4,5,6 ].index(pv) != nil
			result += 1
		
		elsif [ 10,11 ].index(pv) != nil

			result -= 1
		end
	end

	return result

end



#--------------
# Note that the entire shoe gets reshuffled when it is 3/4 used
$used_cards = []

def draw_one_card()

	if $used_cards.length >=  3 * $shoe.length 
	
		$stderr.printf "Reshuffled ..."
		# entire shoe is reshuffled
		$shoe = ($suit * 4 * $number_of_deck).shuffle
		$used_cards.clear

	end

	$used_cards << $shoe[0]
	return $shoe.shift

end

#----------
def one_round( bet ) 

	player_hand = []
	banker_hand = []
	player_split_hand = []
	player_done = 0
	banker_done = 0
	player_hassplit = 0

	# Initial hands
	(0...2).each { |i| 
		player_hand << draw_one_card()
	}
	banker_hand << draw_one_card()


	# Loop until player is done.
	while player_done == 0 
		
		# Get suggesting from Basic Strategy
		suggestion = basic_strategy( banker_hand , player_hand , player_hassplit )

		#puts "Suggestion : #{ decode( suggestion) }"

		# HIT
		if suggestion == H 

			player_hand << draw_one_card()

			if get_hand_value( player_hand ) > 21 
				player_done = 1
			end
			
		# STAND
		elsif suggestion == S
			
			player_done = 1
			
		# DOUBLE = BET*2, HIT and STAND
		elsif suggestion == D
			
			bet *= 2
			player_hand << draw_one_card()
			player_done = 1


		# SPLIT
		elsif suggestion == SP
			
			player_split_hand << player_hand.shift
			player_hand << draw_one_card()
			player_split_hand << draw_one_card()
			player_hassplit = 1

		end
	end

	# Loop until split hand is done too
	if player_hassplit == 1
		
		player_done = 0
		while player_done == 0

			# Get suggesting from Basic Strategy
			suggestion = basic_strategy( banker_hand , player_split_hand , 1 )

			# HIT
			if suggestion == H || suggestion == D

				player_split_hand << draw_one_card()

				if get_hand_value( player_split_hand ) > 21 
					player_done = 1
				end
				
			# STAND
			elsif suggestion == S 
				player_done = 1
			end
		end	

	end


	# Loop until banker is done
	while banker_done == 0

		banker_hand << draw_one_card()
		if get_hand_value( banker_hand ) >= 17
			banker_done = 1
		end
	end


	#p player_hand
	#p player_split_hand if player_hassplit == 1
	#p banker_hand


	# Both done, now check the main hand
	playerval = get_hand_value( player_hand )
	playerval = -1 if playerval > 21

	bankerval = get_hand_value( banker_hand )
	bankerval = -1 if bankerval > 21
	

	if playerval > bankerval 	
		
		$balance += bet
		
	elsif playerval == -1
		
		# player LOSE if both banker and player bust,
		# and this is where the HOUSEEDGE comes from.
		
		$balance -= bet
	
	
	elsif playerval == bankerval
		# Push

	else
		$balance -= bet
	end


	# Check the split hand if has split
	if player_hassplit == 1 
		
		player_splitval	= get_hand_value( player_split_hand )
		player_splitval = -1 if player_splitval > 21
	
		if player_splitval > bankerval 	
			$balance += bet
		elsif player_splitval == -1
			
			$balance -= bet

		elsif player_splitval == bankerval
			# Push
		else
			$balance -= bet
		end
	end


end


#----------
# Enums: Hit, Stand, Double, Split, Surrender 
H  = 0
S  = 1
D  = 2
SP = 3
SU = 4


def basic_strategy( banker , player  , already_split ) 

	playerval = get_hand_value( player ) 
		
	# 2 cards, and both cards are same number, can suggest split
	if ( player.length == 2 && player[0] == player[1] && already_split == 0 ) 
		
		if player[0] == 11 || player[0] == 8
			return SP
		
		elsif player[0] == 10
			return S
		
		elsif player[0] == 9
			if banker[0] == 7 || banker[0] == 10 || banker[0] == 11
				return S
			else
				return SP
			end
		
		elsif player[0] == 7
			
			if banker[0] == 10 
				return S
				
			elsif banker[0] <= 7
				return SP
			else
				return H
			end
			
		elsif player[0] == 6
			if banker[0] >= 2 && banker[0] <= 7
				return SP
			else
				return H
			end
		
		elsif player[0] == 5
			if banker[0] <= 9 
				return D
			else
				return H
			end
			
		elsif player[0] == 4
			if banker[0] >= 4 && banker[0] <= 6
				return SP
			else
				return H
			end
			
			
		elsif player[0] == 3 
		
			if banker[0] >= 2 && banker[0] <= 8 
				return SP
			else
				return H
			end
		
		elsif player[0] == 2
		
			if banker[0] >= 2 && banker[0] <= 7 
				return SP
			else
				return H
			end
		end
		
		
	# > 2 cards	or already split
	else 
	
		if playerval <= 7 
			return H
		
		elsif playerval == 8
			
			if banker[0] >= 5 && banker[0] <= 6 && player.length == 2
				return D
			else
				return H
			end
		
		elsif playerval == 9
			if banker[0] >= 2 && banker[0] <= 6 && player.length == 2
				return D
			else
				return H
			end
			
		elsif playerval == 10
			if banker[0] <= 9 && player.length == 2
				return D
			else
				return H
			end
		
		elsif playerval == 11
			if banker[0] <= 11 && player.length == 2
				return D
			else
				return H
			end
		
		elsif playerval == 12
			
			if banker[0] <= 3 
				return H
			elsif banker[0] >= 4 && banker[0] <= 6
				return S
			else
				return H
			end
		
		
		elsif playerval >= 13 

			# SOFT
			if get_hand_value( player + [10] ) < 21
				
				if playerval >= 13 && playerval <= 16
					if banker[0] >= 4 && banker[0] <= 6 && player.length == 2
						return D
					else
						return H
					end
				
				elsif playerval == 17
					if banker[0] >= 2 && banker[0] <= 6 && player.length == 2
						return D
					else
						return H
					end
				
				elsif playerval == 18
				
					if banker[0] >= 9 && banker[0] <= 10 
						return H
					else
						return S
					end
				
				elsif playerval >= 19
					return S	
				end
			
			
			
			# HARD	
			else
			
				if playerval <= 16
			
					if banker[0] <= 6
						return S
					else
						return H
					end
					
				elsif playerval >= 17  
				
					return S
				end
			end
		end
	end

end

#----------
def decode( intval ) 
	
	return "H" if intval == H 
	return "S" if intval == S 
	return "D" if intval == D 
	return "SP" if intval == SP 
	return "SU" if intval == SU
	
end


#------------------------
def main( argv )

	if argv.length < 2 

		puts "Usage ruby blackjacksim.rb <number of deck> <number of round for simulation>"
		return
	end

	$balance = 100
	bet = 10

	$number_of_deck = argv[0].to_i
	$number_of_round = argv[1].to_i
	$shoe = ($suit * 4 * $number_of_deck).shuffle

	
	(0...$number_of_round).each { |i|		
	
		card_counting_val = basic_card_counting( $used_cards )

		if card_counting_val > 5
			bet = 10
		elsif card_counting_val < -2
			bet = 1
		else
			bet = 5
		end

		one_round( bet )
	}


	puts "\n#{$balance}"

	


	
end


main ARGV












