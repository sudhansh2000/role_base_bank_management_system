# bank modeule
module BankMethods
  # to check valid account number
  def validate_account_number(acc_number)
    account_obj = accounts.find { |acc| acc.account_number == acc_number }
    return true if account_obj

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

  def check_acc_equality(acc_number, rec_acc_number)
    if acc_number == rec_acc_number
      puts '⚠️  you cannot transfer money to your own account, please try again'
      return true
    end
    false
  end
end
