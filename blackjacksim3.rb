
$suit = [  2, 3, 4, 5,  6, 7, 8, 9,  10, 10, 10, 10, 11 ]

class Array
  def subtract_once(b)
    h = b.inject({}) {|memo, v|
      memo[v] ||= 0; memo[v] += 1; memo
    }
    reject { |e| h.include?(e) && (h[e] -= 1) >= 0 }
  end
end


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
# Note that the entire shoe gets reshuffled when it is 3/4 used
$used_cards = []

def draw_one_card()

	if $used_cards.length >=  3 * $shoe.length 
	
		#$stderr.printf "Reshuffled ..."
		# entire shoe is reshuffled
		$shoe = ($suit * 4 * $numberofdeck ).subtract_once( $case ).shuffle
		$used_cards.clear

	end

	$used_cards << $shoe[0]
	return $shoe.shift

end


	$numberofdeck = 6
	$case = [  10, 5 ]
	
	bust_count 			= 0
	nobust_count	 	= 0
	
	
	(0...10000).each { |iteration|

		$shoe = ($suit * 4 * $numberofdeck ).subtract_once( $case ).shuffle
		
		player_hand = $case.dup

		player_hand << draw_one_card()
		val = get_hand_value( player_hand )
		
		if val > 21 
			bust_count += 1
		else
			nobust_count += 1
		end	

		
	}

	puts ""
	puts "bust_count #{bust_count}"
	puts "nobust_count #{nobust_count}"

	
	dealer_bust_count 		= 0
	dealer_nobust_count 	= 0
	$case = [  11 ]
		
	(0...10000).each { |iteration|

		$shoe = ($suit * 4 * $numberofdeck ).subtract_once( $case ).shuffle
		
		dealer_hand = $case.dup
		dealer_hand << draw_one_card()
		val = get_hand_value( dealer_hand )
		
		while val < 17 
			dealer_hand << draw_one_card()
			val = get_hand_value( dealer_hand )
		end
			
		if val > 21 
			dealer_bust_count += 1
		else
			dealer_nobust_count += 1
		end	
	}

	puts ""
	puts "dealer_bust_count #{dealer_bust_count}"
	puts "dealer_nobust_count #{dealer_nobust_count}"









