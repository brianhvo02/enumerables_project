require("enumerables_array")

describe "Enumberables" do
    describe "Array#my_each" do
        it "should take a block argument" do
            expect { [1, 2, 3].my_each { |num| puts num } }.to_not raise_error
        end

        it "should call the block on every element of the array" do
            arr = [1, 2, 3]
            prc = Proc.new { |num| puts num } 

            expect(STDOUT).to receive(:puts).exactly(3)
            arr.my_each(&prc)

            expect { arr.my_each(&prc) }.to output(/1\n2\n3/).to_stdout
        end

        it "should return the array" do
            expect([1, 2, 3].my_each { |num| puts num }).to eq([1, 2, 3])
        end
    end

    describe "Array#my_select" do
        it "should take a block argument" do
            expect { [1, 2, 3].my_select { |num| num > 1 } }.to_not raise_error
        end

        it "should return a new array containing only elements that satisfies the block" do
            arr = [1, 2, 3]
            
            expect(arr.my_select { |num| num > 1 }).to eq([2, 3])
            expect(arr.my_select { |num| num == 4 }).to eq([])
        end

        it "should call Array#my_each" do
            arr = [1, 2, 3]

            expect(arr).to receive(:my_each)
            arr.my_select { |num| num > 1 }
        end
    end

    describe "Array#my_select" do
        it "should take a block argument" do
            expect { [1, 2, 3].my_reject { |num| num > 1 } }.to_not raise_error
        end

        it "should return a new array excluding elements that satisfies the block" do
            arr = [1, 2, 3]
            
            expect(arr.my_reject { |num| num > 1 }).to eq([1])
            expect(arr.my_reject { |num| num == 4 }).to eq([1, 2, 3])
        end
    end

    describe "Array#my_any?" do
        it "should take a block argument" do
            expect { [1, 2, 3].my_any? { |num| num > 1 } }.to_not raise_error
        end

        it "should return true if any element satisfies the block" do
            arr = [1, 2, 3]
            
            expect(arr.my_any? { |num| num > 1 }).to eq(true)
            expect(arr.my_any? { |num| num == 4 }).to eq(false)
        end
    end
    
    describe "Array#my_all?" do
        it "should take a block argument" do
            expect { [1, 2, 3].my_all? { |num| num > 1 } }.to_not raise_error
        end

        it "should return true if any element satisfies the block" do
            arr = [1, 2, 3]
            
            expect(arr.my_all? { |num| num > 1 }).to eq(false)
            expect(arr.my_all? { |num| num < 4 }).to eq(true)
        end
    end

    describe "Array#my_flatten" do
        it "should return all elements of the array into a new, one-dimensional array" do
            expect([1, 2, 3, [4, [5, 6]], [[[7]], 8]].my_flatten).to eq([1, 2, 3, 4, 5, 6, 7, 8])
        end
    end

    describe "Array#my_zip" do
        it "should return a new array, with each element containing the merged elements at that index" do
            a = [ 4, 5, 6 ]
            b = [ 7, 8, 9 ]
            c = [ 10, 11, 12 ]
            d = [ 13, 14, 15 ]

            expect([1, 2, 3].my_zip(a, b)).to eq([[1, 4, 7], [2, 5, 8], [3, 6, 9]])
            expect([1, 2].my_zip(a, b)).to eq([[1, 4, 7], [2, 5, 8]])
            expect([1, 2].my_zip(a, b, c, d)).to eq([[1, 4, 7, 10, 13], [2, 5, 8, 11, 14]])
        end

        it "should return nil for the location if the size of any argument is less than self" do
            a = [ 4, 5, 6 ]
            b = [ 7, 8, 9 ]

            expect(a.my_zip([1,2], [8])).to eq([[4, 1, 8], [5, 2, nil], [6, nil, nil]])
        end
    end

    describe "Array#my_rotate" do
        it "should return a new array containing all the elements of the original array in a rotated order" do
            a = [ "a", "b", "c", "d" ]

            expect(a.my_rotate).to eq(["b", "c", "d", "a"])
            expect(a.my_rotate(2)).to eq(["c", "d", "a", "b"])
            expect(a.my_rotate(-3)).to eq(["b", "c", "d", "a"])
            expect(a.my_rotate(15)).to eq(["d", "a", "b", "c"])
        end
    end

    describe "Array#my_join" do
        it "should take an optional string argument" do
            expect { [ "a", "b", "c", "d" ].my_join }.to_not raise_error
            expect { [ "a", "b", "c", "d" ].my_join("$") }.to_not raise_error
        end

        it "should return a single string containing all the elements of the array, separated by the given string separator" do
            a = [ "a", "b", "c", "d" ]
            
            expect(a.my_join).to eq("abcd")
            expect(a.my_join("$")).to eq("a$b$c$d")
        end
    end

    describe "Array#my_reverse" do
        it "should return a new array containing all the elements of the original array in reverse order" do
            expect([ "a", "b", "c" ].my_reverse).to eq(["c", "b", "a"])
            expect([ 1 ].my_reverse ).to eq([1])
        end
    end

    describe "#factors" do
        it "returns factors of 10 in order" do
            expect(factors(10)).to eq([1, 2, 5, 10])
        end
      
        it "returns just two factors for primes" do
            expect(factors(13)).to eq([1, 13])
        end
    end

    describe "#bubble_sort!" do
        let(:array) { [1, 2, 3, 4, 5].shuffle }
    
        it "works with an empty array" do
            expect([].bubble_sort!).to eq([])
        end
    
        it "works with an array of one item" do
            expect([1].bubble_sort!).to eq([1])
        end
    
        it "sorts numbers" do
            expect(array.bubble_sort!).to eq(array.sort)
        end
    
        it "modifies the original array" do
            duped_array = array.dup
            array.bubble_sort!
            expect(duped_array).not_to eq(array)
        end
    
        it "will use a block if given" do
            sorted = array.bubble_sort! do |num1, num2|
                # order numbers based on descending sort of their squares
                num2**2 <=> num1**2
            end
        
            expect(sorted).to eq([5, 4, 3, 2, 1])
        end
    end

    describe "#bubble_sort" do
        let(:array) { [1, 2, 3, 4, 5].shuffle }
    
        it "delegates to #bubble_sort!" do
            expect_any_instance_of(Array).to receive(:bubble_sort!)
        
            array.bubble_sort
        end
    
        it "does not modify the original array" do
            duped_array = array.dup
            array.bubble_sort
            expect(duped_array).to eq(array)
        end
    end

    describe "substrings" do
        it "should accept a string as an arg" do
            expect { substrings("jump") }.to_not raise_error
        end
    
        it "should return an array containing all substrings of the given string" do
            expect(substrings("jump")).to match_array ["j", "ju", "jum", "jump", "u", "um", "ump", "m", "mp", "p"]
            expect(substrings("abc")).to match_array ["a", "ab", "abc", "b", "bc", "c"]
            expect(substrings("x")).to match_array ["x"]
        end
    end

    describe "#subwords" do
        it "can find a simple word" do
            words = subwords("asdfcatqwer", ["cat", "car"])
            expect(words).to eq(["cat"])
        end
      
        it "doesn't find spurious words" do
            words = subwords("batcabtarbrat", ["cat", "car"])
            expect(words).to be_empty
        end
      
        it "can find words within words" do
        #note that the method should NOT return duplicate words
            dictionary = ["bears", "ear", "a", "army"]
            words = subwords("erbearsweatmyajs", dictionary)
        
            expect(words).to eq(["bears", "ear", "a"])
        end
    end
end