/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <cmath>
#include <vector>
#include <map>

const unsigned short MASKLEN = 36;

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::map<uint64_t, uint64_t> mem1, mem2;
    uint64_t mand {0}, mor {0};
    std::string msk;
    try 
    { 
        while (std::getline(in, line))
        {
            if (line.find("mask")!=std::string::npos)
            {
                mand = 0;
                mor = 0;
                msk = line.substr(line.find('=')+2);
                for (unsigned short i=0;i<MASKLEN;i++)
                {
                    if (msk[i]=='X')
                        mand|=static_cast<uint64_t>(std::pow(2.0,MASKLEN-1-i));
                    else if (msk[i]=='1')
                        mor|=static_cast<uint64_t>(std::pow(2.0,MASKLEN-1-i));
                }
            }
            else
            {
                unsigned long posbl, posbr;
                posbl=line.find('[');
                posbr=line.find(']');
                uint64_t addr {static_cast<uint64_t>(std::stol(line.substr(posbl+1,posbr-posbl-1)))};
                uint64_t val {static_cast<uint64_t>(std::stoi(line.substr(line.find("= ")+2)))};
                mem1[addr] = ((val&mand)|mor);
                std::vector<uint64_t> addresses;
                addresses.push_back(addr);
                for (unsigned short i=0;i<MASKLEN;i++)
                {
                    if (msk[i]=='X')
                    {
                        unsigned long addrsz {addresses.size()};
                        for (const auto& a: addresses)
                        {  
                            addresses.push_back(a^static_cast<uint64_t>(std::pow(2.0,MASKLEN-1-i)));
                            addresses.push_back(a^static_cast<uint64_t>(0));
                        }
                        addresses.erase(addresses.begin(), addresses.begin()+addrsz);
                    }
                    else if (msk[i]=='1')
                    {
                        for (unsigned long j=0;j!=addresses.size();j++)
                            addresses[j]|=static_cast<uint64_t>(std::pow(2.0,MASKLEN-1-i));
                    }
                }
                for (auto& a: addresses)
                    mem2[a]=val;
            }
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    uint64_t sum1 {0}, sum2 {0};
    for (const auto &p: mem1)
        sum1+=p.second;
    for (const auto &p: mem2)
        sum2+=p.second;
    std::cout << "Sum of all values left in memory 1 = " << sum1 << '\n';
    std::cout << "Sum of all values left in memory 2 = " << sum2 << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
