/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <vector>

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::vector<unsigned int> nums;
    unsigned int d1 {0}, d2{0};
    unsigned long nset {0};
    try 
    { 
        while (std::getline(in, line))
            nums.push_back(std::stoi(line));
        nums.push_back(0);
        std::sort(nums.begin(),nums.end(),std::greater<unsigned int>());
        std::vector<unsigned long> cntr (nums[0]+1);
        cntr[nums[0]]+=1;
        for (unsigned int i=1;i<nums.size();i++)
        {
            bool set {false};
            for (signed int j=i-1;(j>=0)&&((nums[j]-nums[i])<=3);j--)
            {
                switch (nums[j]-nums[i])
                {
                    case 1: 
                        d1+=1;
                        set = true;
                        break;
                    case 3:
                        if (set!=true)
                            d2+=1;
                        break;
                }
                cntr[nums[i]]+=cntr[nums[j]];
            }
        }
        nset=cntr[0];
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Number 1 = " << d1*(d2+1) << '\n';
    std::cout << "Number of settings = " << nset << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
