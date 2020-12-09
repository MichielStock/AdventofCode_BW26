/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <vector>
#include <algorithm>

const unsigned int PREAMBLE {25};

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::vector<unsigned long> nums;
    unsigned int i {0};
    unsigned long num {0}, sum {0};
    try 
    { 
        while (std::getline(in, line))
        {
            num = std::stoi(line);
            if (nums.size()>=PREAMBLE)
            {
                bool fnd {false};
                for (unsigned long j=i;j<nums.size();j++)
                {
                    if (std::find(nums.begin()+i,nums.end(),num-nums[j])!=nums.end())
                    {
                        fnd = true;
                        break;
                    }
                }
                if (fnd==false)
                    break;
                i+=1;
            }
            nums.push_back(num);
        } 
        unsigned long csum {nums[0]}, start {0}, end;
        for (end=1;end<=nums.size();end++)
        {
            while (csum>num && start<end-1)
            {
                csum = csum-nums[start];
                start++;
            }
            if (csum==num)
                break;
            if (end<nums.size())
                csum+=nums[end];
        }
        unsigned long min {*std::min_element(nums.begin()+start,nums.begin()+end-1)};
        unsigned long max {*std::max_element(nums.begin()+start,nums.begin()+end-1)};
        sum = min+max;
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Number = " << num << '\n';
    std::cout << "Sum = " << sum << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
