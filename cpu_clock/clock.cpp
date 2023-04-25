#include <stdint.h>
#include <iostream>
#include <bitset>

void calc_multip(float mhz) {
    float mul ;
//  mhz = 864;
    std::cout << "\nif clock is=" << mhz << "MHz";
    mul = mhz / 24 ;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=1 the mul=" << m;
        } else {
        std::cout << "\nfor divf=1 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
    mul = mhz / 24 * 2;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=2 the mul=" << m;
        } else {
        std::cout << "\nfor divf=2 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
    mul = mhz / 24 * 3;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=3 the mul=" << m;
        } else {
        std::cout << "\nfor divf=3 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
    mul = mhz / 24 * 4;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=4 the mul=" << m;
        } else {
        std::cout << "\nfor divf=4 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
    mul = mhz / 24 * 4;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=4 the mul=" << m;
        } else {
        std::cout << "\nfor divf=4 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
    mul = mhz / 24 * 6;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=6 the mul=" << m;
        } else {
        std::cout << "\nfor divf=6 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
    mul = mhz / 24 * 8;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=8 the mul=" << m;
        } else {
        std::cout << "\nfor divf=8 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
    mul = mhz / 24 * 12;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=12 the mul=" << m;
        } else {
        std::cout << "\nfor divf=12 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
    mul = mhz / 24 * 16;
    if (mul == (int)mul) {
        int m = (int)mul;
        if ( (m <= 31 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        std::cout << "\nfor divf=16 the mul=" << m;
        } else {
        std::cout << "\nfor divf=16 there is no mul";
        }
    } else {
        std::cout << "\nmul is non integer value!";
    }
}

void clock(uint8_t mul, uint8_t divf) {

//  mul = 108;
//  divf = 3;
    if((mul == 0) || (divf == 0)) return ;
    if((mul > 128) || (divf > 16)) return ;

    uint8_t n, k, m, p;
    // mul = n*k
    // n = 1..32
    // k = 1..4
    for(k = 1; k <= 4; k++) {
        n = mul / k;
        if((n < 32) && (n * k == mul)) break;
    }
    if(n * k != mul) return;
    // div = m*p
    // m = 1..4
    // k = 1,2,4


    
    for(m = 1; m <= 4; m++) {
        p = divf / m;
        if(((p == 1) || (p == 2) || (p == 4)) && (m * p == divf)) break;
    }
    if(m * p != divf) return;
    int y = ((24*n*k)/(m*p));
    int n_v = n;
    int k_v = k;
    int m_v = m;
    int p_v = p;
    int M = mul;
    int D = divf;
    
    p--;
    if(p == 3) p = 2;

    uint32_t value = (1 << 31) |((n - 1) << 8) | ((k - 1) << 4) | (m - 1) | (p << 16);

    std::cout << "\n\n32bit_reg_value=" << std::bitset<32>(value)  << std::endl;
    
    std::cout << y << "MHz=" << "=24Mhz*mul/divf" << "=24*" << M << "/" << D; 
    std::cout << "\nn_factor=" << n_v - 1;
    std::cout << "\nk_factor=" << k_v - 1;
    std::cout << "\nm_factor=" << m_v - 1;
    std::cout << "\np_factor=" << p_v - 1;
    std::cout << "\noc_table[] string:\n((" << y << ") << 18) | (" << n_v - 1 << " << 8) | (" << k_v - 1 << " << 4) | (" << m_v - 1 << ") | (" << p_v -1 << " << 16) \n" ;
}

int main() {
    int mhz, mul, divf;
    std::cout << "Type \"mhz\":" ;
    std::cin >> mhz ;
    std::cout << "Type \"mul\":";
    std::cin >> mul ;
    std::cout << "Type \"divf\":";
    std::cin >> divf ;
    calc_multip(mhz); // type "mhz" value to output possible "mul,divf" values
	clock(mul,divf); // type "mul,divf" values to output N,K,M,P factors for oc_table[]
}