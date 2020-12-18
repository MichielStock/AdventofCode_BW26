/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <unordered_map>
#include <vector>

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::unordered_map<unsigned int,std::pair<unsigned int, unsigned int>> visited;
    unsigned long i {1};
    unsigned int num {0};
   try 
    { 
        while (std::getline(in, line))
        {
            while (line.find(',')!=std::string::npos)
            {
                std::pair<unsigned int, unsigned int> pos (0,0);
                num = static_cast<unsigned int>(std::stoi(line.substr(0,line.find(','))));
                pos.first=i;
                visited[num]=pos;
                line.erase(0,line.find(',')+1);
                i++;
            } 
            std::pair<unsigned int, unsigned int> pos (0,0);
            num = static_cast<unsigned int>(std::stoi(line));
            pos.first = i;
            visited[num]=pos;
            i++;
        }
        while (i<30000001)
        {
            if (visited[num].second==0)
                num=0;
            else
            {
                unsigned int oldnum {num};                
                num=visited[num].second-visited[num].first;
                visited[oldnum].first = visited[oldnum].second;
                visited[oldnum].second = 0;
            }
            if (visited.find(num)==visited.end())
            { 
                std::pair<unsigned int, unsigned int> pos (i,0);
                visited[num]=pos;
            }
            else
                visited[num].second=i;
            i++;
            if (i==2021)
                std::cout << "The " << i-1 << "th number = " << num << '\n';
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "The " << i-1 << "th number = " << num << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
