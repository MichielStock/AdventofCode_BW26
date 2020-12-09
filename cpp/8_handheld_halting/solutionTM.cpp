/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <vector>
#include <tuple>
#include <algorithm>

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::vector<std::tuple<std::string, signed int>> stack {};
    std::vector<signed int> exclist {}, swaplist {-1};
    std::vector<unsigned int> acclist {};
    signed int acc {0};
    bool inf {true};
    try 
    { 
        unsigned int i {0};
        while (std::getline(in, line))
        {
            std::string op {line.substr(0,line.find(" "))};
            signed int arg {std::stoi(line.substr(line.find(" ")+2))};
            arg = (line.substr(line.find(" ")+1,1).compare("+")==0 ? arg : -1*arg);
            if ((op.compare("jmp")==0)||(op.compare("nop")==0))
                swaplist.push_back(i);
            std::tuple<std::string, signed int> command {op, arg};
            stack.push_back(command);
            i+=1;
        } 
        for (auto& swapinstr: swaplist)
        {
            inf = false;
            acc = 0;
            std::vector<unsigned int> exclist {};
            for (unsigned int i=0;i<stack.size();i++)
            {
                exclist.push_back(i);
                std::string op {std::get<0>(stack[i])};
                if (i==swapinstr)
                    op=(op.compare("jmp")==0 ? "nop" : "jmp");
                if (op.compare("acc")==0)
                    acc+=std::get<1>(stack[i]);
                else if (op.compare("jmp")==0)
                {
                    if (std::find(exclist.begin(),exclist.end(),i+std::get<1>(stack[i]))!=exclist.end())
                    {
                        inf = true;
                        break;
                    }
                    else
                        i+=std::get<1>(stack[i])-1;
                }
            }
            acclist.push_back(acc);
            if (inf!=true)
                break;
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Accumulator 1 = " << acclist[0] << '\n';
    std::cout << "Accumulator 2 = " << acclist.back() << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
