class Transaction
  attr_reader :account_number, :amount, :type, :balance_after, :date

  def initialize(account_number, amount, type, balance_after)
    @account_number = account_number
    @amount = amount
    @type = type
    @balance_after = balance_after
    @date = Time.now
  end

  def to_s
    "#{@account_number}\t#{@amount}\t#{@type}\t#{@balance_after}\t#{@date}"
  end
end
  