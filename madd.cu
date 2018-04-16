/*
Submitted By: Sulav Timsina
ID: 50502493
Course: CS 6253  Heterogeneous Computing
Spring , 2018
Submitted On; 04/16/2018
*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>


/*   Array to print an array to Console
    arr = pointer to array
    dimen = 1-D size of array
*/
void printArray(int *arr, int dimen){
    //printing vectors
    int i;
    for ( i = 0; i < dimen*dimen; i++){
      printf("%d ",arr[i]);
      if((i+1) % dimen == 0)
        printf("\n");    
    }
}

/*   CUDA Kernel function to add the elements of two arrays on the GPU
     n = 1-D size of the array
     a, b = 
*/
__global__ void kernel1(int n, int *a, int *b, int *c){
  
  int index = threadIdx.x;
  int stride = blockDim.x;
  
  for( int i = index; i < n*n; i += stride){
    c[i] = a[i] + b[i];
  }
}

__global__ void kernel2(int n, int *a, int *b, int *c){

  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for( int i = index; i < n*n; i += stride){
    c[i] = a[i] + b[i];
  }
}

__global__ void kernel3(int n, int *a, int *b, int *c){
  
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for( int i = index; i < n*n; i += stride){
    c[i] = a[i] + b[i];
  }
}



int main(int argc, char* argv[] ){
  //size of vector
  int n = 8;
  int N = n * n;  
  
  // Host input vectors
  int *h_a, *h_b;
  // Host output vectors
  int *h_c;
  // Device input vectors
  int *d_a, *d_b;
  // Device output vectors
  int *d_c;
  
  // Allocate memory for each vector of host
  h_a = (int*)malloc(N * sizeof(int));
  h_b = (int*)malloc(N * sizeof(int));
  h_c = (int*)malloc(N * sizeof(int));

  // Allocate memory for each vector of device
  cudaMalloc( &d_a, N * sizeof(int) );
  cudaMalloc( &d_b, N * sizeof(int) );
  cudaMalloc( &d_c, N * sizeof(int) );
  
  // Initialize vectors on host
  int i, j;
  for ( i = 0; i < n; i++){
    for ( j = 0; j < n; j++){
      h_a[i*n + j] = i + j;
      h_b[i*n + j] = i + j;
    }  
  }
  
  // Print Vector a
  printf("Vector a:\n");
  printArray(h_a, n); 
  // Print Vector b
  printf("\nVector b:\n");
  printArray(h_b, n);
   
  // Copy host vectors to device
  cudaMemcpy( d_a, h_a, N * sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy( d_b, h_b, N * sizeof(int), cudaMemcpyHostToDevice);
  
  /****************************************************************************/
  // Run the kernel1 function on the GPU
  kernel1<<<1,256>>>(n, d_a, d_b, d_c);
    
  // Copy array C back to host memory
  cudaMemcpy( h_c, d_c, N * sizeof(int), cudaMemcpyDeviceToHost );
  
  //Print Vector c
  printf("\nVector c(Output of kernel1):\n");
  printArray(h_c, n);
  /****************************************************************************/
  
  //kernel 2 call
  int blockSize = 16;
  int numBlocks = 4;
  kernel2<<<numBlocks, blockSize>>>(n, d_a, d_b, d_c);
  
  // Copy array C back to host memory
  cudaMemcpy( h_c, d_c, N * sizeof(int), cudaMemcpyDeviceToHost );
  
  //Print Vector c
  printf("\nVector c(Output of kernel2):\n");
  printArray(h_c, n);
  /****************************************************************************/
  //kernel 3 call
  blockSize = 4;
  numBlocks = 16;
  kernel3<<<numBlocks, blockSize>>>(n, d_a, d_b, d_c);  
  
  // Copy array C back to host memory
  cudaMemcpy( h_c, d_c, N * sizeof(int), cudaMemcpyDeviceToHost );
  
  //Print Vector c
   printf("\nVector c(Output of kernel3):\n");
  printArray(h_c, n);
  
    // Release device memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
 
    // Release host memory
    free(h_a);
    free(h_b);
    free(h_c);
 
    return 0;  
}