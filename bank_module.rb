# bank modeule
module BankMethods
  # to check valid account number
  def validate_account_number(acc_number)
    return true if @accounts[acc_number]

    puts "⚠️ Account not found with account number #{acc_number} please check the number"
    false
  end

  # to check valid balance input
  def valid_balance(balance)
    if balance.to_i <= 0
      puts '⚠️  value cannot be negative or zero value please try again'
      return false
    elsif !balance.match?(/^[\d.]*$/)
      puts '⚠️ only integer values are allowed please try again'
      return false
    end
    true
  end
end
