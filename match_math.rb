require_relative 'lib/mutator'

examples = [
  '6+2+3=5',
  '8+3-4=0',
  '7+2-4=9',
  '9+4-1=8',
  '9-2-6=9'
]

examples.each do |e|
  m = Mutator.new e
  m.calc
  puts ''
end
