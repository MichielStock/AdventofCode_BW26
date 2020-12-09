/* Author: Thomas Mortier
 */
#include <chrono>
#include <string>
#include <fstream>
#include <iostream>
#include <map>

int main(int argc, char** argv)
{
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    unsigned long cntr1 {0}, cntr2 {0};
    try 
    {
        while (std::getline(in, line))
        {
            auto ldspos {line.find('-')}, lsppos {line.find(' ')}, lsepos {line.find(": ")};
            unsigned int l {static_cast<unsigned int>(std::stoul(line.substr(0,ldspos)))};
            unsigned int h {static_cast<unsigned int>(std::stoul(line.substr(ldspos+1,lsppos)))};
            std::string c {line.substr(lsppos+1,lsepos-lsppos-1)};
            std::string psw {line.substr(lsepos+2)}; 
            std::map<char, unsigned long> cnt_dict {};
            for (char const& cc: psw) 
                cnt_dict[cc]+=1;
            if (cnt_dict.find(c[0])!=cnt_dict.end()) 
                cntr1+=int((cnt_dict[c[0]]-l)<=(h-l));
            if (int(psw[l-1]==c[0])+int(psw[h-1]==c[0])==1)
                cntr2+=1;
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << cntr1 << ' ' << cntr2 << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " ms\n"; 
    return 0;
}
