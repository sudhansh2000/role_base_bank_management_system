require_relative 'bank_module'
# Bank class
class Bank
  attr_accessor :accounts, :transactions, :account_number_generator

  include BankMethods

  def initialize
    self.accounts = {
      1000 => { 'name' => 'sudhansh', 'mobile' => '7218341563', 'balance' => 5000 },
      1001 => { 'name' => 'ramesh', 'mobile' => '8888888888', 'balance' => 100 }
    }

    self.transactions = []
    self.account_number_generator = 1002
  end

  def admin
    while true
      puts '*************************************'
      puts 'Enter 1 to add account'
      puts 'Enter 2 to check all the accounts'
      puts 'Enter 3 to check all  the transations'
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

    while true
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

    puts 'Enter amount you want to transfer'
    balance = gets.chomp
    return unless valid_balance(balance)

    if balance.to_i > @accounts[acc_number]['balance']
      puts '⚠️  insufficent account balance,amount not debited please try again⚠️'
      puts "Amount present in your bank account - #{@accounts[acc_number]['balance']}'"
      return
    else
      @accounts[acc_number]['balance'] = @accounts[acc_number]['balance'] - balance.to_i
      @accounts[rec_acc_number]['balance'] = @accounts[rec_acc_number]['balance'] + balance.to_i

      puts "✅ account transfer sucessfully to account number #{rec_acc_number} , your updated account balance is ₹ #{@accounts[acc_number]['balance']}"
      @transactions.push({ 'account_number' => acc_number, 'amount' => balance.to_i, 'type' => 'debited', 'balance' => @accounts[acc_number]['balance'], 'date' => Time.now })
      @transactions.push({ 'account_number' => rec_acc_number, 'amount' => balance.to_i, 'type' => 'credited', 'balance' => @accounts[rec_acc_number]['balance'], 'date' => Time.now })
    end
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
    @account_number_generator += 1
    puts "✅ account added sucessfully with account number #{@account_number_generator - 1} and information as #{@accounts[@account_number_generator - 1]}"
  end

  # function to add money to specifc account
  def deposite_money(acc_number = -1)
    if acc_number == -1
      puts 'Enter account number to deposite money'
      acc_number = gets.chomp.to_i
      return unless validate_account_number(acc_number)
    end

    puts 'Enter amount you want to deposite into account'
    balance = gets.chomp
    return unless valid_balance(balance)

    @accounts[acc_number]['balance'] = @accounts[acc_number]['balance'] + balance.to_i
    puts "✅ account deposited sucessfully ,updated account balance for account number #{acc_number} is #{@accounts[acc_number]["balance"]} ₹"
    @transactions.push({ 'account_number' => acc_number, 'amount' => balance.to_i, 'type' => 'credited', 'balance' => @accounts[acc_number]['balance'], 'date' => Time.now })
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

    if balance.to_i > @accounts[acc_number]['balance']
      puts '⚠️  insufficent account balance,amount not debited please try again⚠️'
      puts "Amount present in your bank account - #{@accounts[acc_number]['balance']}'"
    else
      @accounts[acc_number]['balance'] = @accounts[acc_number]['balance'] - balance.to_i
      puts "✅ account debited sucessfully ,updated account balance for account number #{acc_number} is #{@accounts[acc_number]['balance']} ₹"
      @transactions.push({ 'account_number' => acc_number, 'amount' => balance.to_i, 'type' => 'debited', 'balance' => @accounts[acc_number]['balance'], 'date' => Time.now })
    end
  end

  # function to check bank balance of the account
  def check_balance(acc_number)
    puts "balance avaible in account number #{acc_number} is #{@accounts[acc_number]['balance']} ₹"
  end

  # function to dispaly all the account details
  def display_all_account_details
    puts "Account no \t name \t mobile number \t balance"
    @accounts.each { |k, v|
      puts "#{k} \t #{v['name']} \t #{v['mobile']} \t #{v['balance']}"
    }
  end

  # displays all the transations
  def display_transactions(acc_number = -1)
    puts "account \t amount \t type \t balance \t date"
    if acc_number == -1
      @transactions.each { |transaction| puts transaction }
      puts 'no transations present ' if @transactions.empty?
    else
      acc_wise_transactions = @transactions.select { | transaction | transaction['account_number'] == acc_number }
      puts acc_wise_transactions
    end
  end
end

bank = Bank.new

while true
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
end
