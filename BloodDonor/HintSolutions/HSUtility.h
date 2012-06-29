/*--------------------------------------------------*/

#ifndef HSUtilityHeader
#define HSUtilityHeader

/*--------------------------------------------------*/

#define HS_SWAP(TYPE, A, B) { TYPE T = A; A = B; B = T; }
#define HS_SWAP_IS_MORE(TYPE, A, B) if(A > B) { TYPE T = A; A = B; B = T; }
#define HS_SWAP_IS_LESS(TYPE, A, B) if(A < B) { TYPE T = A; A = B; B = T; }

/*--------------------------------------------------*/

#endif

/*--------------------------------------------------*/