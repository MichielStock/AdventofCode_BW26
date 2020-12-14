/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <stdlib.h>
#include <string>
#include <vector>


unsigned long inv(unsigned long a, unsigned long m)
{
    unsigned long m0 {m},t,q; 
    unsigned long x0=0,x1=1; 
    if (m == 1) 
       return 0; 
    while (a > 1) 
    { 
        q=a/m;  
        t=m;  
        m=a%m,a=t;  
        t=x0;  
        x0=x1-q*x0;  
        x1=t; 
    } 
    if (x1 < 0) 
       x1 += m0; 
    return x1; 
}

unsigned long findmint(std::vector<unsigned long> num, std::vector<unsigned long> rem) 
{ 
    unsigned long prod {1}; 
    for (unsigned long i=0;i<num.size();i++) 
        prod *= num[i];  
    unsigned long result {0}; 
    for (unsigned long i=0;i<num.size();i++) 
    { 
        unsigned long pp=prod/num[i]; 
        result+=rem[i]*inv(pp,num[i])*pp; 
    }  
    return result % prod; 
} 

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    unsigned long t {0}, mindiff {0xffffffff}, minid {0};
    std::vector<unsigned long> rem {}, num {};
    try 
    { 
        unsigned short i {0};
        while (std::getline(in, line))
        {
            if (i==0)
                t = std::stoi(line);
            else
            {
                unsigned long j {0}, n {0};
                while (line.find(',')!=std::string::npos)
                {
                    if (line.at(0)!='x')
                    {
                        n = static_cast<unsigned long>(std::stoi(line.substr(0,line.find(','))));
                        if (t+(n-(t%n))<mindiff)
                        {
                            mindiff = t+(n-(t%n));
                            minid = n;
                        }
                        if (j==0)
                            rem.push_back(0);
                        else
                            rem.push_back(n-(j%n));
                        num.push_back(n);
                    }
                    line.erase(0,line.find(',')+1);
                    j++;
                }
                n = static_cast<unsigned long>(std::stoi(line.substr(0,line.find(','))));
                rem.push_back(n-(j%n));
                num.push_back(n);
            }
            i++;
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Answer 1 = " << minid*(mindiff-t) << '\n';
    std::cout << "Answer 2 = " << findmint(num,rem) << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
