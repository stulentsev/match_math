class Mutator
  def initialize math
    @math = math.chars.to_a
  end
  
  def print
    get_mutations.each {|m| puts m.inspect }
    # mutations.select{|m| m[1][0] == 0 }.each {|m| puts m.inspect }
  end
  
  def calc math = @math, level = 0, orig_math = @math
    return if level == 2
    
    # puts "on level #{level}, math is #{math.join('')}"
    mut = get_mutations
    zero = mut.select{|m| m[1][0] == 0}
    plus = mut.select{|m| m[1][0] == 1}
    minus = mut.select{|m| m[1][0] == -1}

    result = nil
    
    next_level_tries = []
    
    # puts "Trying simple changes..."
    zero.each do |m|
      m1 = math.dup
      m1[m[0][0]] = m[0][1]
      m2 = m1.join
      
      expr = m2.gsub('=', '==')
      valid = eval expr
      if valid
        result ||= "#{orig_math.join} => #{m2} (cost #{level + 1})"
      else
        # puts "appending #{m2}"
        next_level_tries << m1
      end
    end
    
    # puts "Trying more complex changes..."
    plus.each do |p|
      minus.each do |m|
        next if p[0][0] == m[0][0]
        
        m1 = math.dup
        m1[p[0][0]] = p[0][1]
        m1[m[0][0]] = m[0][1]
        m2 = m1.join

        expr = m2.gsub('=', '==')
        valid = eval expr
        if valid
          result ||= "#{orig_math.join} => #{m2} (cost #{level + 1})"
        else
          # puts "appending #{m2}"
          next_level_tries << m1
        end
      end
    end

    result || next_level_tries.map{|t| calc t, level + 1, orig_math }.compact.first
  end
  
  
  
  private
  
  # transformations and their cost
  # [0, 9] => [0, 1]
  # here [0, 9] is [from, to] and [0, 1] is [total_cost, num_matches]
  # cost of [0, 1] means that to tranform 0 to 9 one needs to move one match within the
  # same place (minus one match, plus one match, zero in total).
  #
  # [6, 8] => [1, 1] is another example. Here no zero sum is possible. It costs one match
  #   to get an 8 from 6. You need to get that match from somewhere.
  # 
  # ['+', '-'] => [-1, 1] - yet another example. You need to move one match to another 
  #   place, so that a plus can become a minus.
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

  # get only relevant mutations
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