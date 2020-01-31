require './lib/journey.rb'

class Oystercard

  attr_reader :balance, :journeys

  MAX_BALANCE = 90
  MIN_BALANCE = 1
  PENALTY = 6

  def initialize(history = Journey.new)
    @balance = 0
    @journeys = history
  end

  def top_up(amount)
    fail "Amount entered exceeds top limit of £#{MAX_BALANCE}" if maximum_limit?(amount)
    @balance += amount
  end

  def touch_in(station)
    fail "Minimum fare of £#{MIN_BALANCE} not met" if minimum_balance?
    fare(false) if self.in_journey?
    self.journeys.set_entry_station(station)
  end

  def touch_out(station)
    self.journeys.set_exit_station(station)
    fare
    self.journeys.store_journey
    self.journeys.set_entry_station(nil)
  end

   def in_journey?
    self.journeys.entry_station == nil ? false : true
   end

  private
  def maximum_limit?(amount)
    balance + amount > MAX_BALANCE
  end

  def minimum_balance?
    @balance < MIN_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def fare(in_use = true)
    deduct self.in_journey? == in_use ? MIN_BALANCE : PENALTY
  end
end
