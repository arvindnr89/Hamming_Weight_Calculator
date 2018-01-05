#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>

#define TOTALFRAMES 105
#define MAX_HAMMING_WEIGHT 31
#define FRAME_LENGTH 1024
#define TOTAL_FRAME_BYTES 128

int bit_position[MAX_HAMMING_WEIGHT];
int bit_vector[FRAME_LENGTH];


void swap(int i, int j){
    int temp = bit_position[i];
    bit_position[i] = bit_position[j];
    bit_position[j] = temp;
}
 
 /* Basic selection sort algorithm */
void mysort(int n){
    int i, j, min_idx;
    for (i = 0; i < n-1; i++){
        min_idx = i;
        for (j = i+1; j < n; j++){
        	if (bit_position[j] < bit_position[min_idx]){
        		 min_idx = j;
        	}
        }
        swap(min_idx,i);
    }
}


int main(){
	printf("Starting Test Vector Generation\n");
	srand(time(NULL));
	int random_number = 0;
	int number_bits = 0;
	FILE *fpos;
	FILE *fbit;
	FILE *fhw;
    fpos = fopen("position.txt", "w+");
    fbit = fopen("bitpos.txt", "w+");
    fhw = fopen("hw.txt", "w+");
	for (int i = 0; i < TOTALFRAMES; ++i){
		memset(bit_vector,0,sizeof(int) * FRAME_LENGTH);
		/* -- Generate a random number for the HW weight between 0 to 31 --- */
		number_bits = rand() % MAX_HAMMING_WEIGHT;
		fprintf(fhw, "%d\n",number_bits);
		/* --- Marker for start bit --- */
		fprintf(fbit,"XXXXXXXX\n");
		/*---- Generate random bit locations beteen 0 to 1023 ------ */
		for (int j = 0; j < number_bits; ++j){
			//Make sure there are no duplicates!
			do
			{
				random_number = (rand() % (FRAME_LENGTH - 1));
			} while (bit_vector[random_number] == 1);
			
			bit_vector[random_number] = 1;
			bit_position[j] = random_number;
		}
		/*--- Sort the random bit locations and write them to file ---*/
		mysort(number_bits);
		for (int j = 0; j < number_bits; ++j){
			fprintf(fpos,"%d\n",bit_position[j]);
		}

		/* Set these bit locations to 1 in the bit vector */
		for (int k = 0; k < number_bits; ++k){
			bit_vector[bit_position[k]] = 1; 
		}

		/*-- Write the bit vector to file one byte at a time from MSB to LSB--*/
		for (int l = 0; l < TOTAL_FRAME_BYTES; ++l){
			for (int m = 7; m >= 0; m--){
				fprintf(fbit,"%d",bit_vector[(l*8) + m]);
			}
			fprintf(fbit,"\n");
		}
	}

	fclose(fpos);
	fclose(fbit);
	fclose(fhw);
	return 0;
}


