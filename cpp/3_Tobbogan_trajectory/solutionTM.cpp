/* Author: Thomas Mortier
 */
#include <chrono>
#include <string>
#include <fstream>
#include <iostream>

int main(int argc, char** argv)
{
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    unsigned int slopes[5][2] = {{1,1},{3,1},{5,1},{7,1},{1,2}};
    unsigned long ind[5] {0}, cntr[5] {0};
    unsigned long l {0};
    try 
    {
        unsigned long i {0};
        while (std::getline(in, line))
        {
            if (l==0)
                l=line.length();
            for (unsigned int j=0; j<=sizeof(slopes)/sizeof(slopes[0]); j+=1)
            {
                if ((line[ind[j]]=='#')&&(i%slopes[j][1]==0))
                    cntr[j]+=1;
                if (i%slopes[j][1]==0)
                    ind[j]=(ind[j]+slopes[j][0])%l;
            }
            i+=1;
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    unsigned long prod {1};
    for (auto& cnt: cntr)
        prod*=cnt;
    std::cout << cntr[1] << ' ' << prod << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " ms\n"; 
    return 0;
}
