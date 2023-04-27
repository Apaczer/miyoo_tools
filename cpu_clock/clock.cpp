#include <stdint.h>
#include <iostream>
#include <bitset>
#include <stdlib.h>
#include <tuple>
using namespace std;

tuple<int, int> calc_multip(float mhz) {
    float mul ;
    int d ;
//  mhz = 864;
    cout << "\nif clock is=" << mhz << "MHz";
    mul = mhz / 24 ;
    if (mul == (int)mul) {
        int m = (int)mul;
        d = 1;
        if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        cout << "\nfor divf=1 the mul=" << m;
        return {m, d};
        } else {
        cout << "\nfor divf=1 there is no mul";
        }
    } else {
        cout << "\nfor divf=1 the mul is non integer value!";
    }
    mul = mhz / 24 * 2;
    if (mul == (int)mul) {
        int m = (int)mul;
        d = 2;
        if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        cout << "\nfor divf=2 the mul=" << m;
        return {m, d};
        } else {
        cout << "\nfor divf=2 there is no mul";
        }
    } else {
        cout << "\nfor divf=2 the mul is non integer value!";
    }
    mul = mhz / 24 * 3;
    if (mul == (int)mul) {
        int m = (int)mul;
        d = 3;
        if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        cout << "\nfor divf=3 the mul=" << m;
        return {m, d};
        } else {
        cout << "\nfor divf=3 there is no mul";
        }
    } else {
        cout << "\nfor divf=3 the mul is non integer value!";
    }
    mul = mhz / 24 * 4;
    if (mul == (int)mul) {
        int m = (int)mul;
        d = 4;
        if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        cout << "\nfor divf=4 the mul=" << m;
        return {m, d};
        } else {
        cout << "\nfor divf=4 there is no mul";
        }
    } else {
        cout << "\nfor divf=4 the mul is non integer value!";
    }
    mul = mhz / 24 * 6;
    if (mul == (int)mul) {
        int m = (int)mul;
        d = 6;
        if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        cout << "\nfor divf=6 the mul=" << m;
        return {m, d};
        } else {
        cout << "\nfor divf=6 there is no mul";
        }
    } else {
        cout << "\nfor divf=6 the mul is non integer value!";
    }
    mul = mhz / 24 * 8;
    if (mul == (int)mul) {
        int m = (int)mul;
        d = 8;
        if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        cout << "\nfor divf=8 the mul=" << m;
        return {m, d};
        } else {
        cout << "\nfor divf=8 there is no mul";
        }
    } else {
        cout << "\nfor divf=8 the mul is non integer value!";
    }
    mul = mhz / 24 * 12;
    if (mul == (int)mul) {
        int m = (int)mul;
        d = 12;
        if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        cout << "\nfor divf=12 the mul=" << m;
        return {m, d};
        } else {
        cout << "\nfor divf=12 there is no mul";
        }
    } else {
        cout << "\nfor divf=12 the mul is non integer value!";
    }
    mul = mhz / 24 * 16;
    if (mul == (int)mul) {
        int m = (int)mul;
        d = 16;
        if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
        cout << "\nfor divf=16 the mul=" << m;
        return {m, d};
        } else {
        cout << "\nfor divf=16 there is no mul";
        exit(0) ;
        }
    } else {
        cout << "\nfor divf=16 the mul is non integer value!";
        exit(0) ;
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
    for(k = 4; k >= 1; k--) {
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
    int M = mul;
    int D = divf;
    
    p--;
    if(p == 3) p = 2;
    int p_v = p;

    uint32_t pll_unlocked = (1 << 31) | ((n - 1) << 8) | ((k - 1) << 4) | (m - 1) | (p << 16);

    cout << "\n\n32bit_reg_value for write PLL=" << bitset<32>(pll_unlocked) << endl;
    printf("in hexadecimal write PLL = 0x%X\n",pll_unlocked);
    
    uint32_t pll_locked = (1 << 31) | (1 << 28) | ((n - 1) << 8) | ((k - 1) << 4) | (m - 1) | (p << 16);

    cout << "\n\n32bit_reg_value for read PLL=" << bitset<32>(pll_locked) << endl;
    printf("in hexadecimal read PLL = 0x%X\n\n",pll_locked);
    
    cout << y << "MHz=" << "=24Mhz*mul/divf" << "=24*" << M << "/" << D; 
    cout << "\nn_factor=" << n_v - 1;
    cout << "\nk_factor=" << k_v - 1;
    cout << "\nm_factor=" << m_v - 1;
    cout << "\np_factor=" << p_v;
    cout << "\n\noc_table[] string:\n((" << y << ") << 18) | (" << n_v - 1 << " << 8) | (" << k_v - 1 << " << 4) | (" << m_v - 1 << ") | (" << p_v << " << 16) \n" ;
}

int main() {
// type "mhz" value to output possible "mul,divf" values   
    int mhz, mul, divf;
    cout << "Type \"mhz\":" ;
    cin >> mhz ;

    auto [MUL, DIVF] = calc_multip(mhz);  
// type "mul,divf" values to output N,K,M,P factors for oc_table[]  
/*    cout << "\n\nType \"mul\":";
    cin >> mul ;
    cout << "Type \"divf\":";
    cin >> divf ;
*/
	clock(MUL,DIVF); 
}
