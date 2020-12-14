/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <cmath>

const double PI {3.14159265};

struct coordinate 
{
    int x {0};
    int y {0};
};

void rotate(coordinate& p, signed int ang)
{
    int cosa {(int)std::cos(ang*PI/180)};
    int sina {(int)std::sin(ang*PI/180)};
    int npx {p.x*cosa + p.y*sina};
    int npy {-p.x*sina + p.y*cosa};
    p.x = npx;
    p.y = npy;
}

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    coordinate p1, p2, w;
    unsigned int d {0};
    w.x = 10;
    w.y = 1;
    try 
    { 
        while (std::getline(in, line))
        {
            unsigned int num {static_cast<unsigned int>(std::stoi(line.substr(1)))};
            switch (line[0])
            {
                case 'N':
                    p1.x += num;
                    w.y += num;
                    break;
                case 'E':
                    p1.y += num;
                    w.x += num;
                    break;
                case 'S':
                    p1.x -= num;
                    w.y -= num;
                    break;
                case 'W':
                    p1.y -= num;
                    w.x -= num;
                    break;
                case 'L':
                    d += (num/90);
                    d = d%4;
                    rotate(w,-num);
                    break;
                case 'R':
                    d -= (num/90);
                    d = d%4;
                    rotate(w,num);
                    break;
                case 'F':
                    if (d==0)
                        p1.y += num;
                    else if (d==1)
                        p1.x += num;
                    else if (d==2)
                        p1.y -= num;
                    else
                        p1.x -= num;
                    p2.x += num*w.x;
                    p2.y += num*w.y;
                    break;
            }
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Manhattan distance = " << std::abs(p1.x)+std::abs(p1.y) << '\n';
    std::cout << "Manhattan distance = " << std::abs(p2.x)+std::abs(p2.y) << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
