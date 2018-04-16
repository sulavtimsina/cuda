/*
Submitted By: Sulav Timsina
ID: 50502493
Course: CS 6253  Heterogeneous Computing
Spring , 2018
Submitted On; 04/16/2018
*/
/*
The device property can also be found from command line using the command:
lshw -C display
*/
#include <stdio.h> 

int main() {
  int nDevices;
  
  cudaGetDeviceCount(&nDevices);
  
  printf("Number of GPUs %d\n",nDevices);
  printf("***************************\n***************************\n");
  
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    /*prop is a structure which contains different properties of processors as its element*/
    cudaGetDeviceProperties(&prop, i);
    printf("Device Number: %d\n", i);
    printf("  Device name: %s\n", prop.name);
    
    printf("  Memory Clock Rate (KHz): %d\n",
           prop.memoryClockRate);
           
    printf("  Memory Bus Width (bits): %d\n",
           prop.memoryBusWidth);
           
    printf("  Peak Memory Bandwidth (GB/s): %f\n",
           2.0*prop.memoryClockRate*(prop.memoryBusWidth/8)/1.0e6);
           
    printf("  Multiprocessor Count: %d\n",
           prop.multiProcessorCount);
           
    printf("  Maximum no. of register available to a thread block: %d\n",
           prop.regsPerBlock);
           
    printf("  Maximum no. of threads per block: %d\n",
           prop.maxThreadsPerBlock);
           
    printf("  Concurrent Kernels%d\n",
           prop.concurrentKernels);
           
    if(prop.integrated)
      printf("The device is integrated in the motherboard\n");
    else
      printf("The device is NOT integrated in the motherboard\n");
    printf("***************************\n***************************\n");
  }
}