class Array
    def my_each(&prc)
        i = 0
        while i < self.length
            prc.call(self[i])
            i += 1
        end
        self
    end

    def my_select(&prc)
        arr = []
        self.my_each { |v| arr << v if prc.call(v) }
        arr
    end

    def my_reject(&prc)
        my_select { |v| !prc.call(v) }
    end

    def my_any?(&prc)
        self.my_each { |v| return true if prc.call(v) }
        false
    end

    def my_all?(&prc)
        !self.any? { |v| !prc.call(v) }
    end

    def my_flatten
        arr = []
        self.my_each do |v| 
            if v.is_a?(Array)
                flattened = v.my_flatten
                arr.push(*flattened)
            else
                arr << v
            end
        end
        arr
    end

    def my_zip(*args)
        (0 ... self.length).map { |i| (0 .. args.length).map { |j| j == 0 ? self[i] : args[j - 1][i] } }
    end

    def my_rotate(num = 1)
        arr = self.collect { |v| v }

        if num > 0
            (0 ... num).each { arr << arr.shift }
        else
            num *= -1
            (0 ... num).each { arr.unshift(arr.pop) }
        end
        
        arr
    end

    def my_join(sep = "")
        str = ""
        self.each.each_with_index { |v, i| str += v.to_s + (i < self.length - 1 ? sep : "") }
        str
    end

    def my_reverse
        arr = []
        (0 ... self.length).each { |i| arr << self[self.length - 1 - i] }
        arr
    end

    def bubble_sort!(&prc)
        return self if self.length < 2
        done = false

        while !done
            done = true

            (1 ... self.length).each do |i| 
                if prc != nil
                    if prc.call(self[i - 1], self[i]) > 0
                        self[i - 1], self[i] = self[i], self[i - 1] 
                        done = false
                    end
                else
                    if self[i - 1] > self[i]
                        self[i - 1], self[i] = self[i], self[i - 1]
                        done = false
                    end
                end
            end
        end

        self
    end

    def bubble_sort(&prc)
        arr = self.collect { |v| v }
        arr.bubble_sort!(&prc)
    end
end

def factors(num)
    (1 .. num).select { |n| num % n == 0}
end

def substrings(str)
    (0 ... str.length).map { |i| (i ... str.length).map { |j| str[i .. j] } }.flatten(1)
end

def subwords(word, dict)
    dict.select { |w| (w.length ... word.length).any? { |i| word[i - w.length ... i] == w } }
end