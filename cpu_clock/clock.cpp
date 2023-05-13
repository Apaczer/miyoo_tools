#include <stdint.h>
#include <iostream>
#include <bitset>
#include <stdlib.h>
#include <tuple>
using namespace std;

tuple<int, int> calc_multip(float mhz) {
    float mul ;
//  mhz = 864;
#if !defined(OC_TABLE) && !defined(OC_CHOICES)
    cout << "\nif clock is=" << mhz << "MHz";
#endif
    int d[]={1,2,3,4,6,8,12,16};
    for (int i=0;i<8;i++){
    	mul = mhz / 24 * d[i] ;
    	if (mul == (int)mul) {
        	int m = (int)mul;
        	if ( (m <= 32 ) || (((m > 32) && (!(m % 2) || !(m % 3) || !(m % 4))) && (m <= 128))) {
#if !defined(OC_TABLE) && !defined(OC_CHOICES)
       	    cout << "\nfor divf=" << d[i] << " the mul=" << m;
#endif
        	return {m, d[i]};
        	} 
#if !defined(OC_TABLE) && !defined(OC_CHOICES)
			else {
     	    cout << "\nfor divf=" << d[i] << " there is no mul";
        	}

    	} else {
          	cout << "\nfor divf=" << d[i] << " the mul is non integer value!";
#endif
    	}
    }
    return {0,0};
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
        if((n <= 32) && (n * k == mul)) break;
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

#if defined(OC_CHOICES)
	printf("%d,",y);
#elif defined(OC_TABLE)
	cout << "(" << y << " << 18) | (" << n_v - 1 << " << 8) | (" << k_v - 1 << " << 4) | (" << m_v - 1 << ") | (" << p_v << " << 16),\n" ;
#else
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
    cout << "\n\noc_table[] string:\n(" << y << " << 18) | (" << n_v - 1 << " << 8) | (" << k_v - 1 << " << 4) | (" << m_v - 1 << ") | (" << p_v << " << 16) \n" ;
#endif
}

void out(int mhz){
#if !defined(OC_TABLE) && !defined(OC_CHOICES)
    int mul, divf;
// type "mhz" value to output possible "mul,divf" values
    cout << "Type \"mhz\":" ;
    cin >> mhz ;
#endif
    auto [MUL, DIVF] = calc_multip(mhz);  
	clock(MUL,DIVF); 
}

int main() {
    int i;
#if defined(OC_TABLE) || defined(OC_CHOICES)
    for (i=200; i <= 1023; i++) 
#endif
    out(i);
}
