/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <cmath>

/* SWAR algorithm
 */
int numofsetbits(uint32_t i)
{
     i = i - ((i >> 1) & 0x55555555);
     i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
     return (((i + (i >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24;
}

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    uint32_t cnts1 {0}, cnts2 {static_cast<uint32_t>(-1)};
    unsigned int cntr1 {0}, cntr2 {0};
    try 
    {
        while (std::getline(in, line))
        {
            if (line.compare("")==0)
            {
                cntr1 += numofsetbits(cnts1);
                cntr2 += numofsetbits(cnts2);
                cnts1 = 0;
                cnts2 = static_cast<uint32_t>(-1); 
            }
            else
            {
                uint32_t l {0};
                for (auto& c: line)
                {
                    cnts1 |= static_cast<uint32_t>(std::pow(2,c-'a'));
                    l |= static_cast<uint32_t>(std::pow(2,c-'a'));
                } 
                cnts2 &= l;
            }        
        }    
        cntr1 += numofsetbits(cnts1);
        cntr2 += numofsetbits(cnts2);
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Sum of counts 1: " << cntr1 << '\n';
    std::cout << "Sum of counts 2: " << cntr2 << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " ms\n"; 
    return 0;
}
