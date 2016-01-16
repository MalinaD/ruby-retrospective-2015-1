def convert_to_bgn(price, currency)
       case currency
	        when :usd then rate = 1.7408
			when :eur then rate = 1.9557
			when :gbp then rate = 2.6415
			else rate = 1
		end
        (price * rate).round(2)
end

def compare_prices(price_1, currency_1, price_2, currency_2)
        convert_to_bgn(price_1, currency_1) <=> 
		convert_to_bgn(price_2, currency_2)
end