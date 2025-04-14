# Account Class
class Account
  attr_accessor :name, :mobile, :balance, :account_number

  def initialize(account_number, name, mobile, balance)
    @account_number = account_number
    @name = name
    @mobile = mobile
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    return false if amount > @balance

    @balance -= amount
    true
  end

  def to_s
    "#{@account_number}\t#{@name}\t#{@mobile}\t₹#{@balance}"
  end
end
