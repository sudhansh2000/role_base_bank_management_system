require_relative 'bank_module'
require_relative 'account'
require_relative 'transaction'

# Bank class
class Bank
  attr_accessor :accounts, :transactions, :accoun_number_counter

  include BankMethods

  def initialize
    self.accounts = []
    self.transactions = []
    self.accoun_number_counter = 1002
    add_dummy_accounts
  end

  def add_dummy_accounts
    accounts.push(Account.new(1000, 'sudhansh', '7218341563', 5000))
    accounts.push(Account.new(1001, 'prathmesh', '9345235712', 3000))
  end

  def admin
    loop do
      puts '*************************************'
      puts 'Enter 1 to add new account'
      puts 'Enter 2 to display all the accounts'
      puts 'Enter 3 to display all  the transations'
      puts 'Enter 4 to deposite money'
      puts 'Enter 5 to withdraw money '
      puts 'Enter 6 to exit the program'

      admin_ch = gets.chomp.to_i
      case admin_ch
      when 1
        add_acount
      when 2
        display_all_account_details
      when 3
        display_transactions
      when 4
        deposite_money
      when 5
        withdraw_money
      when 6
        break
      else
        puts 'please enter the correct input'
      end
    end
  end

  def user
    puts 'Enter accoun number to login as a user'
    acc_number = gets.chomp.to_i
    return unless validate_account_number(acc_number)

    loop do
      puts '*************************************'
      puts 'Enter 1 to check balance'
      puts 'Enter 2 to transfer money'
      puts 'Enter 3 display account transactions'
      puts 'Enter 4 to deposite money'
      puts 'Enter 5 to withdaw money'
      puts 'Enter 6 to exit the program'

      admin_ch = gets.chomp.to_i
      case admin_ch
      when 1
        check_balance(acc_number)
      when 2
        trnasfer_money(acc_number)
      when 3
        display_transactions(acc_number)
      when 4
        deposite_money(acc_number)
      when 5
        withdraw_money(acc_number)
      when 6
        break
      else
        puts 'please enter the correct input'
      end
    end
  end

  # transfer money method
  def trnasfer_money(acc_number)
    puts 'Enter recipient account number'
    rec_acc_number = gets.chomp.to_i
    return unless validate_account_number(rec_acc_number)

    return if check_acc_equality(acc_number, rec_acc_number)

    sender_account = @accounts.find { |acc| acc.account_number == acc_number }
    reciver_account = @accounts.find { |acc| acc.account_number == rec_acc_number }
    puts 'Enter amount you want to transfer'
    balance = gets.chomp
    return unless valid_balance(balance)

    if balance.to_i > sender_account.balance
      puts '⚠️  insufficent account balance,amount not debited please try again⚠️'
      puts "Amount present in your bank account - #{sender_account.balance}"
    else
      sender_account.withdraw(balance.to_i)
      reciver_account.deposit(balance.to_i)
      puts "✅ account transfer sucessfully to account number #{rec_acc_number} , your updated account balance is ₹ #{sender_account.balance}"
      @transactions.push(Transaction.new(acc_number, balance.to_i, 'debited', sender_account.balance))
      @transactions.push(Transaction.new(rec_acc_number, balance.to_i, 'balance', reciver_account.balance))
    end
  end

  # function to add new account
  def add_acount
    loop do
      puts 'Enter account holder name'
      @input_name = gets.chomp
      break if @input_name.match?(/^[a-zA-Z ]*$/)

      puts '⚠️ Only charaters are allowed , please try again'
    end

    loop do
      puts 'Enter account holder mobile number'
      @mobile_no = gets.chomp
      break if @mobile_no.match?(/^\d{10}$/)

      puts '⚠️ mobile number enterd is invalid only 10 numbers are allowed , please try again '
    end

    loop do
      puts 'Enter account holders initial account balance'
      @init_balance = gets.chomp
      break if valid_balance(@init_balance)
    end
    account_obj = Account.new(@accoun_number_counter, @input_name, @mobile_no, @init_balance.to_i)
    @accounts.push(account_obj)
    @accoun_number_counter += 1
    puts "✅ account added sucessfully with account number #{@accoun_number_counter - 1} and information as #{account_obj}"
  end

  # function to add money to specifc account
  def deposite_money(acc_number = -1)
    if acc_number == -1
      puts 'Enter account number to deposite money'
      acc_number = gets.chomp.to_i
      return unless validate_account_number(acc_number)
    end

    account_obj = @accounts.find { |acc| acc.account_number == acc_number }

    puts 'Enter amount you want to deposite into account'
    balance = gets.chomp
    return unless valid_balance(balance)

    account_obj.deposit(balance.to_i)
    puts "✅ account credited sucessfully ,updated account balance for account number #{acc_number} is #{account_obj.balance} ₹"
    @transactions.push(Transaction.new(acc_number, balance.to_i, 'credited', account_obj.balance))
  end

  # function to withdraw money from account
  def withdraw_money(acc_number = -1)
    if acc_number == -1
      puts 'Enter account number to withdraw money'
      acc_number = gets.chomp.to_i
      return unless validate_account_number(acc_number)

    end
    puts 'Enter amount you want to withdraw into account'
    balance = gets.chomp
    return unless valid_balance(balance)

    account_obj = @accounts.find { |acc| acc.account_number == acc_number }
    if balance.to_i > account_obj.balance
      puts '⚠️  insufficent account balance,amount not debited please try again⚠️'
      puts "Amount present in your bank account - #{account_obj.balance}'"
    else
      account_obj.withdraw(balance.to_i)
      puts "✅ account debited sucessfully ,updated account balance for account number #{acc_number} is #{account_obj.balance} ₹"
      @transactions.push(Transaction.new(acc_number, balance.to_i, 'debited', account_obj.balance))
    end
  end

  # function to check bank balance of the account
  def check_balance(acc_number)
    account_obj = @accounts.find { |acc| acc.account_number == acc_number }
    puts "balance avaible in account number #{acc_number} is ₹ #{account_obj.balance}"
  end

  # function to dispaly all the account details
  def display_all_account_details
    puts "Account No\tName\t\tMobile\t\tBalance"
    puts '-' * 70
    accounts.each do |account|
      puts "#{account.account_number}\t\t#{account.name.ljust(10)}\t#{account.mobile}\t₹#{account.balance}"
    end
  end

  # displays all the transations
  def display_transactions(acc_number = -1)
    puts "account \t amount \t type \t balance \t date"
    if acc_number == -1
      @transactions.each { |transaction| puts transaction }
      puts 'no transations present ' if @transactions.empty?
    else
      acc_wise_transactions = @transactions.select { |transaction| transaction.account_number == acc_number }
      puts acc_wise_transactions
    end
  end
end

bank = Bank.new

loop do
  puts '****************************************'
  puts 'Enter 1 to login as admin'
  puts 'Enter 2 to login as user'
  puts 'Enter 3 to exit the program'

  ch = gets.chomp.to_i
  case ch
  when 1
    bank.admin
  when 2
    bank.user
  when 3
    break
  else
    puts 'please enter the correct input'
  end
  puts 'Thank you for banking with us'
end
