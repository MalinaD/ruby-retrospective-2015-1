def convert_to_bgn(price, currency)
       currencies  = { usd: 1.7408, eur: 1.9557, gbp: 2.6415, bgn: 1}
	   value = currencies.fetch(currency)
		(price * value).round(2)
end

def compare_prices(price_one, currency_one, price_other, currency_other)
        convert_to_bgn(price_one, currency_one) <=>
		convert_to_bgn(price_other, currency_other)
end