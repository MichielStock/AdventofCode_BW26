/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <unordered_map>
#include <tuple>
#include <unordered_set>
#include <vector>
#include <algorithm>

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::unordered_map<std::string, std::vector<std::string>> map;
    std::unordered_map<std::string, std::vector<std::tuple<std::string,unsigned int>>> rmap;
    std::unordered_set<std::string> visited {};
    unsigned int cntr {0};
    try 
    {
        while (std::getline(in, line))
        {
            std::string val {line.substr(0,line.find(" bags contain "))};
            std::string keys {line.erase(0,line.find(" bags contain ")+14)}, key {""};
            unsigned int len {0}, num {0};
            while (keys.find(" bag")!=std::string::npos)
            {
                len = keys.find(" bag")-keys.find(" ");
                key = keys.substr(keys.find(" ")+1,len-1);
                if (keys.find("no other bags.")==std::string::npos)
                    num = std::stoi(keys.substr(0,keys.find(" ")+1));
                if (map.find(key)==map.end())
                    map[key] = std::vector<std::string>();
                map[key].push_back(val);
                if (rmap.find(val)==rmap.end())
                    rmap[val] = std::vector<std::tuple<std::string,unsigned int>>();
                rmap[val].push_back(std::tuple<std::string, unsigned int>{key, num});
                if (keys.find(", ")!=std::string::npos)
                    keys = keys.erase(0,keys.find(", ")+2);
                else
                    keys = keys.erase(keys.find(" bag"));
            }
        }    
        std::vector<std::string> tovisit {"shiny gold"};
        std::string visit {""};
        while (tovisit.size()!=0)
        {
            visit = tovisit.back();
            tovisit.pop_back();
            visited.insert(visit);
            for (auto& el: map[visit])
                if (std::find(visited.begin(),visited.end(),el)==visited.end())
                    tovisit.push_back(el);
        }
        std::tuple<std::string, unsigned int> visit2 {"shiny gold", 1};
        std::vector<std::tuple<std::string, unsigned int>> tovisit2 {visit2};
        while (tovisit2.size()!=0)
        {
            visit2 = tovisit2.back();
            tovisit2.pop_back();
            for (auto& c: rmap[std::get<0>(visit2)])
            {
                std::tuple<std::string, unsigned int> newn {std::get<0>(c),std::get<1>(c)*std::get<1>(visit2)};
                cntr += std::get<1>(newn);
                tovisit2.push_back(newn);
            }
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Number of bags 1: " << visited.size()-1 << '\n';
    std::cout << "Number of bags 2: " << cntr << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
