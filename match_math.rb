require_relative 'lib/mutator'


examples = [
  # '6+2+3=5',
  # '8+3-4=0',
  # '7+2-4=9',
  # '9+4-1=8',
  # '9-2-6=9',
  # 
  # '75-5=20',
  # '7-13=14',
  # '39+34=65',
  # '8+3-4=0'
  '12+41=58', # cost 1
  '12+37=53'  # cost 2
]

examples.each do |e|
  m = Mutator.new e
  puts m.calc.inspect
  puts ''
end
