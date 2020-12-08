/* Author: Thomas Mortier
 */
#include <chrono>
#include <string>
#include <fstream>
#include <iostream>
#include <algorithm>

const unsigned int NROW {128}, NCOL {8};

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    unsigned int hseatid {0}, sumid {0}, loid {(((NROW-2)*8)+(NCOL-1))}, hiid {0};
    try 
    {
        while (std::getline(in, line))
        {
            unsigned int startind {0}, stopind {NROW-1}, seatid {0};
            for (auto& c: line)
            {
                if (((c=='L')||(c=='R'))&&(seatid==0))
                {
                    seatid = (line[6]=='F' ? startind : stopind)*8;
                    startind = 0;
                    stopind = NCOL-1;
                }
                if ((c=='F')||(c=='L'))
                    stopind = (stopind+startind)/2;
                else if ((c=='B')||(c=='R'))
                    startind = (stopind+startind+2)/2;
                else
                {
                    std::cerr << "Wrong format for row specifier!\n";
                    exit(1);
                }
            }
            seatid += (line[9]=='L' ? startind : stopind);
            sumid += seatid;
            loid = (seatid<loid ? seatid : loid);
            hiid = (seatid>hiid ? seatid : hiid);
        }
        
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Highest seat ID: " << hiid << '\n'; 
    std::cout << "Your seat ID: " << (((hiid*(hiid+1))/2)-((loid*(loid-1))/2))-sumid << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::milliseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " ms\n"; 
    return 0;
}
