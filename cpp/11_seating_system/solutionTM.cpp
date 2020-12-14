/* Author: Thomas Mortier
 */
#include <chrono>
#include <fstream>
#include <iostream>
#include <vector>
#include <numeric>

unsigned short getnocc1(std::vector<std::vector<short>>& cgrid, unsigned int i, unsigned int j)
{
    unsigned short nocc {0};
    for (short rd=-1;rd<=1;rd++)
    {
        for (short cd=-1;cd<=1;cd++)
        {
            if ((i+rd)>=0&&(i+rd)<=cgrid.size()-1&&((j+cd)>=0)&&((j+cd)<=cgrid[0].size()-1)&&cd<=1&&!(cd==0&&rd==0))
                nocc+=(cgrid[i+rd][j+cd]==2 ? 1 : 0);
        }
    }
    return nocc;
}

unsigned short getnocc2(std::vector<std::vector<short>>& cgrid, unsigned int i, unsigned int j)
{
    unsigned short nocc {0};
    std::vector<bool> stoppedcntr (9,0);
    unsigned short stopcntr {1};
    unsigned int step {1};
    stoppedcntr[4]=true;
    while (stopcntr<9)
    {
        for (short d=0;d<9;d++)
        {
            if (stoppedcntr[d]!=true)
            {
                short r {static_cast<short>(((d/3)-1)*step)};
                short c {static_cast<short>(((d%3)-1)*step)};
                if ((i+r)>=0&&(i+r)<=cgrid.size()-1&&((j+c)>=0)&&((j+c)<=cgrid[0].size()-1))
                {
                    if ((cgrid[i+r][j+c]==2)||(cgrid[i+r][j+c]==1))
                    {
                        nocc += (cgrid[i+r][j+c]==2 ? 1 : 0);
                        stoppedcntr[d]=true;
                        stopcntr++;
                    }
                }
                else
                {
                    stoppedcntr[d]=true;
                    stopcntr++;
                }
            } 
        }
        step++;
    }
    return nocc;
}

int main(int argc, char** argv)
{     
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::vector<std::vector<short>> cgrid1, cgrid2;
    unsigned long noccseats1 {0}, noccseats2 {0};
    try 
    { 
        while (std::getline(in, line))
        {
            std::vector<short> row {};
            for (char& c: line)
                row.push_back((c=='L' ? 1 : 0));
            cgrid1.push_back(row);
            cgrid2.push_back(row);
        }
        bool changed {true};
        while (changed==true)
        {
            std::vector<std::vector<short>> ngrid {cgrid1};
            changed=false;
            noccseats1=0; 
            for (unsigned int i=0; i<cgrid1.size(); i++)
            {
                for (unsigned int j=0; j<cgrid1[0].size(); j++)
                {
                    if (cgrid1[i][j]!=0)
                    {
                        unsigned short nocc {getnocc1(cgrid1,i,j)};
                        if (cgrid1[i][j]==1)
                        {
                            if (nocc==0)
                            {
                                ngrid[i][j]=2;
                                changed=true;
                            }
                        }
                        else
                        {
                            if (nocc>=4)
                            {
                                ngrid[i][j]=1;
                                changed=true;
                            }
                            else
                                noccseats1++;
                        }
                    }
                }
            }
            cgrid1=ngrid;
        }
        changed=true;
        while (changed==true)
        {
            std::vector<std::vector<short>> ngrid {cgrid2};
            changed=false;
            noccseats2=0; 
            for (unsigned int i=0; i<cgrid2.size(); i++)
            {
                for (unsigned int j=0; j<cgrid2[0].size(); j++)
                {
                    if (cgrid2[i][j]!=0)
                    {
                        unsigned short nocc {getnocc2(cgrid2,i,j)};
                        if (cgrid2[i][j]==1)
                        {
                            if (nocc==0)
                            {
                                ngrid[i][j]=2;
                                changed=true;
                            }
                        }
                        else
                        {
                            if (nocc>=5)
                            {
                                ngrid[i][j]=1;
                                changed=true;
                            }
                            else
                                noccseats2++;
                        }
                    }
                }
            }
            cgrid2=ngrid;
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << "Number of occupied seats = " << noccseats1 << '\n';
    std::cout << "Number of occupied seats = " << noccseats2 << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::microseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " mus\n"; 
    return 0;
}
