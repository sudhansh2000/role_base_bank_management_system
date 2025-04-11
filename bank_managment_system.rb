require_relative 'bank_module'
# Bank class
class Bank
  attr_accessor :accounts, :transactions, :account_number_generator

  include BankMethods

  def initialize
    self.accounts = {
      1000 => { 'name' => 'sudhansh', 'mobile' => '7218341563', 'balance' => 0 },
      1001 => { ' name' => 'ramesh', 'mobile' => '8888888888', 'balance' => 100 }
    }

    self.transactions = {
      1000 => [
        { 'amount' => 100, 'type' => 'debit', 'balance' => 0 },
        { 'amount' => 200, 'type' => 'credit', 'balance' => 100 }
      ],
      1001 => []
    }
    self.account_number_generator = 1002
  end

  # function to add new account
  def add_acount
    while true
      puts 'Enter account holder name'
      name = gets.chomp
      break if name.match?(/^[a-zA-Z ]*$/)

      puts '⚠️ Only charaters are allowed , please try again'
    end

    while true
      puts 'Enter account holder mobile number'
      mobile_no = gets.chomp
      break if mobile_no.match?(/^\d{10}$/)

      puts '⚠️ mobile number enterd is invalid only 10 numbers are allowed , please try again '
    end

    while true
      puts 'Enter account holders initial account balance'
      init_balance = gets.chomp
      break if valid_balance(init_balance)
    end

    @accounts [@account_number_generator] = { 'name' => name, 'mobile' => mobile_no, 'balance' => init_balance.to_i }
    @transactions[@account_number_generator] = []
    @account_number_generator += 1
    puts "✅ account added sucessfully with account number #{@account_number_generator - 1} and information as #{@accounts[@account_number_generator - 1]}"
  end

  # function to add money to specifc account
  def deposite_money
    puts 'Enter account number to deposite money'
    acc_number = gets.chomp.to_i
    return unless validate_account_number(acc_number)

    puts 'Enter amount you want to deposite into account'
    balance = gets.chomp
    return unless valid_balance(balance)

    @accounts[acc_number]['balance'] = @accounts[acc_number]['balance'] + balance.to_i
    puts "✅ account deposited sucessfully ,updated account balance for account number #{acc_number} is #{@accounts[acc_number]["balance"]} ₹"

    @transactions[acc_number] << { 'amount' => balance.to_i, 'type' => 'credit', 'balance' => @accounts[acc_number]['balance'] }
  end

  # function to withdraw money from account
  def withdraw_money
    puts 'Enter account number to withdraw money'
    acc_number = gets.chomp.to_i

    return unless validate_account_number(acc_number)

    puts 'Enter amount you want to withdraw into account'
    balance = gets.chomp
    return unless valid_balance(balance)

    if balance.to_i > @accounts[acc_number]['balance']
      puts '⚠️  insufficent account balance,amount not debited please try again⚠️'
      puts "Amount present in your bank account - #{@accounts[acc_number]['balance']}'"
    else
      @accounts[acc_number]['balance'] = @accounts[acc_number]['balance'] - balance.to_i
      puts "✅ account debited sucessfully ,updated account balance for account number #{acc_number} is #{@accounts[acc_number]['balance']} ₹"

      @transactions[acc_number] = @transactions[acc_number].push({ 'amount' => balance.to_i, 'type' => 'debited', 'balance' => @accounts[acc_number]['balance'] })
    end
  end

  # function to check bank balance of the account
  def check_balance
    puts 'Enter account number to check the account balance'
    acc_number = gets.chomp.to_i
    return unless validate_account_number(acc_number)

    puts "balance avaible in account number #{acc_number} is #{@accounts[acc_number]['balance']} ₹"
  end

  # function to dispaly all the account details
  def display_all_account_details
    puts "Account no \t name \t mobile number \t balance"
    @accounts.each { |k, v|
      puts "#{k} \t #{v['name'].ljust(20)} \t #{v['mobile']} \t #{v['balance']}"
    }
  end

  # displays all the transations
  def display_all_transactions
    puts 'enter account number to check the transations'
    acc_number = gets.chomp.to_i
    return unless validate_account_number(acc_number)

    puts "Account \t amount \t type \t balance"

    @transactions[acc_number].each { |hash|
      puts "#{acc_number} \t #{hash['amount']} \t #{hash['type']} \t #{hash['balance']}"
    }
  end
end

bank = Bank.new

while true
  puts '****************************************'
  puts 'enter 1 to add account'
  puts 'enter 2 to deposite money'
  puts 'enter 3 to withdraw money '
  puts 'enter 4 to check balance'
  puts 'enter 5 to check all the accounts'
  puts 'enter 6 to check all  the transations'
  puts 'enter 7 to exit the program'
  puts

  ch = gets.chomp.to_i
  case ch
  when 1
    bank.add_acount
  when 2
    bank.deposite_money
  when 3
    bank.withdraw_money
  when 4
    bank.check_balance
  when 5
    bank.display_all_account_details
  when 6
    bank.display_all_transactions
  when 7
    break
  else
    puts 'please enter the correct input'
  end
end
