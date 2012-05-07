class Mutator
  def initialize math
    @math = math.chars.to_a
  end
  
  def print
    get_mutations.each {|m| puts m.inspect }
    # mutations.select{|m| m[1][0] == 0 }.each {|m| puts m.inspect }
  end
  
  def calc
    mut = get_mutations
    zero = mut.select{|m| m[1][0] == 0}
    plus = mut.select{|m| m[1][0] == 1}
    minus = mut.select{|m| m[1][0] == -1}
    found = false
    
    # puts "Trying simple changes..."
    zero.each do |m|
      m1 = @math.dup;
      m1[m[0][0]] = m[0][1]
      m1 = m1.join
      
      expr = m1.gsub('=', '==')
      res = eval expr
      if res
        found = true
        puts "#{@math.join} => #{m1}" if res
      end
    end
    
    # puts "Trying more complex changes..."
    plus.each do |p|
      minus.each do |m|
        next if p[0][0] == m[0][0]
        
        m1 = @math.dup;
        m1[p[0][0]] = p[0][1]
        m1[m[0][0]] = m[0][1]
        m1 = m1.join

        expr = m1.gsub('=', '==')
        res = eval expr
        if res
          found = true
          # puts "#{@math[p[0][0]]} -> #{p[0][1]}"
          # puts "#{@math[m[0][0]]} -> #{m[0][1]}"
          puts "#{@math.join} => #{m1}" if res
        end
      end
    end
    
    puts "No solutions found for #{@math.join}" unless found
  end
  
  
  
  private
  
  MUTATIONS = {
    [0, 9] => [0, 1],
    [0, 6] => [0, 1],
    [2, 3] => [0, 1],
    [3, 5] => [0, 1],
    [6, 9] => [0, 1],
    
    [0, 8] => [1, 1],
    [1, 7] => [1, 1],
    [3, 9] => [1, 1],
    [5, 9] => [1, 1],
    [5, 6] => [1, 1],
    [6, 8] => [1, 1],
    [8, 9] => [-1, 1],
    ['+', '-'] => [-1, 1]
  }

  def full_mutations
    res = {}
    MUTATIONS.each do |from, cost|
      f1, f2 = from
      c1, c2 = cost
      
      res[[f1.to_s, f2.to_s]] = [c1, c2]
      res[[f2.to_s, f1.to_s]] = [-c1, c2]
    end
    res
  end
  
  def get_mutations
    res = []
    
    @math.each_with_index do |c, idx|
      full_mutations.each do |from, cost|
        f1, f2 = from
        
        if f1 == c
          res << [[idx, f2], cost]
        end
      end
    end
    
    res
  end
  
end