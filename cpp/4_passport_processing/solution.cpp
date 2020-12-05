/* Author: Thomas Mortier
 */
#include <chrono>
#include <string>
#include <fstream>
#include <iostream>
#include <set>
#include <regex>

const std::set<std::string> F {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"};

bool checkfield(std::string fid, std::string fval)
{
    bool valid {false};
    if (fid.compare("byr")==0)
        valid = (1920<=std::stoi(fval))&&(std::stoi(fval)<=2002);
    else if (fid.compare("iyr")==0)
        valid = (2010<=std::stoi(fval))&&(std::stoi(fval)<=2020);
    else if (fid.compare("eyr")==0)
        valid = (2020<=std::stoi(fval))&&(std::stoi(fval)<=2030);
    else if (fid.compare("hgt")==0)
    {
        if (regex_match(fval,std::regex("^.*(in|cm)$")))
        {
            std::string hgttype {fval.substr(fval.length()-2,2)};
            unsigned int hgtval {static_cast<unsigned int>(std::stoul(fval.substr(0,fval.length()-2)))};
            if (hgttype.compare("cm")==0)
                valid = (150<=hgtval)&&(hgtval<=193);
            else if (hgttype.compare("in")==0)
                valid = (59<=hgtval)&&(hgtval<=76);
        }
    }
    else if (fid.compare("hcl")==0)
        valid = regex_match(fval,std::regex("^#[0-9a-f]{6}$"));
    else if (fid.compare("ecl")==0)
        valid = regex_match(fval,std::regex("^(amb|blu|brn|gry|grn|hzl|oth)$"));
    else if (fid.compare("pid")==0)
        valid = regex_match(fval,std::regex("^[0-9]{9}$"));
    else if (fid.compare("cid")==0)
        valid = true;
    return valid;
}

unsigned int checkpsw(std::string psw)
{
    bool valid {true}, found {false};
    for (auto& f: F)
    {
        unsigned long ind {0};
        found = false;
        while (ind!=std::string::npos)
        {
            std::string idval {psw.substr(ind,psw.length()-ind)};
            auto pospswsp {psw.substr(ind,psw.length()-ind).find(' ')};
            if (pospswsp!=std::string::npos)
                idval = psw.substr(ind,pospswsp);
            std::string fid {idval.substr(0,idval.find(':'))};
            std::string fval {idval.substr(idval.find(':')+1)};
            if (f.compare(fid)==0)
                found = true;
            valid = checkfield(fid, fval);
            if (valid!=true)
                break; 
            ind = (pospswsp==std::string::npos ? std::string::npos : ind+pospswsp+1);
        }
        if ((valid!=true)||(found!=true))
            break;
    }
    return (valid&&found);
}

int main(int argc, char** argv)
{
    auto t1 = std::chrono::high_resolution_clock::now();
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::string psw {""};
    unsigned long cntr {0};
    try 
    {
        while (std::getline(in, line))
        {
            if (line.compare("")==0)
            {
                cntr += checkpsw(psw.substr(0,psw.size()-1));
                psw = "";
            }
            else
                psw += line + ' ';
        }
        cntr += checkpsw(psw.substr(0,psw.size()-1));
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    std::cout << cntr << std::endl;
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::milliseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " ms\n"; 
    return 0;
}
