#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"

#define mem(nmic, ndata) Xil_In32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR+(ndata)*32+(nmic)*4)

void delay(int n)
{
	while(n--);
}

int lag[6];
int x0, x1;
long xcorr_out[255] = {0};
long max_xcorr = 0;

int i, j, k;

int main()
{
	Xil_Out32(XPAR_AXI_LITE_CTRL_0_S00_AXI_BASEADDR, 0);
	delay(500000);
	while(1)
	{
		Xil_Out32(XPAR_AXI_LITE_CTRL_0_S00_AXI_BASEADDR, 1);
		delay(50000);
		Xil_Out32(XPAR_AXI_LITE_CTRL_0_S00_AXI_BASEADDR, 0);
		delay(500000);
		for(i=0; i<6; i++)
		{
			for(j=0; j<255; j++)
			{
				if(j<128)
				{
					for(k=0; k<128; k++)
					{
						x0 = (k<128) ? (int)((signed long)mem(i, k)/300) : 0;
						x1 = ((k+127-j)<128) ? (int)((signed long)mem(6, k+127-j)/300) : 0;
						xcorr_out[j] += x0 * x1;
					}
				}
				else
				{
					for(k=0; k<128; k++)
					{
						x0 = (k<128) ? (int)((signed long)mem(6, k)/300) : 0;
						x1 = ((j-127+k)<128) ? (int)((signed long)mem(i, j-127+k)/300) : 0;
						xcorr_out[j] += x0 * x1;
					}
				}
				if(xcorr_out[j] >= max_xcorr)
				{
					max_xcorr = xcorr_out[j];
					lag[i] = j - 127;
				}
			}
			for(j=0; j<255; j++)
			{
				xcorr_out[j] = 0;
			}
			max_xcorr = 0;
		}
		for(i=0; i<6; i++)
		{
			printf("------------------------\r\n");
			printf("lag[%d]:  %f(us)  %f(cm)\r\n", i, lag[i]*12.8, lag[i]*0.4352);
		}
		printf("========================\r\n");
		delay(500000);
	}

    return 0;
}
